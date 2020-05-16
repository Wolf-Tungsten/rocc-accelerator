package grh.activateRocc

import Chisel._
import chisel3.experimental.IntParam

class GRHActivatePE(resolution:Int) extends Module {
    val io = IO(new Bundle {
    val mapInput = Input(Vec(resolution, SInt(32.W)))
    val numInput = Input(SInt(32.W))
    val output = Output(SInt(8.W))
  })
  for(i <- 0 until resolution){
      when(io.numInput < io.mapInput(i)){
          io.output := i.S
      }
  }
  when(io.numInput >= io.mapInput(resolution - 1)){
      io.output := 127.S
  }
}