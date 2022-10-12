package caximemlib

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.amba4.axis._

import spinal.sim._
import spinal.core.sim._

import spinal.core.fiber.Handle
import spinal.lib.fsm._
import spinal.lib.sim.StreamReadyRandomizer
import xilinxIP.ila
import xilinxIP.PrintTcl

case class CAxiMemTransferH2C(
    h2c_axiconf: Axi4Config,
    h2c_axisconf: Axi4StreamConfig
) extends Component {
  val io = new Bundle {
    val h2c_axi = slave(Axi4(h2c_axiconf))
    val h2c_axis = master(Axi4Stream(h2c_axisconf))
  }

  // Host to chip memory
  val h2c_mem = Mem(
    Bits(h2c_axiconf.dataWidth bits),
    (scala.math.pow(2, h2c_axiconf.addressWidth) / 8).toInt
  )

  // Axi bus
  val h2c_bus = new Axi4SlaveFactory(io.h2c_axi)

  // Channel control
  val h2c_ctrl = h2c_bus
    .createWriteAndReadMultiWord(CAxiMemTransferCtrl(), 0, "H2C control reg")
  h2c_ctrl.enable.init(0)
  h2c_ctrl.size.init(0)

  // Axi and memory interface
  h2c_bus.writeMemWordAligned(h2c_mem, h2c_ctrl.getBitsWidth / 8)

  // Read counter
  val h2c_cnt = Counter(
    start = 0,
    end = (BigInt(1) << (h2c_axiconf.addressWidth - log2Up(8))) - 1,
    inc = h2c_ctrl.enable.asBool && io.h2c_axis.ready
  )

  val memdata = h2c_mem.readSync(h2c_cnt.valueNext)

  io.h2c_axis.data := memdata
  io.h2c_axis.keep := B(h2c_axisconf.dataWidth bits, default -> True)
  io.h2c_axis.valid := h2c_ctrl.enable.asBool

  val cntLast = Bool
  io.h2c_axis.last := cntLast

  when(!(h2c_ctrl.size % h2c_axisconf.dataWidth === 0))(
    cntLast := (h2c_ctrl.size |>> log2Up(h2c_axisconf.dataWidth))
      .resize(h2c_cnt.getBitsWidth) === h2c_cnt && !(h2c_cnt === 0)
  ) otherwise (
    cntLast := (h2c_ctrl.size |>> log2Up(h2c_axisconf.dataWidth))
      .resize(h2c_cnt.getBitsWidth) - 1 === h2c_cnt && !(h2c_cnt === 0)
  )
  when(cntLast) {
    when(!(h2c_ctrl.size % h2c_axisconf.dataWidth === 0))(
      io.h2c_axis.keep := B(
        h2c_axisconf.dataWidth bits,
        default -> True
      ) >> (h2c_axisconf.dataWidth - h2c_ctrl.size % h2c_axisconf.dataWidth)
    ) otherwise (
      io.h2c_axis.keep := B(
        h2c_axisconf.dataWidth bits,
        default -> True
      )
    )
  }

  when(cntLast && io.h2c_axis.ready) {
    h2c_cnt.clear()
    h2c_ctrl.enable := 0
  }
}

