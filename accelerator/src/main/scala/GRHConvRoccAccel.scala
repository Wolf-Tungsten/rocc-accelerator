package grh.convRocc

import Chisel._
import chisel3.util.HasBlackBoxResource
import chisel3.experimental.IntParam

import freechips.rocketchip.config._
import freechips.rocketchip.subsystem._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.InOrderArbiter
import freechips.rocketchip.tile._

class GRHConvRoccAccel(opcodes: OpcodeSet,
val featureSize: Int = 256,
val filterSize: Int = 3,
val mulStage: Int = 3
)(implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new GRHConvRoccAccelModuleImp(this)
}

class GRHConvRoccAccelModuleImp(outer: GRHConvRoccAccel)(implicit p: Parameters) extends LazyRoCCModuleImp(outer)
    with HasCoreParameters {

  // val cmd = Queue(io.cmd)
  val funct = io.cmd.bits.inst.funct
  val rs1 = io.cmd.bits.rs1
  // funct 定义
  val doLoadFeatureRow = funct === UInt(0)
  val doLoadFilter = funct === UInt(1)
  val doPushFeatureRowIntoFifo = funct === UInt(2)
  val doConv = funct === UInt(3)
  val doStoreResult = funct === UInt(4)

  // 状态定义
  val s_idle::s_loadFeatureData::s_loadFilterData::s_storeResultData::Nil = Enum(5)
  val state = RegInit(s_idle)
  io.cmd.ready := state === s_idle // 只允许在 idle 状态接受指令
  io.busy := false.B

  // 寄存器文件定义
  val featureRegFile = Mem(outer.featureSize, SInt(width = 8))
  val filterRegFile = Mem(outer.filterSize * outer.filterSize, SInt(width = 8))
  val resultSize = outer.featureSize - outer.filterSize + 1
  val resultRegFile = Mem(resultSize, 47.S(16.W)) // 弄个魔法数字便于检验

  // 关键寄存器定义:特征读取
  val r_currentFeatureBaseAddr = RegInit(0.U(xLen.W))
  val r_featureLoadPtr = RegInit(0.U(xLen.W))
  val featureEndAddr = r_currentFeatureBaseAddr + outer.featureSize.U(xLen.W)
  val featureTag = r_featureLoadPtr - r_currentFeatureBaseAddr
  val featureMemRespTag = io.mem.resp.bits.tag(log2Up(outer.featureSize)-1,0) 
  val r_featureDataPending = Reg(init = Vec.fill(outer.featureSize){Bool(false)})

  // 关键寄存器定义:结果写回
  val r_currentResultBaseAddr = RegInit(0.U(xLen.W))
  val r_resultStorePtr = RegInit(0.U(xLen.W))
  val resultEndAddr = r_currentResultBaseAddr + resultSize.U(xLen.W)
  val r_resultDataPending = Reg(init = Vec.fill(resultSize){Bool(false)})

  // 状态转换逻辑
  when(state === s_idle && io.cmd.fire()){
    when(doLoadFeatureRow && (rs1 =/= r_currentFeatureBaseAddr)){
      // 功能要求加载特征，并且指定的起始地址不同
      r_currentFeatureBaseAddr := rs1
      r_featureLoadPtr := rs1
      r_featureDataPending.map{ _ := true.B }
      state := s_loadFeatureData
      io.busy := true.B //开始响应指令
    }.elsewhen(doStoreResult){
      r_currentResultBaseAddr := rs1
      r_resultStorePtr := rs1
      r_resultDataPending.map{ _ := true.B }
      state := s_storeResultData
      io.busy := true.B
    }
  }.elsewhen(state === s_loadFeatureData){
    io.mem.req.valid := true.B
    io.mem.req.bits.addr := r_featureLoadPtr
    io.mem.req.bits.tag := featureTag(9, 0)// 也许是10到0？
    io.mem.req.bits.cmd := M_XRD // perform a load (M_XWR for stores)
    io.mem.req.bits.size := 1.U // 每次读取一字节
    io.mem.req.bits.signed := Bool(true) // 有符号
    io.mem.req.bits.data := Bits(0) // we're not performing any stores...
    io.mem.req.bits.phys := Bool(false)
    io.mem.req.bits.dprv := io.cmd.bits.status.dprv
    io.mem.req.ready := Bool(true) // 时刻准备着接受数据

    when(io.mem.req.fire()){
      // 内存请求成功时，指针向后偏移
      r_featureLoadPtr := r_featureLoadPtr + 1.U
    }
    
    when(io.mem.resp.fire()){
      // 当内存响应数据时，根据 tag 记录数据，并取消对应位的 pending 状态
      featureRegFile(featureMemRespTag) := io.mem.resp.bits.data
      r_featureDataPending(featureMemRespTag) := false.B
    }

    when(r_featureDataPending.reduce(_ || _)){
      // 如果所有数据都成功读取了，指令可以响应
      io.resp.valid := true.B
      io.busy := false.B
      when(io.resp.fire()){
        // 当 Core 和 Rocc 交火时指令执行完成
        state := s_idle
      }
    }
  }.elsewhen(state === s_storeResultData){
    // 写回数据
    io.mem.req.valid := true.B
    io.mem.req.bits.addr := r_resultStorePtr
    io.mem.req.bits.tag := 0.U// 不需要tag
    io.mem.req.bits.cmd := M_XWR // perform a load (M_XWR for stores)
    io.mem.req.bits.size := 2.U // 每次写两字节
    io.mem.req.bits.signed := Bool(true) // 有符号
    //io.mem.req.bits.data := resultRegFile(r_resultStorePtr - r_currentResultBaseAddr)
    // 用于测试，把feature写回去
    io.mem.req.bits.data := featureRegFile((r_resultStorePtr - r_currentResultBaseAddr)(log2Up(outer.featureSize)-1,0))
    io.mem.req.bits.phys := Bool(false)
    io.mem.req.bits.dprv := io.cmd.bits.status.dprv
    when(io.mem.req.fire()){
      // 内存请求成功时
      r_resultStorePtr := r_resultStorePtr + 2.U
      r_resultDataPending((r_resultStorePtr - r_currentResultBaseAddr - 2.U)(log2Up(resultSize)-1,0)) := false.B
    }
    when(r_resultDataPending.reduce(_ || _)){
      // 如果所有数据都保存成功，指令响应
      io.resp.valid := true.B
      io.busy := false.B
      when(io.resp.fire()){
        // 当 Core 和 Rocc 交火时指令执行完成
        state := s_idle
      }
    }
  }
  
}