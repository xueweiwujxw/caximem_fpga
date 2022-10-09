package xilinxIP

import spinal.core._
import spinal.lib._

import java.io._
import scala.io.Source

import java.nio.file.Paths

class ila(a : List[Int], ilaname : String) extends BlackBox{
  var i = 0
  val io = new Bundle {
    val clk = in Bool()
    val probe = a.map{ x =>
      val ret = in Bits(x bits)
      ret.setName(s"probe${i}")
      i = i + 1
      ret
    }
  }

  mapCurrentClockDomain(io.clk)
  noIoPrefix()
  this.setDefinitionName("ila_"+ilaname)
  println("name:ila_"+ilaname+",width:"+a)

  def outTCL(name : String,a : List[Int]) = {
    val tcl = new PrintWriter(new File("vivadoIla_"+ name +".tcl" ))
    //val tcl = new java.io.FileWriter(Paths.get("vivadoIP.tcl").toFile)
    val createIlaCmd=s"set ilaExit [lsearch -exact [get_ips ila*] ila_${name}]\n" +
      s"if { $$ilaExit <0} {\n" +
      s"create_ip -name ila -vendor xilinx.com -library ip -module_name ila_${name}\n" +
      s"}\n"
    //tcl.write("create_ip -name ila -vendor xilinx.com -library ip -module_name ila_" + name + "\n")
    tcl.write(createIlaCmd)
    tcl.write("set_property -dict [list")
    PrintTcl(createIlaCmd)
    //PrintTcl("create_ip -name ila -vendor xilinx.com -library ip -module_name ila_" + name + "\n")
    PrintTcl("set_property -dict [list")
    var i = 0
    a.map{ x =>
      tcl.write(" CONFIG.C_PROBE" + i + "_WIDTH {" + x + "}")
      PrintTcl(" CONFIG.C_PROBE" + i + "_WIDTH {" + x + "}")
      i = i + 1
    }
    tcl.write(" CONFIG.C_NUM_OF_PROBES {" + i + "}] [get_ips ila_" + name + "]\n")
    PrintTcl(" CONFIG.C_NUM_OF_PROBES {" + i + "}] [get_ips ila_" + name + "]\n")

    tcl.close()
  }
  outTCL(ilaname,a)
}

object ila{
  def outTCLwithDepth(name : String,depth : Int,a : List[Int]) = {
    val tcl = new PrintWriter(new File("vivadoIla_"+name+".tcl" ))
    //val tcl = new java.io.FileWriter(Paths.get("vivadoIP.tcl").toFile)
    val createIlaCmd=s"set ilaExit [lsearch -exact [get_ips ila*] ila_${name}]\n" +
      s"if { $$ilaExit <0} {\n" +
      s"create_ip -name ila -vendor xilinx.com -library ip -module_name ila_${name}\n" +
      s"}\n"
    //tcl.write("create_ip -name ila -vendor xilinx.com -library ip -module_name ila_" + name + "\n")
    tcl.write(createIlaCmd)
    tcl.write("set_property -dict [list CONFIG.C_DATA_DEPTH {" + depth + "}")
    //PrintTcl("create_ip -name ila -vendor xilinx.com -library ip -module_name ila_" + name + "\n")
    PrintTcl(createIlaCmd)
    PrintTcl("set_property -dict [list CONFIG.C_DATA_DEPTH {" + depth + "}")
    var i = 0
    a.map{ x =>
      tcl.write(" CONFIG.C_PROBE" + i + "_WIDTH {" + x + "}")
      PrintTcl(" CONFIG.C_PROBE" + i + "_WIDTH {" + x + "}")
      i = i + 1
    }
    tcl.write(" CONFIG.C_NUM_OF_PROBES {" + i + "}] [get_ips ila_" + name + "]\n")
    PrintTcl(" CONFIG.C_NUM_OF_PROBES {" + i + "}] [get_ips ila_" + name + "]\n")

    tcl.write("set_property -dict [list CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_ADV_TRIGGER {true} CONFIG.ALL_PROBE_SAME_MU_CNT {2} ")
    PrintTcl("set_property -dict [list CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_ADV_TRIGGER {true} CONFIG.ALL_PROBE_SAME_MU_CNT {2} ")
    a.zipWithIndex.map{
      case(x,i)=>
        tcl.write(" CONFIG.C_PROBE"+i+"_MU_CNT {2}")
        PrintTcl(" CONFIG.C_PROBE"+i+"_MU_CNT {2}")
    }
    tcl.write("] [get_ips ila_" + name + "]\n")
    PrintTcl("] [get_ips ila_" + name + "]\n")

    PrintTcl(s"synth_ip [get_ips ila_${name}]\n",1)

    tcl.close()
  }