case class CAxiMemTransferC2H(
    c2h_axiconf: Axi4Config,
    c2h_axisconf: Axi4StreamConfig
) extends Component {
  val io = new Bundle {
    val c2h_axi = slave(Axi4(c2h_axiconf))
    val c2h_axis = slave(Axi4Stream(c2h_axisconf))
  }

  // Chip to host memory
  val c2h_mem = Mem(
    Bits(c2h_axiconf.dataWidth bits),
    (scala.math.pow(2, c2h_axiconf.addressWidth) / 8).toInt
  )

  // Axi bus
  val c2h_bus = new Axi4SlaveFactory(io.c2h_axi)

  // Channel control
  val c2h_ctrl = c2h_bus
    .createWriteAndReadMultiWord(CAxiMemTransferCtrl(), 0, "C2H control reg")
  c2h_ctrl.enable.init(1)
  c2h_ctrl.size.init(0)

  // Axi and memory interface
  c2h_bus.readSyncMemWordAligned(c2h_mem, c2h_ctrl.getBitsWidth / 8)

  // Write counter
  val c2h_cnt = Counter(
    start = 0,
    end = (BigInt(1) << (c2h_axiconf.addressWidth - log2Up(8))) - 1,
    inc = c2h_ctrl.enable.asBool && io.c2h_axis.fire
  )
  c2h_mem.write(c2h_cnt, io.c2h_axis.data, io.c2h_axis.fire, io.c2h_axis.keep)
  io.c2h_axis.ready := c2h_ctrl.enable.asBool
  val keepLen =
    io.c2h_axis.keep.asBools.map(x => x.asUInt).reduceBalancedTree(_ +^ _)
  when(io.c2h_axis.last && io.c2h_axis.fire) {
    c2h_ctrl.size := (c2h_cnt * c2h_axisconf.dataWidth + keepLen)
      .resize(c2h_ctrl.size.getBitsWidth)
    c2h_ctrl.enable := 0
    c2h_cnt.clear()
  }
}

case class CAxiMemTransferCtrl() extends Bundle {
  val enable = Bits(8 bits) // read ready signal of write finish signal
  val size = UInt(24 bits) // size of reading or writing
}

class CAxiMemTransfer(
    h2c_axiconf: Axi4Config,
    c2h_axiconf: Axi4Config,
    h2c_axisconf: Axi4StreamConfig,
    c2h_axisconf: Axi4StreamConfig
) extends Component {
  val io = new Bundle {
    val h2c_axi = slave(Axi4(h2c_axiconf))
    val c2h_axi = slave(Axi4(c2h_axiconf))

    val h2c_axis = master(Axi4Stream(h2c_axisconf))
    val c2h_axis = slave(Axi4Stream(c2h_axisconf))

    val h2c_irq = out(Bool)
    val c2h_irq = out(Bool)
  }
  // Rename
  Axi4SpecRenamer(io.h2c_axi)
  Axi4SpecRenamer(io.c2h_axi)
  Axi4SpecRenamer(io.h2c_axis)
  Axi4SpecRenamer(io.c2h_axis)

  // Limition
  assert(h2c_axiconf.dataWidth == h2c_axisconf.dataWidth * 8)
  assert(c2h_axiconf.dataWidth == c2h_axisconf.dataWidth * 8)

  // Interrupt
  val h2c_irq = Reg(Bool).init(False)
  val c2h_irq = Reg(Bool).init(False)
  io.h2c_irq := h2c_irq
  io.c2h_irq := c2h_irq
  when(io.h2c_axis.last && io.h2c_axis.fire)(h2c_irq := True)
  when(h2c_irq)(h2c_irq := !RegNext(h2c_irq))
  when(io.c2h_axis.last && io.c2h_axis.fire)(c2h_irq := True)
  when(c2h_irq)(c2h_irq := !RegNext(c2h_irq))

  // h2c axi convert axis process
  val h2c = CAxiMemTransferH2C(h2c_axiconf, h2c_axisconf)
  io.h2c_axi >> h2c.io.h2c_axi
  h2c.io.h2c_axis >/-> io.h2c_axis

  // c2h axis convert axi process
  val c2h = CAxiMemTransferC2H(c2h_axiconf, c2h_axisconf)
  io.c2h_axi >> c2h.io.c2h_axi
  io.c2h_axis >> c2h.io.c2h_axis
  noIoPrefix()

  ila(
    "axis",
    1024,
    io.h2c_axis.valid,
    io.h2c_axis.ready,
    io.h2c_axis.data,
    io.h2c_axis.keep,
    io.h2c_axis.last,
    io.c2h_axis.valid,
    io.c2h_axis.ready,
    io.c2h_axis.data,
    io.c2h_axis.keep,
    io.c2h_axis.last,
    io.h2c_irq,
    io.c2h_irq
  ).setName("axis")

}

