package grh.maxPoolRocc

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

class GRHMaxPoolRoccAccel(opcodes: OpcodeSet)(implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new GRHMaxPoolRoccAccelModuleImp(this)
}

class GRHMaxPoolRoccAccelModuleImp(outer: GRHMaxPoolRoccAccel)(implicit p: Parameters) extends LazyRoCCModuleImp(outer)
with HasCoreParameters {
    val cmd = io.cmd
    val funct = cmd.bits.inst.funct
    val rs1 = cmd.bits.rs1
    val rs2 = cmd.bits.rs2

    // funct 功能定义
    val doLoadRow0 = funct === UInt(0)
    val doLoadRow1 = funct === UInt(1)
    val doCompute = funct === UInt(2)

    // 寄存器文件定义
    val row0RegFile = Mem(16, SInt(width = 8))
    val row1RegFile = Mem(16, SInt(width = 8))
    val row0MemBaseAddr = Reg(0.U(xLen.W))
    val row1MemBaseAddr = Reg(0.U(xLen.W))
    val row0MemPtr = Reg(0.U(xLen.W)) // 访存 result data 时的活动指针
    val row1MemPtr = Reg(0.U(xLen.W)) // 访存 result data 时的活动指针
    val row0RegDmaPending = Reg(init = Vec.fill(16){Bool(false)}) // 标记访存状态 
    val row1RegDmaPending = Reg(init = Vec.fill(16){Bool(false)}) // 标记访存状态 

    val resultStore_rd = RegInit(0.U(5.W)) // 锁存指令将要写入的 rd 寄存器编号
    val resultStore_rd_data = RegInit(0.U(xLen.W)) // 锁存要写入 rd 的数据，在 s_resp 状态时返回给 Core

    val s_idle::s_loadRow0::s_loadRow1::s_compute::s_resp::Nil = Enum(Bits(), 5)
    val state = Reg(init = s_idle)
    cmd.ready := (state === s_idle)
    io.busy := (state =/= s_idle) && (state =/= s_resp)
    io.resp.valid := (state === s_resp)
    io.mem.req.valid := (state === s_loadRow0) || (state === s_loadRow1)
    io.interrupt := Bool(false)
    io.resp.bits.rd := resultStore_rd
    io.resp.bits.data := resultStore_rd_data

    when(cmd.fire()){
        when(doLoadRow0){
            row0MemBaseAddr := rs1
            row0MemPtr := 0.U
            row0RegDmaPending.map{ _ := true.B }
            state := s_loadRow0
        }.elsewhen(doLoadRow1){
            row1MemBaseAddr := rs1
            row1MemPtr := 0.U
            row1RegDmaPending.map{ _ := true.B }
            state := s_loadRow1
        }.elsewhen(doCompute){
            resultStore_rd := cmd.bits.inst.rd
            state := s_compute
        }.otherwise{
            state := s_resp
        }
    }

    when(io.resp.fire()){
    // 当 Core 和 Rocc 交火时指令执行完成
        state := s_idle
    }

    when(state === s_loadRow0){
        io.mem.req.bits.addr := row0MemBaseAddr + row0MemPtr
        io.mem.req.bits.tag := row0MemPtr(7, 0)// 也许是10到0？
        io.mem.req.bits.cmd := M_XRD // 内存读取
        io.mem.req.bits.size := log2Ceil(8).U // 每次读取8字节
        io.mem.req.bits.signed := Bool(true) // 有符号
        io.mem.req.bits.data := Bits(0) 
        io.mem.req.bits.phys := Bool(false)
        io.mem.req.bits.dprv := cmd.bits.status.dprv
    }

    when(state === s_loadRow1){
        io.mem.req.bits.addr := row1MemBaseAddr + row1MemPtr
        io.mem.req.bits.tag := row1MemPtr(7, 0)// 也许是10到0？
        io.mem.req.bits.cmd := M_XRD // 内存读取
        io.mem.req.bits.size := log2Ceil(8).U // 每次读取8字节
        io.mem.req.bits.signed := Bool(true) // 有符号
        io.mem.req.bits.data := Bits(0) 
        io.mem.req.bits.phys := Bool(false)
        io.mem.req.bits.dprv := cmd.bits.status.dprv
    }

    // 内存系统请求成功时，指针向后偏移
    when(io.mem.req.fire()){
        when(state === s_loadRow0) {
            when(row0MemPtr < 16.U ){
                row0MemPtr := row0MemPtr + 8.U
            }
        }
        when(state === s_loadRow1) {
            when(row1MemPtr < 16.U){
                row1MemPtr := row1MemPtr + 8.U
            }
        }
    }

     // 内存系统响应有效时记录状态
    when(io.mem.resp.valid){
        // 当内存响应数据时，根据 tag 记录数据，并取消对应位的 pending 状态
        when(state === s_loadRow0){
           for(i <- 0 until 8){
                row0RegFile(io.mem.resp.bits.tag(7,0)+i.U) := io.mem.resp.bits.data(7+(i*8),0+(i*8)).asSInt
                row0RegDmaPending(io.mem.resp.bits.tag(7,0)+i.U) := false.B
            }
        }
        when(state === s_loadRow1){
           for(i <- 0 until 8){
                row1RegFile(io.mem.resp.bits.tag(7,0)+i.U) := io.mem.resp.bits.data(7+(i*8),0+(i*8)).asSInt
                row1RegDmaPending(io.mem.resp.bits.tag(7,0)+i.U) := false.B
            }
        }
    }
    
    // 所有内存请求均完成时进入响应状态
    when(state === s_loadRow0 && !row0RegDmaPending.reduce(_ || _)){
        state := s_resp
    }

    when(state === s_loadRow1 && !row1RegDmaPending.reduce(_ || _)){
        state := s_resp
    }

    // 连接PE和数据
    val maxPoolPEs = List.fill(8)(Module(new GRHMaxPoolPE))
    for(i <- 0 until 8){
        maxPoolPEs(i).io.input(0)(0) := row0RegFile(i*2)
        maxPoolPEs(i).io.input(0)(1) := row0RegFile(i*2+1)
        maxPoolPEs(i).io.input(1)(0) := row1RegFile(i*2)
        maxPoolPEs(i).io.input(1)(1) := row1RegFile(i*2+1)
    }
    when(state === s_compute){
        resultStore_rd_data := Cat(
            maxPoolPEs(7).io.output.asSInt,
            maxPoolPEs(6).io.output.asSInt,
            maxPoolPEs(5).io.output.asSInt,
            maxPoolPEs(4).io.output.asSInt,
            maxPoolPEs(3).io.output.asSInt,
            maxPoolPEs(2).io.output.asSInt,
            maxPoolPEs(1).io.output.asSInt,
            maxPoolPEs(0).io.output.asSInt
        )
        state := s_resp
    }
}