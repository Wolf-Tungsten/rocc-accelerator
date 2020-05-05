package grh.convRocc

import Chisel._
import chisel3.util.HasBlackBoxResource
import chisel3.experimental.IntParam

class Mul8bitComb extends BlackBox {
  val io = IO(new Bundle {
    val a = Input(SInt(8.W))
    val b = Input(SInt(8.W))
    // val clk = Input(Clock())
    // val ce = Input(Bool())
    // val sclr = Input(Bool())
    val p = Output(SInt(16.W))
  })
}

class Mul8bitCombSim extends Module {
    val io = IO(new Bundle {
    val a = Input(SInt(8.W))
    val b = Input(SInt(8.W))
    // val clk = Input(Clock())
    // val ce = Input(Bool())
    // val sclr = Input(Bool())
    val p = Output(SInt(16.W))
  })
  io.p := io.a * io.b
}

class GRHConv2dPE(featureSize:Int, filterSize:Int, mulStage:Int) extends Module {
    val io = IO(new Bundle {
        val sclr = Input(Bool())
        val featureIn = Input(Vec(filterSize, Vec(featureSize, SInt(8.W))))
        val filterIn = Input(Vec(filterSize, Vec(filterSize, SInt(8.W))))
        val output = Output(Vec(featureSize - filterSize + 1, SInt(32.W)))
      })
    val s_idle=0.U
    val s_clear=1.U
    val s_computing=2.U
    val s_result=3.U
    val state = Reg(init = s_idle)
    // 数据通路连接
    for( featureCol <- 0 until (featureSize - filterSize + 1) ){
        val mulIP = List.fill(filterSize)(List.fill(filterSize)(Module(new Mul8bitCombSim)))
        val mulResult = List.fill(filterSize * filterSize)(Wire(SInt(32.W)))
        for(posRow <- 0 until filterSize){
            for(posCol <- 0 until filterSize){
                val currentMul = mulIP(posRow)(posCol)
                // currentMul.io.sclr := io.sclr
                // clock 连接
                // currentMul.io.ce := (state =/= s_result)
                currentMul.io.a := io.featureIn(posRow)(featureCol+posCol)
                currentMul.io.b := io.filterIn(posRow)(posCol)
                mulResult(posRow * filterSize + posCol) := currentMul.io.p
            }
        }
        io.output(featureCol) := mulResult.reduce(_ + _)
    }
}