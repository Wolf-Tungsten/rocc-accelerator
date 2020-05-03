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
  val doLoadFeatureRowDMA = funct === UInt(1)
  val doLoadFilter = funct === UInt(2)
  val doPushFeatureRowIntoFifo = funct === UInt(3)
  val doConv = funct === UInt(4)
  val doStoreResult = funct === UInt(4)

  // 状态定义
  val s_idle::s_loadFeatureData::s_loadFeatureDataDMA::s_loadFeatureDataDMAStall::s_loadFilterData::s_storeResultData::s_resp::Nil = Enum(Bits(), 7)
  val state = Reg(init = s_idle)
  cmd.ready := (state === s_idle) // 只允许在 idle 状态接受指令
  io.busy := (state =/= s_idle) && (state =/= s_resp)
  io.resp.valid := (state === s_resp)
  io.interrupt := Bool(false)

  // 寄存器文件定义
  val featureRegFile = Mem(outer.featureSize, SInt(width = 8))   // 特征行寄存器
  val filterRegFile = Mem(outer.filterSize * outer.filterSize, SInt(width = 8)) // 卷积核寄存器
  // 结果寄存器
  val resultSize = outer.featureSize - outer.filterSize + 1
  val resultRegFile = Mem(resultSize, 47.S(16.W)) // 弄个魔法数字便于检验
  
  // 关键寄存器
  val featureRegFileAddr = Mem(xLen / 8, UInt(width = 8)) // 锁存将要写入特征寄存器组的地址
  val featureRegFileData = Mem(xLen / 8, SInt(width = 8)) // 锁存将要写入特征寄存器组的数据
  val featureMemBaseAddr = Reg(0.U(32.W)) // 使用 DMA 读取 feature data 时的内存基地址
  val featureMemPtr = Reg(0.U(32.W)) // 使用 DMA 时 feature data 的活动指针
  val featureRegDmaPending = Reg(init = Vec.fill(outer.featureSize){Bool(false)}) // 标记特征寄存器组访存状态
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
        featureRegFileData(i) := rs2(8 * (i + 1) - 1, 8 * i).asSInt() 
      }
      state := s_loadFeatureData
    }.elsewhen(doLoadFeatureRowDMA){
      featureMemBaseAddr := rs1
      featureMemPtr := 0.U
      featureRegDmaPending.map{ _ := true.B }
      state := s_loadFeatureDataDMA
    }.elsewhen(doStoreResult){
      resultStore_rd := cmd.bits.inst.rd
      for(i <- 0 until (xLen / 16)){ // i <- 0,1
        resultRegFileAddr(i) := rs1(8 * (i + 1) - 1, 8 * i) // (7, 0) (15, 8)
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

  io.mem.req.valid := (state === s_loadFeatureDataDMA)

  when(state === s_loadFeatureDataDMA){
    io.mem.req.bits.addr := featureMemBaseAddr + featureMemPtr - 1.U
    io.mem.req.bits.tag := featureMemPtr(7, 0)-1.U// 也许是10到0？
    io.mem.req.bits.cmd := M_XRD // perform a load (M_XWR for stores)
    io.mem.req.bits.size := log2Ceil(1).U // 每次读取一字节
    io.mem.req.bits.signed := Bool(true) // 有符号
    io.mem.req.bits.data := Bits(0) 
    io.mem.req.bits.phys := Bool(false)
    io.mem.req.bits.dprv := cmd.bits.status.dprv
  }
  
  when(io.mem.req.fire() && featureMemPtr < outer.featureSize.U){
    // 内存请求成功时，指针向后偏移
    featureMemPtr := featureMemPtr + 1.U
  }

  when(io.mem.resp.valid){
    // 当内存响应数据时，根据 tag 记录数据，并取消对应位的 pending 状态
    featureRegFile(io.mem.resp.bits.tag(7,0)) := io.mem.resp.bits.data(7,0).asSInt
    featureRegDmaPending(io.mem.resp.bits.tag(7,0)) := false.B
  }

  when(state === s_loadFeatureDataDMA && !featureRegDmaPending.reduce(_ || _)){
    state := s_resp
  }

  when(state === s_storeResultData){
    // io.resp.bits.data := Cat(resultRegFile(resultRegFileAddr(1)), resultRegFile(resultRegFileAddr(0)))
    resultStore_rd_data := Cat(0.U(16.W) ,featureRegFile(resultRegFileAddr(1)).asUInt, featureRegFile(resultRegFileAddr(0)).asUInt)
    // resultStore_rd_data := 0x47.U(32.W)
    // resultStore_rd_data := Cat(0.U(24.W), resultRegFileAddr(0))
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