object CAxiMemTransferGen extends App {
  SpinalVerilog(
    new CAxiMemTransfer(
      h2c_axiconf = Axi4Config(
        addressWidth = 16,
        dataWidth = 32,
        idWidth = 0,
        useRegion = false
      ),
      c2h_axiconf = Axi4Config(
        addressWidth = 16,
        dataWidth = 32,
        idWidth = 0,
        useRegion = false
      ),
      h2c_axisconf = Axi4StreamConfig(
        dataWidth = 4,
        useLast = true,
        useKeep = true
      ),
      c2h_axisconf = Axi4StreamConfig(
        dataWidth = 4,
        useLast = true,
        useKeep = true
      )
    )
  )
  PrintTcl("./", "ila.tcl")
}

object CAxiMemTransferSim extends App {
  def WriteData(
      clock: Handle[ClockDomain],
      bus: Axi4,
      addr: BigInt,
      data: BigInt,
      strb: BigInt
  ) {
    bus.aw.valid #= true
    bus.aw.addr #= addr
    bus.aw.burst #= 0
    bus.aw.len #= 0
    bus.aw.size #= 2
    bus.w.valid #= true
    bus.w.data #= data
    bus.w.strb #= strb
    bus.w.last #= true
    clock.waitSampling(1)
    bus.aw.valid #= false
    bus.w.valid #= false
    clock.waitSampling()
  }
  def AxiRead(clock: Handle[ClockDomain], bus: Axi4, addr: BigInt) {
    bus.ar.valid #= true
    bus.ar.payload.addr #= addr
    bus.ar.payload.burst #= 1
    bus.ar.payload.size #= 2
    bus.ar.payload.len #= 7
    bus.r.ready #= true
    bus.ar.payload.cache #= 2
    clock.waitSampling(1)
    bus.ar.valid #= false

    clock.waitSampling()
  }
  def WriteInStream(
      stream: Axi4Stream.Axi4Stream,
      clock: Handle[ClockDomain],
      num: Int
  ) {
    var numIn = num

    stream.valid #= true

    while (numIn > 0) {
      stream.valid #= true
      if (numIn <= 4) {
        stream.last #= true
      } else
        stream.last #= false
      var numMut = numIn - 1
      if (numMut > 127) {
        stream.keep #= 0xf
        if (numMut % 128 > 2) {
          stream.data #= ((numMut % 128) << 24 | ((numMut % 128) - 1) << 16 | ((numMut % 128) - 2) << 8 | ((numMut % 128) - 3))
          numIn = numIn - 4
        } else {
          numMut % 128 match {
            case 2 =>
              stream.data #= ((numMut % 128) << 16 | ((numMut % 128) - 1) << 8 | ((numMut % 128) - 2))
              numIn = numIn - 3
            case 1 =>
              stream.data #= ((numMut % 128) << 8 | ((numMut % 128) - 1))
              numIn = numIn - 2
            case 0 =>
              stream.data #= ((numMut % 128))
              numIn = numIn - 1
          }
        }
      } else {
        if (numMut > 2) {
          stream.data #= (numMut << 24 | (numMut - 1) << 16 | (numMut - 2) << 8 | (numMut - 3))
          stream.keep #= 0xf
          numIn = numIn - 4
        } else {
          numMut match {
            case 2 =>
              stream.data #= (numMut << 16 | (numMut - 1) << 8 | (numMut - 2))
              stream.keep #= 0x7
              numIn = numIn - 3
            case 1 =>
              stream.data #= (numMut << 8 | (numMut - 1))
              stream.keep #= 0x3
              numIn = numIn - 2
            case 0 =>
              stream.data #= (numMut)
              stream.keep #= 0x1
              numIn = numIn - 1
          }
        }
      }
      clock.waitSampling()
    }

    stream.valid #= false
    stream.last #= false
    clock.waitSampling()
  }
  SimConfig.withFstWave.doSim(
    new CAxiMemTransfer(
      h2c_axiconf = Axi4Config(
        addressWidth = 16,
        dataWidth = 32,
        idWidth = 0,
        useRegion = false
      ),
      c2h_axiconf = Axi4Config(
        addressWidth = 16,
        dataWidth = 32,
        idWidth = 0,
        useRegion = false
      ),
      h2c_axisconf = Axi4StreamConfig(
        dataWidth = 4,
        useLast = true,
        useKeep = true
      ),
      c2h_axisconf = Axi4StreamConfig(
        dataWidth = 4,
        useLast = true,
        useKeep = true
      )
    )
  ) { dut =>
    dut.clockDomain.forkStimulus(10)

    dut.io.h2c_axi.aw.valid #= false
    dut.io.h2c_axi.aw.addr #= 0
    dut.io.h2c_axi.aw.burst #= 0
    dut.io.h2c_axi.aw.len #= 0
    dut.io.h2c_axi.aw.size #= 0

    dut.io.h2c_axi.w.valid #= false
    dut.io.h2c_axi.w.last #= false

    dut.io.h2c_axi.b.ready #= true

    dut.io.h2c_axi.ar.valid #= false
    dut.io.h2c_axi.ar.addr #= 0
    dut.io.h2c_axi.ar.burst #= 0
    dut.io.h2c_axi.ar.len #= 0
    dut.io.h2c_axi.ar.size #= 0

    dut.io.h2c_axi.r.ready #= true

    dut.io.c2h_axi.aw.valid #= false
    dut.io.c2h_axi.aw.addr #= 0
    dut.io.c2h_axi.aw.burst #= 0
    dut.io.c2h_axi.aw.len #= 0
    dut.io.c2h_axi.aw.size #= 0

    dut.io.c2h_axi.w.valid #= false
    dut.io.c2h_axi.w.last #= false

    dut.io.c2h_axi.b.ready #= true

    dut.io.c2h_axi.ar.valid #= false
    dut.io.c2h_axi.ar.addr #= 0
    dut.io.c2h_axi.ar.burst #= 0
    dut.io.c2h_axi.ar.len #= 0
    dut.io.c2h_axi.ar.size #= 0

    dut.io.c2h_axi.r.ready #= true

    dut.io.h2c_axis.ready #= false
    dut.io.c2h_axis.valid #= false
    dut.io.c2h_axis.last #= false
    dut.clockDomain.waitSampling(10)

    StreamReadyRandomizer(dut.io.h2c_axis, dut.clockDomain)

    WriteData(dut.clockDomain, dut.io.h2c_axi, 0, 0, 0xf)

    WriteData(dut.clockDomain, dut.io.h2c_axi, 4, 0x03020100, 0xf)
    WriteData(dut.clockDomain, dut.io.h2c_axi, 8, 0x07060504, 0xf)
    WriteData(dut.clockDomain, dut.io.h2c_axi, 12, 0x0b0a0908, 0xf)
    WriteData(dut.clockDomain, dut.io.h2c_axi, 16, 0x0f0e0d0c, 0xf)
    WriteData(dut.clockDomain, dut.io.h2c_axi, 20, 0x00000010, 0x1)
    WriteData(dut.clockDomain, dut.io.h2c_axi, 21, 0x00001100, 0x2)
    WriteData(dut.clockDomain, dut.io.h2c_axi, 22, 0x00120000, 0x4)

    WriteData(dut.clockDomain, dut.io.h2c_axi, 0, 0x00001201, 0xf)

    dut.io.h2c_axis.ready #= false

    dut.clockDomain.waitSampling()

    dut.io.h2c_axis.ready #= false

    dut.clockDomain.waitSampling()

    dut.io.h2c_axis.ready #= true

    dut.clockDomain.waitSampling(20)
    dut.io.h2c_axis.ready #= true

    WriteData(dut.clockDomain, dut.io.c2h_axi, 0, 0x00000001, 0xf)
    WriteInStream(dut.io.c2h_axis, dut.clockDomain, 66)

    AxiRead(dut.clockDomain, dut.io.c2h_axi, 68)

    dut.clockDomain.waitSampling(2000)
  }
}