  def outTCL(name : String,a : List[Int],advancedTrigger : Boolean = false) = {
    val tcl = new PrintWriter(new File("vivadoIla_"+ name +".tcl" ))
    //val tcl = new java.io.FileWriter(Paths.get("vivadoIP.tcl").toFile)
    val createIlaCmd=s"set ilaExit [lsearch -exact [get_ips ila*] ila_${name}]\n" +
      s"if { $$ilaExit <0} {\n" +
      s"create_ip -name ila -vendor xilinx.com -library ip -module_name ila_${name}\n" +
      s"}\n"
    //tcl.write("create_ip -name ila -vendor xilinx.com -library ip -module_name ila_" + name + "\n")
    tcl.write(createIlaCmd)
    tcl.write("set_property -dict [list")
    //PrintTcl("create_ip -name ila -vendor xilinx.com -library ip -module_name ila_" + name + "\n")
    PrintTcl(createIlaCmd)
    PrintTcl("set_property -dict [list")
    var i = 0
    a.map{ x =>
      tcl.write(" CONFIG.C_PROBE" + i + "_WIDTH {" + x + "}")
      PrintTcl(" CONFIG.C_PROBE" + i + "_WIDTH {" + x + "}")
      i = i + 1
    }
    tcl.write(" CONFIG.C_NUM_OF_PROBES {" + i + "}] [get_ips ila_" + name + "]\n")
    PrintTcl(" CONFIG.C_NUM_OF_PROBES {" + i + "}] [get_ips ila_" + name + "]\n")

    if(advancedTrigger){
      tcl.write("set_property -dict [list CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_ADV_TRIGGER {true} CONFIG.ALL_PROBE_SAME_MU_CNT {2} ")
      PrintTcl("set_property -dict [list CONFIG.C_EN_STRG_QUAL {1} CONFIG.C_ADV_TRIGGER {true} CONFIG.ALL_PROBE_SAME_MU_CNT {2} ")
      a.zipWithIndex.map{
        case(x,i)=>
          tcl.write(" CONFIG.C_PROBE"+i+"_MU_CNT {2}")
          PrintTcl(" CONFIG.C_PROBE"+i+"_MU_CNT {2}")
      }
      tcl.write("] [get_ips ila_" + name + "]\n")
      PrintTcl("] [get_ips ila_" + name + "]\n")
    }

    tcl.close()
  }

  def apply[T <: Data](name : String,advancedTrigger : Boolean, signals : T *) = {
    val signalWidths = signals.map(B(_).getWidth).toList
    val vividoIla = new ila(signalWidths, name)

    vividoIla.io.probe.zip(signals).foreach{case(probei, s) =>
      probei := (s.asBits).setName(s.getName() + "_b",true)
    }

    outTCL(name,signalWidths,advancedTrigger)

    vividoIla
  }

  def apply[T <: Data](name : String,  depth : Int, signals : T *) = {
    val signalConvert = signals.flatMap(s =>
      s match {
        case x: Vec[_] => x.toList
        case _ => List(s)
      }
    )
    val signalWidths = signalConvert.map(B(_).getWidth).toList
    val vividoIla = new ila(signalWidths, name)

    vividoIla.io.probe.zip(signalConvert).foreach{case(probei, s) =>
      probei := (s.asBits).setName(s.getName(),true)
    }

    outTCLwithDepth(name,depth,signalWidths)

    vividoIla
  }
}