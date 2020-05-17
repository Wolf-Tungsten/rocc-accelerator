package grh.maxPoolRocc

import Chisel._
import chisel3.experimental.IntParam

class GRHMaxPoolPE extends Module {
    val io = IO(new Bundle {
    val input = Input(Vec(2, Vec(2, SInt(8.W))))
    val output = Output(SInt(8.W))
  })
  val mid0 = Wire(SInt(8.W))
  val mid1 = Wire(SInt(8.W))
  mid0 := Mux(io.input(0)(0) > io.input(0)(1), io.input(0)(0), io.input(0)(1))
  mid1 := Mux(io.input(1)(0) > io.input(1)(1), io.input(1)(0), io.input(1)(1))
  io.output := Mux(mid0 > mid1, mid0, mid1)
}