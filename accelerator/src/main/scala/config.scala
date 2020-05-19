package grh.config

import Chisel._
import freechips.rocketchip.config._
import freechips.rocketchip.devices.debug._
import freechips.rocketchip.devices.tilelink._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import freechips.rocketchip.tile._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util._
import freechips.rocketchip.system._
import freechips.rocketchip.subsystem._

import grh.convRocc._
import grh.activateRocc._
import grh.maxPoolRocc._

class WithGRHRocc extends Config((site, here, up) => {
  case BuildRoCC => List(
    (p: Parameters) => {
        val convAccel = LazyModule(new GRHConvRoccAccel(OpcodeSet.custom0, featureSize = 24, filterSize = 3, mulStage = 3)(p))
        //val accel = LazyModule(new AccumulatorExample(OpcodeSet.custom0, n = 4)(p))
        convAccel
    },
    (p: Parameters) => {
        val activateAccel = LazyModule(new GRHActivateRoccAccel(OpcodeSet.custom1, resolution = 128)(p))
        //val accel = LazyModule(new AccumulatorExample(OpcodeSet.custom0, n = 4)(p))
        activateAccel
    },
    (p: Parameters) => {
        val maxPoolAccel = LazyModule(new GRHMaxPoolRoccAccel(OpcodeSet.custom2)(p))
        //val accel = LazyModule(new AccumulatorExample(OpcodeSet.custom0, n = 4)(p))
        maxPoolAccel
    },
    (p: Parameters) => {
        val accumulator = LazyModule(new AccumulatorExample(OpcodeSet.custom3 , n = 4)(p))
        accumulator
    })
    // (p: Parameters) => {
    //     val counter = LazyModule(new CharacterCountExample(OpcodeSet.custom2)(p))
    //     counter
    // },
    // (p: Parameters) => {
    //   val blackbox = LazyModule(new BlackBoxExample(OpcodeSet.custom3, "RoccBlackBox")(p))
    //   blackbox
    // })
})

class With1TinyRV32Core extends Config((site, here, up) => {
  case XLen => 32
  case RocketTilesKey => List(RocketTileParams(
      core = RocketCoreParams(
        useVM = false,
        useUser = false,
        useSupervisor = false,
        useDebug = true,
        
        mulDiv = Some(MulDivParams(mulUnroll = 8)),
        //dcacheReqTagBits = 10
        ),
      btb = None,
      dcache = Some(DCacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nSets = 64, // 16Kb scratchpad
        nWays = 1,
        nTLBEntries = 4,
        nMSHRs = 0,
        blockBytes = site(CacheBlockBytes))),
      icache = Some(ICacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nSets = 64,
        nWays = 1,
        nTLBEntries = 4,
        blockBytes = site(CacheBlockBytes)))))
  case RocketCrossingKey => List(RocketCrossingParams(
    crossingType = SynchronousCrossing(),
    master = TileMasterPortParams()
  ))
})

class WithNMinisysCores(n: Int) extends Config((site, here, up) => {
  case RocketTilesKey => {
    val slim = RocketTileParams(
      core = RocketCoreParams(
      useVM = true,
      useUser = true,
      useSupervisor = true,
      fpu = Some(FPUParams(
          minFLen = 32,
          fLen = 32,
          divSqrt = true,
          sfmaLatency = 3,
          dfmaLatency = 4
        )),
      mulDiv = Some(MulDivParams(
        mulUnroll = 8,
        mulEarlyOut = true,
        divEarlyOut = true))
      ),
      // btb = None,
      dcache = Some(DCacheParams(
        rowBits = site(SystemBusKey).beatBits,
        nMSHRs = 0,
        blockBytes = site(CacheBlockBytes))),
      icache = Some(ICacheParams(
        rowBits = site(SystemBusKey).beatBits,
        blockBytes = site(CacheBlockBytes))))
    List.tabulate(n)(i => slim.copy(hartId = i))
  }
})


class GRHRV32EmulatorConfig extends Config(new WithGRHRocc ++ new With1TinyRV32Core ++ new WithCoherentBusTopology ++ new BaseConfig)
class GRHRV32FPGAConfig extends Config(new WithGRHRocc ++ new WithJtagDTMSystem ++ new WithRV32 ++ new WithNBigCores(1)  ++ new WithCoherentBusTopology ++ new BaseConfig)
class GRHRV32RBBConfig extends Config(new WithGRHRocc ++ new WithJtagDTMSystem ++ new With1TinyRV32Core ++ new WithCoherentBusTopology ++ new BaseConfig)
class GRHRV64FPGAMinisysConfig extends Config(new WithGRHRocc ++ new WithJtagDTMSystem ++  new WithNMinisysCores(1)  ++ new WithCoherentBusTopology ++ new BaseConfig)
class GRHRV64EmulatorMinisysConfig extends Config(new WithGRHRocc ++  new WithNMinisysCores(1)  ++ new WithCoherentBusTopology ++ new BaseConfig)
class GRHRV64FPGABigConfig extends Config(new WithGRHRocc ++ new WithJtagDTMSystem ++  new WithNBigCores(1)  ++ new WithCoherentBusTopology ++ new BaseConfig)