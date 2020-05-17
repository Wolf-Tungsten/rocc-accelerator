package grh.activateRocc

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

class GRHActivateRoccAccel(opcodes: OpcodeSet,
   val resolution:Int = 256
)(implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new GRHActivateRoccAccelModuleImp(this)
}

class GRHActivateRoccAccelModuleImp(outer: GRHActivateRoccAccel)(implicit p: Parameters) extends LazyRoCCModuleImp(outer)
with HasCoreParameters {
    val cmd = io.cmd
    val funct = cmd.bits.inst.funct
    val rs1 = cmd.bits.rs1
    val rs2 = cmd.bits.rs2

    // funct 功能定义
    val doLoadMap = funct === UInt(0)
    val doCompute = funct === UInt(1)
    // 寄存器文件定义
    val mapRegFile = Mem(outer.resolution, SInt(width = 32))
    val mapMemBaseAddr = Reg(0.U(xLen.W))
    val mapMemPtr = Reg(0.U(xLen.W)) // 访存 result data 时的活动指针
    val mapRegDmaPending = Reg(init = Vec.fill(outer.resolution){Bool(false)}) // 标记访存状态 

    val inputNumReg = Mem(4, SInt(width = 32)) // 每条指令可以计算4个SInt32到SInt8的转换
    val outputNumReg = Mem(4, SInt(width = 8))
    val resultStore_rd = RegInit(0.U(5.W)) // 锁存指令将要写入的 rd 寄存器编号
    val resultStore_rd_data = RegInit(0.U(xLen.W)) // 锁存要写入 rd 的数据，在 s_resp 状态时返回给 Core

    val s_idle::s_loadMap::s_compute_0::s_compute_1::s_compute_2::s_compute_3::s_resp::Nil = Enum(Bits(), 7)
    val state = Reg(init = s_idle)
    cmd.ready := (state === s_idle)
    io.busy := (state =/= s_idle) && (state =/= s_resp)
    io.resp.valid := (state === s_resp)
    io.mem.req.valid := (state === s_loadMap)
    io.interrupt := Bool(false)
    io.resp.bits.rd := resultStore_rd
    io.resp.bits.data := resultStore_rd_data

    when(cmd.fire()){
        when(doLoadMap){
            mapMemBaseAddr := rs1
            mapMemPtr := 0.U
            mapRegDmaPending.map{ _ := true.B }
            state := s_loadMap
        }.elsewhen(doCompute){
            resultStore_rd := cmd.bits.inst.rd
            inputNumReg(0) := rs1(31,0).asSInt
            inputNumReg(1) := rs1(63,32).asSInt
            inputNumReg(2) := rs2(31,0).asSInt
            inputNumReg(3) := rs2(63,32).asSInt
            state := s_compute_0
        }.otherwise{
            state := s_resp
        }
    }

    when(io.resp.fire()){
    // 当 Core 和 Rocc 交火时指令执行完成
        state := s_idle
    }

    when(state === s_loadMap){
        io.mem.req.bits.addr := mapMemBaseAddr + mapMemPtr
        io.mem.req.bits.tag := mapMemPtr(7, 0)// 也许是10到0？
        io.mem.req.bits.cmd := M_XRD // 内存读取
        io.mem.req.bits.size := log2Ceil(8).U // 每次读取8字节
        io.mem.req.bits.signed := Bool(true) // 有符号
        io.mem.req.bits.data := Bits(0) 
        io.mem.req.bits.phys := Bool(false)
        io.mem.req.bits.dprv := cmd.bits.status.dprv
    }

    // 内存系统请求成功时，指针向后偏移
    when(io.mem.req.fire()){
        when(state === s_loadMap) {
            when( (mapMemPtr >> 2) < outer.resolution.U ){
                mapMemPtr := mapMemPtr + 8.U
            }
        }
    }

     // 内存系统响应有效时记录状态
    when(io.mem.resp.valid){
        // 当内存响应数据时，根据 tag 记录数据，并取消对应位的 pending 状态
        when(state === s_loadMap){
            mapRegDmaPending(io.mem.resp.bits.tag(7,0)) := false.B
            mapRegFile(io.mem.resp.bits.tag(7,0)) := io.mem.resp.bits.data(31, 0).asSInt
            mapRegDmaPending(io.mem.resp.bits.tag(7,0) + 1.U) := false.B
            mapRegFile(io.mem.resp.bits.tag(7,0) + 1.U) := io.mem.resp.bits.data(63, 32).asSInt
        }
    }
    
    // 所有内存请求均完成时进入响应状态
    when(state === s_loadMap && !mapRegDmaPending.reduce(_ || _)){
        state := s_resp
    }

    // 连接PE和数据
    val activatePE = Module(new GRHActivatePE(outer.resolution))
    for(pos <- 0 until outer.resolution){
        activatePE.io.mapInput(pos) := mapRegFile(pos)
    }
    `
    when(state === s_compute_0){
        activatePE.io.numInput := inputNumReg(0)
        outputNumReg(0) := activatePE.io.output
        state := s_compute_1
    }

    when(state === s_compute_1){
        activatePE.io.numInput := inputNumReg(1)
        outputNumReg(1) := activatePE.io.output
        state := s_compute_2
    }

    when(state === s_compute_2){
        activatePE.io.numInput := inputNumReg(2)
        outputNumReg(2) := activatePE.io.output
        state := s_compute_2
    }

    when(state === s_compute_3){
        activatePE.io.numInput := inputNumReg(3)
        outputNumReg(3) := activatePE.io.output
        resultStore_rd_data := Cat(0.U(32.W), 
        outputNumReg(3).asUInt, outputNumReg(2).asUInt, 
        outputNumReg(1).asUInt, outputNumReg(0).asUInt)
        state := s_resp
    }
}