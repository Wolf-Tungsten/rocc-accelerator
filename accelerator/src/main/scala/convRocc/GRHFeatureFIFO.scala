package grh.convRocc

import chisel3._
import chisel3.util._
import scala.collection._

class GRHFeatureFIFO(featureSize:Int, filterSize:Int) extends Module {
    val io = IO(new Bundle{
        val inputRow = Input(Vec(featureSize, SInt(8.W)))
        val push = Input(Bool())
        val dataOut = Output(Vec(filterSize, Vec(featureSize, SInt(8.W))))
    })

    val regFile = Reg(Vec(filterSize, Vec(featureSize, SInt(8.W))))
    //io.dataOut := regFile
    for(row <- 0 until filterSize){
        for(col <- 0 until featureSize){
            io.dataOut(row)(col) := regFile(row)(col)
        }
    }
    when(io.push){
        io.inputRow.zipWithIndex.map{
            case (element, index) => regFile(0)(index) := element
        }
        for(row <- 1 until filterSize){
            for(col <- 0 until featureSize){
                regFile(row)(col) := regFile(row-1)(col)
            }
        }
    }
}