package grh.activateRocc

import Chisel._
import chisel3.experimental.IntParam

class GRHActivatePE(resolution:Int) extends Module {
    val io = IO(new Bundle {
    val mapInput = Input(Vec(resolution, SInt(32.W)))
    val valueInput = Input(Vec(resolution, SInt(8.W)))
    val numInput = Input(SInt(32.W))
    val output = Output(SInt(8.W))
  })

  val compareResult = Wire(SInt(8.W))
  for(i <- 1 until resolution){
      when(io.numInput >= io.mapInput(i-1) && io.numInput < io.mapInput(i)){
          compareResult := io.valueInput(i)
      }
  }
  io.output := Mux(io.numInput < io.mapInput(0), io.valueInput(0), compareResult)
}