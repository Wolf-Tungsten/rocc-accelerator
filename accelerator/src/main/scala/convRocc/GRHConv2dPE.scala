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

class Mul8bit extends BlackBox {
    val io = IO(new Bundle {
        val A = Input(SInt(8.W))
        val B = Input(SInt(8.W))
        val CLK = Input(Clock())
        val CE = Input(Bool())
        val SCLR = Input(Bool())
        val P = Output(SInt(16.W))
    })
}

class GRHConv2dPE(featureSize:Int, filterSize:Int, mulStage:Int) extends Module {
    val io = IO(new Bundle {
        val sclr = Input(Bool())
        val ce = Input(Bool())
        val featureIn = Input(Vec(filterSize, Vec(featureSize, SInt(8.W))))
        val filterIn = Input(Vec(filterSize, Vec(filterSize, SInt(8.W))))
        val valid = Output(Bool())
        val output = Output(Vec(featureSize - filterSize + 1, SInt(32.W)))
      })
    val stage = RegInit(0.U(5.W)) // 最大30-stage所以5位就够了
    when(io.sclr){
        stage := 0.U
    }.elsewhen(io.ce && !io.sclr){
        stage := stage + 1.U
    }
    io.valid := stage > mulStage.U
    // 数据通路连接
    for( featureCol <- 0 until (featureSize - filterSize + 1) ){
        val mulIP = List.fill(filterSize)(List.fill(filterSize)(Module(new Mul8bit)))
        val mulResult = List.fill(filterSize * filterSize)(Wire(SInt(32.W)))
        for(posRow <- 0 until filterSize){
            for(posCol <- 0 until filterSize){
                val currentMul = mulIP(posRow)(posCol)
                currentMul.io.SCLR := io.sclr
                currentMul.io.CLK := clock
                currentMul.io.CE := io.ce
                currentMul.io.A := io.featureIn(posRow)(featureCol+posCol)
                currentMul.io.B := io.filterIn(posRow)(posCol)
                mulResult(posRow * filterSize + posCol) := currentMul.io.P
            }
        }
        io.output(featureCol) := mulResult.reduce(_ + _)
    }
}