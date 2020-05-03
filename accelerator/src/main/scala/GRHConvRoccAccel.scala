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

  val cmd = io.cmd
  val funct = cmd.bits.inst.funct
  val rs1 = cmd.bits.rs1
  val rs2 = cmd.bits.rs2
  // funct 定义
  val doLoadFeatureRow = funct === UInt(0)
  //val doLoadFilter = funct === UInt(1)
  //val doPushFeatureRowIntoFifo = funct === UInt(2)
  //val doConv = funct === UInt(3)
  val doStoreResult = funct === UInt(1)

  // 状态定义
  val s_idle::s_loadFeatureData::s_loadFilterData::s_storeResultData::s_resp::Nil = Enum(Bits(), 5)
  val state = Reg(init = s_idle)
  cmd.ready := (state === s_idle) // 只允许在 idle 状态接受指令
  io.busy := (state =/= s_idle) && (state =/= s_resp)
  io.resp.valid := (state === s_resp)
  io.interrupt := Bool(false)
  io.mem.req.valid := Bool(false)

  // 寄存器文件定义
  val featureRegFile = Mem(outer.featureSize, SInt(width = 8))   // 特征行寄存器
  val filterRegFile = Mem(outer.filterSize * outer.filterSize, SInt(width = 8)) // 卷积核寄存器
  // 结果寄存器
  val resultSize = outer.featureSize - outer.filterSize + 1
  val resultRegFile = Mem(resultSize, 47.S(16.W)) // 弄个魔法数字便于检验
  
  // 关键寄存器
  val featureRegFileAddr = Mem(xLen / 8, UInt(width = 8))
  val featureRegFileData = Mem(xLen / 8, SInt(width = 8))
  val filterRegFileAddr = Mem(xLen / 8, UInt(width = 8))
  val filterRegFileData = Mem(xLen / 8, SInt(width = 8))
  val resultRegFileAddr = Mem(xLen / 16, UInt(width = 8))
  val resultStore_rd = RegInit(0.U(5.W))
  val resultStore_rd_data = RegInit(0.U(32.W))

  io.resp.bits.rd := resultStore_rd
  io.resp.bits.data := resultStore_rd_data

  // 状态转换逻辑
  when(cmd.fire()){
    when(doLoadFeatureRow){
      // 功能要求加载特征，并且指定的起始地址不同
      for(i <- 0 until (xLen / 8)){ // i <- 0,1,2,3
        featureRegFileAddr(i) := rs1(8 * (i + 1) - 1, 8 * i) // (7,0) (15, 8)
        featureRegFileData(i) := rs1(8 * (i + 1) - 1, 8 * i).asSInt() 
      }
      state := s_loadFeatureData
    }.elsewhen(doStoreResult){
      resultStore_rd := cmd.bits.inst.rd
      for(i <- 0 until (xLen / 16)){ // i <- 0,1
        resultRegFileAddr(i) := rs1(16 * (i + 1) - 1, 16 * i) // (15, 0) (31, 16)
      }
      state := s_storeResultData
    }.otherwise{
      state := s_resp
    }
  }

  when(io.resp.fire()){
    // 当 Core 和 Rocc 交火时指令执行完成
    state := s_idle
  }

  when(state === s_loadFeatureData){
    featureRegFile(featureRegFileAddr(0)) := featureRegFileData(0)
    // 逻辑限制：只有四个地址是依次递增时才会四个都写入，否则只写入前面的
    for(i <- 1 until (xLen / 8)){ // i <- 1,2,3
        when(featureRegFileAddr(i) > featureRegFileAddr(i-1)){
          featureRegFile(featureRegFileAddr(i)) := featureRegFileData(i)
        }
      }
    state := s_resp
  }
  
  when(state === s_storeResultData){
    // io.resp.bits.data := Cat(resultRegFile(resultRegFileAddr(1)), resultRegFile(resultRegFileAddr(0)))
    // io.resp.bits.data := Cat(0.U(16.W) ,featureRegFile(resultRegFileAddr(1)).asUInt, featureRegFile(resultRegFileAddr(0)).asUInt)
    // resultStore_rd_data := 47.U(32.W)
    state := s_resp
  }
  
  // when(state === s_loadFeatureData){
  //   io.mem.req.valid := true.B
  //   io.mem.req.bits.addr := r_featureLoadPtr
  //   io.mem.req.bits.tag := featureTag(9, 0)// 也许是10到0？
  //   io.mem.req.bits.cmd := M_XRD // perform a load (M_XWR for stores)
  //   io.mem.req.bits.size := 1.U // 每次读取一字节
  //   io.mem.req.bits.signed := Bool(true) // 有符号
  //   io.mem.req.bits.data := Bits(0) // we're not performing any stores...
  //   io.mem.req.bits.phys := Bool(false)
  //   io.mem.req.bits.dprv := cmd.bits.status.dprv

  //   when(io.mem.req.fire()){
  //     // 内存请求成功时，指针向后偏移
  //     r_featureLoadPtr := r_featureLoadPtr + 1.U
  //   }
    
  //   when(io.mem.resp.fire()){
  //     // 当内存响应数据时，根据 tag 记录数据，并取消对应位的 pending 状态
  //     featureRegFile(featureMemRespTag) := io.mem.resp.bits.data.asTypeOf(featureRegFile(featureMemRespTag))
  //     r_featureDataPending(featureMemRespTag) := false.B
  //   }

  //   when(r_featureDataPending.reduce(_ || _)){
  //     // 如果所有数据都成功读取了，指令可以响应
  //     io.resp.valid := true.B
  //     when(io.resp.fire()){
  //       // 当 Core 和 Rocc 交火时指令执行完成
  //       state := s_idle
  //     }
  //   }
  // }
  
  // when(state === s_storeResultData){
  //   // 写回数据
  //   io.mem.req.valid := true.B
  //   io.mem.req.bits.addr := r_resultStorePtr
  //   io.mem.req.bits.tag := 0.U// 不需要tag
  //   io.mem.req.bits.cmd := M_XWR // perform a load (M_XWR for stores)
  //   io.mem.req.bits.size := 2.U // 每次写两字节
  //   io.mem.req.bits.signed := Bool(true) // 有符号
  //   //io.mem.req.bits.data := resultRegFile(r_resultStorePtr - r_currentResultBaseAddr)
  //   // 用于测试，把feature写回去
  //   io.mem.req.bits.data := featureRegFile((r_resultStorePtr - r_currentResultBaseAddr)(log2Up(outer.featureSize)-1,0)).asTypeOf(io.mem.req.bits.data)
  //   io.mem.req.bits.phys := Bool(false)
  //   io.mem.req.bits.dprv := cmd.bits.status.dprv
  //   when(io.mem.req.fire()){
  //     // 内存请求成功时
  //     r_resultStorePtr := r_resultStorePtr + 2.U
  //     r_resultDataPending((r_resultStorePtr - r_currentResultBaseAddr - 2.U)(log2Up(resultSize)-1,0)) := false.B
  //   }
  //   when(r_resultDataPending.reduce(_ || _)){
  //     // 如果所有数据都保存成功，指令响应
  //     io.resp.valid := true.B
  //     when(io.resp.fire()){
  //       // 当 Core 和 Rocc 交火时指令执行完成
  //       state := s_idle
  //     }
  //   }
  // }
  
}