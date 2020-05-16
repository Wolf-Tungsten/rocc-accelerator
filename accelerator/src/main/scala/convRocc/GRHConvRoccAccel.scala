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

  // 一些经常需要访问的信号
  val cmd = io.cmd
  val funct = cmd.bits.inst.funct
  val rs1 = cmd.bits.rs1
  val rs2 = cmd.bits.rs2
  // funct 功能定义
  val doLoadFeatureRow = funct === UInt(0)
  val doLoadFeatureRowDMA = funct === UInt(1)
  val doLoadFilter = funct === UInt(2)
  val doPushFeatureRowIntoFIFO = funct === UInt(3)
  val doConv = funct === UInt(4)
  val doFetchResult = funct === UInt(5)
  val doStoreResult = funct === UInt(6)

  // 寄存器文件定义
  val featureRegFile = Mem(outer.featureSize, SInt(width = 8))   // 特征行寄存器
  val filterRegFile = Mem(outer.filterSize * outer.filterSize, SInt(width = 8)) // 卷积核寄存器
  // 结果寄存器
  val resultSize = outer.featureSize - outer.filterSize + 1
  val resultRegFile = Mem(resultSize, 47.S(32.W)) // 弄个魔法数字便于检验
  
  // 关键寄存器
  // loadFeatureRow 指令相关寄存器
  val featureRegFileAddr = Mem(xLen / 8, UInt(width = 8)) // 锁存将要写入特征寄存器组的地址（来自 rs1）
  val featureRegFileData = Mem(xLen / 8, SInt(width = 8)) // 锁存将要写入特征寄存器组的数据（来自 rs2）
  // loadFeatureRowDMA 指令相关寄存器
  val featureMemBaseAddr = Reg(0.U(xLen.W)) // feature data 行的内存基地址，通过 rs1 传入
  val featureMemPtr = Reg(0.U(xLen.W)) // 访存 feature data 行时的活动指针
  val featureRegDmaPending = Reg(init = Vec.fill(outer.featureSize){Bool(false)}) // 标记访存状态
  // loadFilter 指令相关寄存器
  val filterRegFileAddr = Mem(xLen / 8, UInt(width = 8))
  val filterRegFileData = Mem(xLen / 8, SInt(width = 8))
  // fetchResult 指令相关寄存器
  val resultRegFileAddr = RegInit(0.U(8.W))// 锁存将要访问的结果寄存器组的地址（来自 rs1）
  val resultStore_rd = RegInit(0.U(5.W)) // 锁存指令将要写入的 rd 寄存器编号
  val resultStore_rd_data = RegInit(0.U(xLen.W)) // 锁存要写入 rd 的数据，在 s_resp 状态时返回给 Core
  // storeResult 指令相关寄存器
  val resultMemBaseAddr = Reg(0.U(xLen.W))
  val resultMemPtr = Reg(0.U(xLen.W)) // 访存 result data 时的活动指针
  val resultRegDmaPending = Reg(init = Vec.fill(outer.featureSize){Bool(false)}) // 标记访存状态 

  // 状态定义及相关信号定义
  val s_idle::s_loadFeatureData::s_loadFeatureDataDMA::s_pushFeatureRowIntoFIFO::s_loadFilterData::s_conv::s_fetchResultData::s_storeResultData::s_resp::Nil = Enum(Bits(), 9)
  val state = Reg(init = s_idle)
  cmd.ready := (state === s_idle) // 只允许在 idle 状态接受指令
  io.busy := (state =/= s_idle) && (state =/= s_resp) // 在 idle 状态和 resp 状态时拉低 busy 信号结束指令
  io.resp.valid := (state === s_resp) // 在 resp 状态标记 io.resp 接口 valid，向 Core 返回数据
  io.mem.req.valid := (state === s_loadFeatureDataDMA) || (state === s_storeResultData)
  io.interrupt := Bool(false) // 指令不涉及中断
  io.resp.bits.rd := resultStore_rd
  io.resp.bits.data := resultStore_rd_data

  // 内部模块实例化
  val featureFIFO = Module(new GRHFeatureFIFO(outer.featureSize, outer.filterSize))
  val conv2dPE = Module(new GRHConv2dPE(outer.featureSize, outer.filterSize, outer.mulStage))

  // 状态转换逻辑
  when(cmd.fire()){
    when(doLoadFeatureRow){
      // 功能要求加载特征，并且指定的起始地址不同
      for(i <- 0 until (xLen / 8)){ // i <- 0,1,2,3,4,5,6,7
        featureRegFileAddr(i) := rs1(8 * (i + 1) - 1, 8 * i) // (7,0) (15, 8)
        featureRegFileData(i) := rs2(8 * (i + 1) - 1, 8 * i).asSInt() 
      }
      state := s_loadFeatureData
    }.elsewhen(doLoadFeatureRowDMA){
      featureMemBaseAddr := rs1
      featureMemPtr := 0.U
      featureRegDmaPending.map{ _ := true.B }
      state := s_loadFeatureDataDMA
    }.elsewhen(doLoadFilter){
      filterRegFileAddr(0) := rs1(7, 0)
      filterRegFileData(0) := rs2(7, 0).asSInt
      state := s_loadFilterData
    }.elsewhen(doConv){
      conv2dPE.io.sclr := true.B // 对PE的乘法单元进行复位
      state := s_conv
    }.elsewhen(doFetchResult){
      resultStore_rd := cmd.bits.inst.rd
      resultRegFileAddr := rs1(7, 0)
      state := s_fetchResultData
    }.elsewhen(doPushFeatureRowIntoFIFO){
      state := s_pushFeatureRowIntoFIFO
    }.elsewhen(doStoreResult){
      resultMemBaseAddr := rs1
      resultMemPtr := 0.U
      resultRegDmaPending.map{ _ := true.B }
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
    // 逻辑限制：只有8个地址是依次递增时才会8个都写入，否则只写入前面的
    for(i <- 1 until (xLen / 8)){ // i <- 1,2,3
        when(featureRegFileAddr(i) > featureRegFileAddr(i-1)){
          featureRegFile(featureRegFileAddr(i)) := featureRegFileData(i)
        }
      }
    state := s_resp
  }

  when(state === s_loadFeatureDataDMA){
    io.mem.req.bits.addr := featureMemBaseAddr + featureMemPtr
    io.mem.req.bits.tag := featureMemPtr(7, 0)// 也许是10到0？
    io.mem.req.bits.cmd := M_XRD // 内存读取
    io.mem.req.bits.size := log2Ceil(8).U // 每次读取一字节
    io.mem.req.bits.signed := Bool(true) // 有符号
    io.mem.req.bits.data := Bits(0) 
    io.mem.req.bits.phys := Bool(false)
    io.mem.req.bits.dprv := cmd.bits.status.dprv
  }

  // 特征fifo相关数据通路和逻辑
  featureFIFO.io.push := (state === s_pushFeatureRowIntoFIFO)
  for(i <- 0 until outer.featureSize){
    featureFIFO.io.inputRow(i) := featureRegFile(i)
  }
  when(state === s_pushFeatureRowIntoFIFO){
    state := s_resp
  }

  when(state === s_storeResultData){
    io.mem.req.bits.addr := resultMemBaseAddr + resultMemPtr
    io.mem.req.bits.tag := resultMemPtr(7, 0) >> 2
    io.mem.req.bits.cmd := M_XWR // 内存写入
    io.mem.req.bits.size := log2Ceil(8).U // 每次写入8字节
    io.mem.req.bits.signed := Bool(true) // 有符号
    //io.mem.req.bits.data := Cat(resultRegFile((resultMemPtr(7, 0) >> 2)).asUInt, resultRegFile(resultMemPtr(7, 0) >> 2).asUInt)
    io.mem.req.bits.data := Cat(resultRegFile((resultMemPtr(7, 0)>>2)+1.U).asUInt, resultRegFile((resultMemPtr(7, 0)>>2)).asUInt)
    // io.mem.req.bits.data := Cat(98.U(32.W), 47.U(32.W))
    // io.mem.req.bits.data := Cat((resultMemPtr >> 2)(31, 0), 0.U(24.W), featureRegFile((resultMemPtr(7, 0) >> 2)).asUInt)
    io.mem.req.bits.phys := Bool(false)
    io.mem.req.bits.dprv := cmd.bits.status.dprv
  }
  
  // 内存系统请求成功时，指针向后偏移
  when(io.mem.req.fire()){
    when(state === s_loadFeatureDataDMA  && featureMemPtr < outer.featureSize.U){
      featureMemPtr := featureMemPtr + 8.U
    }
    when(state === s_storeResultData) {
      when( (resultMemPtr >> 2) < resultSize.U ){
        resultMemPtr := resultMemPtr + 8.U
      }.otherwise{
        state := s_resp
      }
    }
  }

  // 内存系统响应有效时记录状态
  when(io.mem.resp.valid){
    // 当内存响应数据时，根据 tag 记录数据，并取消对应位的 pending 状态
    when(state === s_loadFeatureDataDMA){
      for(i <- 0 until 8){
        featureRegFile(io.mem.resp.bits.tag(7,0)+i.U) := io.mem.resp.bits.data(7+(i*8),0+(i*8)).asSInt
        featureRegDmaPending(io.mem.resp.bits.tag(7,0)+i.U) := false.B
      }
    }
    when(state === s_storeResultData){
      resultRegDmaPending(io.mem.resp.bits.tag(7,0)) := false.B
      resultRegDmaPending(io.mem.resp.bits.tag(7,0) + 1.U) := false.B
    }
  }

  // 访存完成，指令响应
  when(state === s_loadFeatureDataDMA && !featureRegDmaPending.reduce(_ || _)){
    state := s_resp
  }

  // 载入 filter 数据
  when(state === s_loadFilterData){
    filterRegFile(filterRegFileAddr(0)) := filterRegFileData(0)
    state := s_resp
  }

  when(state === s_fetchResultData){
    // io.resp.bits.data := Cat(resultRegFile(resultRegFileAddr(1)), resultRegFile(resultRegFileAddr(0)))
    // resultStore_rd_data := Cat(0.U(16.W) ,featureRegFile(resultRegFileAddr(1)).asUInt, featureRegFile(resultRegFileAddr(0)).asUInt)
    // resultStore_rd_data := Cat(featureRegFile(resultRegFileAddr(1)).asUInt, featureRegFile(resultRegFileAddr(0)).asUInt, featureFIFO.io.dataOut(2)(resultRegFileAddr(1)).asUInt, featureFIFO.io.dataOut(2)(resultRegFileAddr(0)).asUInt)
    // resultStore_rd_data := 0x47.U(32.W)
    // resultStore_rd_data := Cat(0.U(24.W), resultRegFileAddr(0))
    resultStore_rd_data := resultRegFile(resultRegFileAddr).asUInt
    state := s_resp
  }

  // Conv2D 计算
  // sclr 信号
  conv2dPE.io.ce := (state === s_conv)
  // 特征输入
  conv2dPE.io.featureIn := featureFIFO.io.dataOut
  // 卷积核输入
  for(row <- 0 until outer.filterSize){
    for(col <- 0 until outer.filterSize){
      conv2dPE.io.filterIn(row)(col) := filterRegFile(row * outer.filterSize + col)
    }
  }
  when(state === s_conv){
    conv2dPE.io.sclr := false.B
    when(conv2dPE.io.valid) {
      // 计算完成时
      for(i <- 0 until resultSize){
        resultRegFile(i) := conv2dPE.io.output(i)
      }
      state := s_resp
    }
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