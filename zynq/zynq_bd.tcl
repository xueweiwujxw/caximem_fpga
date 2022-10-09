
################################################################
# This is a generated script based on design: zynq_top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2021.1
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source zynq_top_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z100ffg900-2
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name zynq_top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:gmii_to_rgmii:4.1\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:processing_system7:5.5\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:util_vector_logic:2.0\
xilinx.com:ip:xlconcat:2.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set DDR_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:ddrx_rtl:1.0 DDR_0 ]

  set FIXED_IO_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:display_processing_system7:fixedio_rtl:1.0 FIXED_IO_0 ]

  set GPIO_0_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:gpio_rtl:1.0 GPIO_0_0 ]

  set MDIO_PHY_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 MDIO_PHY_0 ]

  set RGMII_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 RGMII_0 ]

  set c2h_maxi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 c2h_maxi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {31} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.PROTOCOL {AXI4} \
   ] $c2h_maxi

  set h2c_maxi [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:aximm_rtl:1.0 h2c_maxi ]
  set_property -dict [ list \
   CONFIG.ADDR_WIDTH {31} \
   CONFIG.DATA_WIDTH {32} \
   CONFIG.HAS_REGION {0} \
   CONFIG.NUM_READ_OUTSTANDING {8} \
   CONFIG.NUM_WRITE_OUTSTANDING {8} \
   CONFIG.PROTOCOL {AXI4} \
   ] $h2c_maxi


  # Create ports
  set ENET0_EXT_INTIN_0 [ create_bd_port -dir I -type intr ENET0_EXT_INTIN_0 ]
  set_property -dict [ list \
   CONFIG.SENSITIVITY {EDGE_FALLING} \
 ] $ENET0_EXT_INTIN_0
  set FCLK_CLK1_0 [ create_bd_port -dir O -type clk FCLK_CLK1_0 ]
  set_property -dict [ list \
   CONFIG.ASSOCIATED_BUSIF {h2c_maxi:c2h_maxi} \
 ] $FCLK_CLK1_0
  set c2h_irpt [ create_bd_port -dir I -from 0 -to 0 c2h_irpt ]
  set h2c_irpt [ create_bd_port -dir I -from 0 -to 0 h2c_irpt ]
  set peripheral_reset_0 [ create_bd_port -dir O -from 0 -to 0 -type rst peripheral_reset_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_HIGH} \
 ] $peripheral_reset_0

  # Create instance: gmii_to_rgmii_0, and set properties
  set gmii_to_rgmii_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:gmii_to_rgmii:4.1 gmii_to_rgmii_0 ]
  set_property -dict [ list \
   CONFIG.RGMII_TXC_SKEW {0} \
   CONFIG.SupportLevel {Include_Shared_Logic_in_Core} \
 ] $gmii_to_rgmii_0

  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: processing_system7_0, and set properties
  set processing_system7_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0 ]
  set_property -dict [ list \
   CONFIG.PCW_ACT_APU_PERIPHERAL_FREQMHZ {666.666687} \
   CONFIG.PCW_ACT_CAN0_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN1_PERIPHERAL_FREQMHZ {23.8095} \
   CONFIG.PCW_ACT_CAN_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_DCI_PERIPHERAL_FREQMHZ {10.158730} \
   CONFIG.PCW_ACT_ENET0_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_ENET1_PERIPHERAL_FREQMHZ {125.000000} \
   CONFIG.PCW_ACT_FPGA0_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_FPGA1_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_FPGA2_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_FPGA3_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_I2C_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_PCAP_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_QSPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_SDIO_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SMC_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_SPI_PERIPHERAL_FREQMHZ {10.000000} \
   CONFIG.PCW_ACT_TPIU_PERIPHERAL_FREQMHZ {200.000000} \
   CONFIG.PCW_ACT_TTC0_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC0_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK0_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK1_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC1_CLK2_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_ACT_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_ACT_UART_PERIPHERAL_FREQMHZ {100.000000} \
   CONFIG.PCW_ACT_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_ACT_WDT_PERIPHERAL_FREQMHZ {111.111115} \
   CONFIG.PCW_APU_CLK_RATIO_ENABLE {6:2:1} \
   CONFIG.PCW_APU_PERIPHERAL_FREQMHZ {666.666666} \
   CONFIG.PCW_ARMPLL_CTRL_FBDIV {40} \
   CONFIG.PCW_CAN0_BASEADDR {0xE0008000} \
   CONFIG.PCW_CAN0_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN0_HIGHADDR {0xE0008FFF} \
   CONFIG.PCW_CAN0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN0_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN1_BASEADDR {0xE0009000} \
   CONFIG.PCW_CAN1_GRP_CLK_ENABLE {0} \
   CONFIG.PCW_CAN1_HIGHADDR {0xE0009FFF} \
   CONFIG.PCW_CAN1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_CAN1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_CAN1_PERIPHERAL_FREQMHZ {-1} \
   CONFIG.PCW_CAN_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_CAN_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_CAN_PERIPHERAL_VALID {0} \
   CONFIG.PCW_CLK0_FREQ {200000000} \
   CONFIG.PCW_CLK1_FREQ {100000000} \
   CONFIG.PCW_CLK2_FREQ {10000000} \
   CONFIG.PCW_CLK3_FREQ {10000000} \
   CONFIG.PCW_CORE0_FIQ_INTR {0} \
   CONFIG.PCW_CORE0_IRQ_INTR {0} \
   CONFIG.PCW_CORE1_FIQ_INTR {0} \
   CONFIG.PCW_CORE1_IRQ_INTR {0} \
   CONFIG.PCW_CPU_CPU_6X4X_MAX_RANGE {800} \
   CONFIG.PCW_CPU_CPU_PLL_FREQMHZ {1333.333} \
   CONFIG.PCW_CPU_PERIPHERAL_CLKSRC {ARM PLL} \
   CONFIG.PCW_CPU_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_CRYSTAL_PERIPHERAL_FREQMHZ {33.333333} \
   CONFIG.PCW_DCI_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR0 {15} \
   CONFIG.PCW_DCI_PERIPHERAL_DIVISOR1 {7} \
   CONFIG.PCW_DCI_PERIPHERAL_FREQMHZ {10.159} \
   CONFIG.PCW_DDRPLL_CTRL_FBDIV {32} \
   CONFIG.PCW_DDR_DDR_PLL_FREQMHZ {1066.667} \
   CONFIG.PCW_DDR_HPRLPR_QUEUE_PARTITION {HPR(0)/LPR(32)} \
   CONFIG.PCW_DDR_HPR_TO_CRITICAL_PRIORITY_LEVEL {15} \
   CONFIG.PCW_DDR_LPR_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DDR_PERIPHERAL_CLKSRC {DDR PLL} \
   CONFIG.PCW_DDR_PERIPHERAL_DIVISOR0 {2} \
   CONFIG.PCW_DDR_PORT0_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT1_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT2_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_PORT3_HPR_ENABLE {0} \
   CONFIG.PCW_DDR_RAM_BASEADDR {0x00100000} \
   CONFIG.PCW_DDR_RAM_HIGHADDR {0x3FFFFFFF} \
   CONFIG.PCW_DDR_WRITE_TO_CRITICAL_PRIORITY_LEVEL {2} \
   CONFIG.PCW_DM_WIDTH {4} \
   CONFIG.PCW_DQS_WIDTH {4} \
   CONFIG.PCW_DQ_WIDTH {32} \
   CONFIG.PCW_ENET0_BASEADDR {0xE000B000} \
   CONFIG.PCW_ENET0_ENET0_IO {EMIO} \
   CONFIG.PCW_ENET0_GRP_MDIO_ENABLE {1} \
   CONFIG.PCW_ENET0_GRP_MDIO_IO {EMIO} \
   CONFIG.PCW_ENET0_HIGHADDR {0xE000BFFF} \
   CONFIG.PCW_ENET0_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_ENET0_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET0_RESET_ENABLE {0} \
   CONFIG.PCW_ENET0_RESET_IO {<Select>} \
   CONFIG.PCW_ENET1_BASEADDR {0xE000C000} \
   CONFIG.PCW_ENET1_ENET1_IO {<Select>} \
   CONFIG.PCW_ENET1_GRP_MDIO_ENABLE {0} \
   CONFIG.PCW_ENET1_GRP_MDIO_IO {<Select>} \
   CONFIG.PCW_ENET1_HIGHADDR {0xE000CFFF} \
   CONFIG.PCW_ENET1_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_ENET1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_ENET1_PERIPHERAL_FREQMHZ {1000 Mbps} \
   CONFIG.PCW_ENET1_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_ENABLE {0} \
   CONFIG.PCW_ENET_RESET_POLARITY {Active Low} \
   CONFIG.PCW_ENET_RESET_SELECT {<Select>} \
   CONFIG.PCW_EN_4K_TIMER {0} \
   CONFIG.PCW_EN_CAN0 {0} \
   CONFIG.PCW_EN_CAN1 {0} \
   CONFIG.PCW_EN_CLK0_PORT {1} \
   CONFIG.PCW_EN_CLK1_PORT {1} \
   CONFIG.PCW_EN_CLK2_PORT {0} \
   CONFIG.PCW_EN_CLK3_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG0_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG1_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG2_PORT {0} \
   CONFIG.PCW_EN_CLKTRIG3_PORT {0} \
   CONFIG.PCW_EN_DDR {1} \
   CONFIG.PCW_EN_EMIO_CAN0 {0} \
   CONFIG.PCW_EN_EMIO_CAN1 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_CD_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_ENET0 {1} \
   CONFIG.PCW_EN_EMIO_ENET1 {0} \
   CONFIG.PCW_EN_EMIO_GPIO {1} \
   CONFIG.PCW_EN_EMIO_I2C0 {0} \
   CONFIG.PCW_EN_EMIO_I2C1 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART0 {0} \
   CONFIG.PCW_EN_EMIO_MODEM_UART1 {0} \
   CONFIG.PCW_EN_EMIO_PJTAG {0} \
   CONFIG.PCW_EN_EMIO_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_SDIO1 {0} \
   CONFIG.PCW_EN_EMIO_SPI0 {0} \
   CONFIG.PCW_EN_EMIO_SPI1 {0} \
   CONFIG.PCW_EN_EMIO_SRAM_INT {0} \
   CONFIG.PCW_EN_EMIO_TRACE {0} \
   CONFIG.PCW_EN_EMIO_TTC0 {0} \
   CONFIG.PCW_EN_EMIO_TTC1 {0} \
   CONFIG.PCW_EN_EMIO_UART0 {0} \
   CONFIG.PCW_EN_EMIO_UART1 {0} \
   CONFIG.PCW_EN_EMIO_WDT {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO0 {0} \
   CONFIG.PCW_EN_EMIO_WP_SDIO1 {0} \
   CONFIG.PCW_EN_ENET0 {1} \
   CONFIG.PCW_EN_ENET1 {0} \
   CONFIG.PCW_EN_GPIO {0} \
   CONFIG.PCW_EN_I2C0 {0} \
   CONFIG.PCW_EN_I2C1 {0} \
   CONFIG.PCW_EN_MODEM_UART0 {0} \
   CONFIG.PCW_EN_MODEM_UART1 {0} \
   CONFIG.PCW_EN_PJTAG {0} \
   CONFIG.PCW_EN_PTP_ENET0 {0} \
   CONFIG.PCW_EN_PTP_ENET1 {0} \
   CONFIG.PCW_EN_QSPI {0} \
   CONFIG.PCW_EN_RST0_PORT {1} \
   CONFIG.PCW_EN_RST1_PORT {1} \
   CONFIG.PCW_EN_RST2_PORT {0} \
   CONFIG.PCW_EN_RST3_PORT {0} \
   CONFIG.PCW_EN_SDIO0 {1} \
   CONFIG.PCW_EN_SDIO1 {0} \
   CONFIG.PCW_EN_SMC {1} \
   CONFIG.PCW_EN_SPI0 {0} \
   CONFIG.PCW_EN_SPI1 {0} \
   CONFIG.PCW_EN_TRACE {0} \
   CONFIG.PCW_EN_TTC0 {0} \
   CONFIG.PCW_EN_TTC1 {0} \
   CONFIG.PCW_EN_UART0 {1} \
   CONFIG.PCW_EN_UART1 {0} \
   CONFIG.PCW_EN_USB0 {0} \
   CONFIG.PCW_EN_USB1 {0} \
   CONFIG.PCW_EN_WDT {0} \
   CONFIG.PCW_FCLK0_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR0 {3} \
   CONFIG.PCW_FCLK0_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK1_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR0 {6} \
   CONFIG.PCW_FCLK1_PERIPHERAL_DIVISOR1 {3} \
   CONFIG.PCW_FCLK2_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK2_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_FCLK3_PERIPHERAL_DIVISOR1 {1} \
   CONFIG.PCW_FCLK_CLK0_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK1_BUF {TRUE} \
   CONFIG.PCW_FCLK_CLK2_BUF {FALSE} \
   CONFIG.PCW_FCLK_CLK3_BUF {FALSE} \
   CONFIG.PCW_FPGA0_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_FPGA1_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_FPGA2_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA3_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_FPGA_FCLK0_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK1_ENABLE {1} \
   CONFIG.PCW_FPGA_FCLK2_ENABLE {0} \
   CONFIG.PCW_FPGA_FCLK3_ENABLE {0} \
   CONFIG.PCW_FTM_CTI_IN0 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN1 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN2 {<Select>} \
   CONFIG.PCW_FTM_CTI_IN3 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT0 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT1 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT2 {<Select>} \
   CONFIG.PCW_FTM_CTI_OUT3 {<Select>} \
   CONFIG.PCW_GP0_EN_MODIFIABLE_TXN {0} \
   CONFIG.PCW_GP0_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP0_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GP1_EN_MODIFIABLE_TXN {0} \
   CONFIG.PCW_GP1_NUM_READ_THREADS {4} \
   CONFIG.PCW_GP1_NUM_WRITE_THREADS {4} \
   CONFIG.PCW_GPIO_BASEADDR {0xE000A000} \
   CONFIG.PCW_GPIO_EMIO_GPIO_ENABLE {1} \
   CONFIG.PCW_GPIO_EMIO_GPIO_IO {2} \
   CONFIG.PCW_GPIO_EMIO_GPIO_WIDTH {2} \
   CONFIG.PCW_GPIO_HIGHADDR {0xE000AFFF} \
   CONFIG.PCW_GPIO_MIO_GPIO_ENABLE {0} \
   CONFIG.PCW_GPIO_MIO_GPIO_IO {<Select>} \
   CONFIG.PCW_GPIO_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_BASEADDR {0xE0004000} \
   CONFIG.PCW_I2C0_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C0_HIGHADDR {0xE0004FFF} \
   CONFIG.PCW_I2C0_I2C0_IO {<Select>} \
   CONFIG.PCW_I2C0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C0_RESET_ENABLE {0} \
   CONFIG.PCW_I2C1_BASEADDR {0xE0005000} \
   CONFIG.PCW_I2C1_GRP_INT_ENABLE {0} \
   CONFIG.PCW_I2C1_HIGHADDR {0xE0005FFF} \
   CONFIG.PCW_I2C1_I2C1_IO {<Select>} \
   CONFIG.PCW_I2C1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_I2C1_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_PERIPHERAL_FREQMHZ {25} \
   CONFIG.PCW_I2C_RESET_ENABLE {0} \
   CONFIG.PCW_I2C_RESET_POLARITY {Active Low} \
   CONFIG.PCW_IMPORT_BOARD_PRESET {None} \
   CONFIG.PCW_INCLUDE_ACP_TRANS_CHECK {0} \
   CONFIG.PCW_INCLUDE_TRACE_BUFFER {0} \
   CONFIG.PCW_IOPLL_CTRL_FBDIV {54} \
   CONFIG.PCW_IO_IO_PLL_FREQMHZ {1800.000} \
   CONFIG.PCW_IRQ_F2P_INTR {1} \
   CONFIG.PCW_IRQ_F2P_MODE {DIRECT} \
   CONFIG.PCW_MIO_0_DIRECTION {out} \
   CONFIG.PCW_MIO_0_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_0_PULLUP {enabled} \
   CONFIG.PCW_MIO_0_SLEW {slow} \
   CONFIG.PCW_MIO_10_DIRECTION {inout} \
   CONFIG.PCW_MIO_10_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_10_PULLUP {enabled} \
   CONFIG.PCW_MIO_10_SLEW {slow} \
   CONFIG.PCW_MIO_11_DIRECTION {inout} \
   CONFIG.PCW_MIO_11_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_11_PULLUP {enabled} \
   CONFIG.PCW_MIO_11_SLEW {slow} \
   CONFIG.PCW_MIO_12_DIRECTION {inout} \
   CONFIG.PCW_MIO_12_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_12_PULLUP {enabled} \
   CONFIG.PCW_MIO_12_SLEW {slow} \
   CONFIG.PCW_MIO_13_DIRECTION {inout} \
   CONFIG.PCW_MIO_13_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_13_PULLUP {enabled} \
   CONFIG.PCW_MIO_13_SLEW {slow} \
   CONFIG.PCW_MIO_14_DIRECTION {in} \
   CONFIG.PCW_MIO_14_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_14_PULLUP {enabled} \
   CONFIG.PCW_MIO_14_SLEW {slow} \
   CONFIG.PCW_MIO_15_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_15_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_15_PULLUP {<Select>} \
   CONFIG.PCW_MIO_15_SLEW {<Select>} \
   CONFIG.PCW_MIO_16_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_16_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_16_PULLUP {<Select>} \
   CONFIG.PCW_MIO_16_SLEW {<Select>} \
   CONFIG.PCW_MIO_17_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_17_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_17_PULLUP {<Select>} \
   CONFIG.PCW_MIO_17_SLEW {<Select>} \
   CONFIG.PCW_MIO_18_DIRECTION {in} \
   CONFIG.PCW_MIO_18_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_18_PULLUP {enabled} \
   CONFIG.PCW_MIO_18_SLEW {slow} \
   CONFIG.PCW_MIO_19_DIRECTION {out} \
   CONFIG.PCW_MIO_19_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_19_PULLUP {enabled} \
   CONFIG.PCW_MIO_19_SLEW {slow} \
   CONFIG.PCW_MIO_1_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_1_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_1_PULLUP {<Select>} \
   CONFIG.PCW_MIO_1_SLEW {<Select>} \
   CONFIG.PCW_MIO_20_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_20_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_20_PULLUP {<Select>} \
   CONFIG.PCW_MIO_20_SLEW {<Select>} \
   CONFIG.PCW_MIO_21_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_21_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_21_PULLUP {<Select>} \
   CONFIG.PCW_MIO_21_SLEW {<Select>} \
   CONFIG.PCW_MIO_22_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_22_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_22_PULLUP {<Select>} \
   CONFIG.PCW_MIO_22_SLEW {<Select>} \
   CONFIG.PCW_MIO_23_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_23_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_23_PULLUP {<Select>} \
   CONFIG.PCW_MIO_23_SLEW {<Select>} \
   CONFIG.PCW_MIO_24_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_24_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_24_PULLUP {<Select>} \
   CONFIG.PCW_MIO_24_SLEW {<Select>} \
   CONFIG.PCW_MIO_25_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_25_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_25_PULLUP {<Select>} \
   CONFIG.PCW_MIO_25_SLEW {<Select>} \
   CONFIG.PCW_MIO_26_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_26_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_26_PULLUP {<Select>} \
   CONFIG.PCW_MIO_26_SLEW {<Select>} \
   CONFIG.PCW_MIO_27_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_27_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_27_PULLUP {<Select>} \
   CONFIG.PCW_MIO_27_SLEW {<Select>} \
   CONFIG.PCW_MIO_28_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_28_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_28_PULLUP {<Select>} \
   CONFIG.PCW_MIO_28_SLEW {<Select>} \
   CONFIG.PCW_MIO_29_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_29_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_29_PULLUP {<Select>} \
   CONFIG.PCW_MIO_29_SLEW {<Select>} \
   CONFIG.PCW_MIO_2_DIRECTION {out} \
   CONFIG.PCW_MIO_2_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_2_PULLUP {disabled} \
   CONFIG.PCW_MIO_2_SLEW {slow} \
   CONFIG.PCW_MIO_30_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_30_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_30_PULLUP {<Select>} \
   CONFIG.PCW_MIO_30_SLEW {<Select>} \
   CONFIG.PCW_MIO_31_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_31_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_31_PULLUP {<Select>} \
   CONFIG.PCW_MIO_31_SLEW {<Select>} \
   CONFIG.PCW_MIO_32_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_32_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_32_PULLUP {<Select>} \
   CONFIG.PCW_MIO_32_SLEW {<Select>} \
   CONFIG.PCW_MIO_33_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_33_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_33_PULLUP {<Select>} \
   CONFIG.PCW_MIO_33_SLEW {<Select>} \
   CONFIG.PCW_MIO_34_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_34_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_34_PULLUP {<Select>} \
   CONFIG.PCW_MIO_34_SLEW {<Select>} \
   CONFIG.PCW_MIO_35_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_35_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_35_PULLUP {<Select>} \
   CONFIG.PCW_MIO_35_SLEW {<Select>} \
   CONFIG.PCW_MIO_36_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_36_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_36_PULLUP {<Select>} \
   CONFIG.PCW_MIO_36_SLEW {<Select>} \
   CONFIG.PCW_MIO_37_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_37_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_37_PULLUP {<Select>} \
   CONFIG.PCW_MIO_37_SLEW {<Select>} \
   CONFIG.PCW_MIO_38_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_38_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_38_PULLUP {<Select>} \
   CONFIG.PCW_MIO_38_SLEW {<Select>} \
   CONFIG.PCW_MIO_39_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_39_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_39_PULLUP {<Select>} \
   CONFIG.PCW_MIO_39_SLEW {<Select>} \
   CONFIG.PCW_MIO_3_DIRECTION {out} \
   CONFIG.PCW_MIO_3_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_3_PULLUP {disabled} \
   CONFIG.PCW_MIO_3_SLEW {slow} \
   CONFIG.PCW_MIO_40_DIRECTION {inout} \
   CONFIG.PCW_MIO_40_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_40_PULLUP {enabled} \
   CONFIG.PCW_MIO_40_SLEW {slow} \
   CONFIG.PCW_MIO_41_DIRECTION {inout} \
   CONFIG.PCW_MIO_41_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_41_PULLUP {enabled} \
   CONFIG.PCW_MIO_41_SLEW {slow} \
   CONFIG.PCW_MIO_42_DIRECTION {inout} \
   CONFIG.PCW_MIO_42_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_42_PULLUP {enabled} \
   CONFIG.PCW_MIO_42_SLEW {slow} \
   CONFIG.PCW_MIO_43_DIRECTION {inout} \
   CONFIG.PCW_MIO_43_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_43_PULLUP {enabled} \
   CONFIG.PCW_MIO_43_SLEW {slow} \
   CONFIG.PCW_MIO_44_DIRECTION {inout} \
   CONFIG.PCW_MIO_44_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_44_PULLUP {enabled} \
   CONFIG.PCW_MIO_44_SLEW {slow} \
   CONFIG.PCW_MIO_45_DIRECTION {inout} \
   CONFIG.PCW_MIO_45_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_45_PULLUP {enabled} \
   CONFIG.PCW_MIO_45_SLEW {slow} \
   CONFIG.PCW_MIO_46_DIRECTION {in} \
   CONFIG.PCW_MIO_46_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_46_PULLUP {enabled} \
   CONFIG.PCW_MIO_46_SLEW {slow} \
   CONFIG.PCW_MIO_47_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_47_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_47_PULLUP {<Select>} \
   CONFIG.PCW_MIO_47_SLEW {<Select>} \
   CONFIG.PCW_MIO_48_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_48_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_48_PULLUP {<Select>} \
   CONFIG.PCW_MIO_48_SLEW {<Select>} \
   CONFIG.PCW_MIO_49_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_49_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_49_PULLUP {<Select>} \
   CONFIG.PCW_MIO_49_SLEW {<Select>} \
   CONFIG.PCW_MIO_4_DIRECTION {inout} \
   CONFIG.PCW_MIO_4_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_4_PULLUP {disabled} \
   CONFIG.PCW_MIO_4_SLEW {slow} \
   CONFIG.PCW_MIO_50_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_50_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_50_PULLUP {<Select>} \
   CONFIG.PCW_MIO_50_SLEW {<Select>} \
   CONFIG.PCW_MIO_51_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_51_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_51_PULLUP {<Select>} \
   CONFIG.PCW_MIO_51_SLEW {<Select>} \
   CONFIG.PCW_MIO_52_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_52_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_52_PULLUP {<Select>} \
   CONFIG.PCW_MIO_52_SLEW {<Select>} \
   CONFIG.PCW_MIO_53_DIRECTION {<Select>} \
   CONFIG.PCW_MIO_53_IOTYPE {<Select>} \
   CONFIG.PCW_MIO_53_PULLUP {<Select>} \
   CONFIG.PCW_MIO_53_SLEW {<Select>} \
   CONFIG.PCW_MIO_5_DIRECTION {inout} \
   CONFIG.PCW_MIO_5_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_5_PULLUP {disabled} \
   CONFIG.PCW_MIO_5_SLEW {slow} \
   CONFIG.PCW_MIO_6_DIRECTION {inout} \
   CONFIG.PCW_MIO_6_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_6_PULLUP {disabled} \
   CONFIG.PCW_MIO_6_SLEW {slow} \
   CONFIG.PCW_MIO_7_DIRECTION {out} \
   CONFIG.PCW_MIO_7_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_7_PULLUP {disabled} \
   CONFIG.PCW_MIO_7_SLEW {slow} \
   CONFIG.PCW_MIO_8_DIRECTION {out} \
   CONFIG.PCW_MIO_8_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_8_PULLUP {disabled} \
   CONFIG.PCW_MIO_8_SLEW {slow} \
   CONFIG.PCW_MIO_9_DIRECTION {inout} \
   CONFIG.PCW_MIO_9_IOTYPE {LVCMOS 3.3V} \
   CONFIG.PCW_MIO_9_PULLUP {enabled} \
   CONFIG.PCW_MIO_9_SLEW {slow} \
   CONFIG.PCW_MIO_PRIMITIVE {54} \
   CONFIG.PCW_MIO_TREE_PERIPHERALS {NAND Flash#unassigned#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND\
Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND Flash#NAND\
Flash#NAND Flash#unassigned#unassigned#unassigned#UART 0#UART\
0#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#SD\
0#SD 0#SD 0#SD 0#SD 0#SD 0#SD\
0#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned}\
   CONFIG.PCW_MIO_TREE_SIGNALS {cs#unassigned#ale#we_b#data[2]#data[0]#data[1]#cle#re_b#data[4]#data[5]#data[6]#data[7]#data[3]#busy#unassigned#unassigned#unassigned#rx#tx#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#clk#cmd#data[0]#data[1]#data[2]#data[3]#cd#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned#unassigned}\
   CONFIG.PCW_M_AXI_GP0_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP0_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP0_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP0_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_ENABLE_STATIC_REMAP {0} \
   CONFIG.PCW_M_AXI_GP1_ID_WIDTH {12} \
   CONFIG.PCW_M_AXI_GP1_SUPPORT_NARROW_BURST {0} \
   CONFIG.PCW_M_AXI_GP1_THREAD_ID_WIDTH {12} \
   CONFIG.PCW_NAND_CYCLES_T_AR {20} \
   CONFIG.PCW_NAND_CYCLES_T_CLR {20} \
   CONFIG.PCW_NAND_CYCLES_T_RC {30} \
   CONFIG.PCW_NAND_CYCLES_T_REA {10} \
   CONFIG.PCW_NAND_CYCLES_T_RR {25} \
   CONFIG.PCW_NAND_CYCLES_T_WC {30} \
   CONFIG.PCW_NAND_CYCLES_T_WP {20} \
   CONFIG.PCW_NAND_GRP_D8_ENABLE {0} \
   CONFIG.PCW_NAND_NAND_IO {MIO 0 2.. 14} \
   CONFIG.PCW_NAND_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_NOR_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_CS0_T_PC {1} \
   CONFIG.PCW_NOR_CS0_T_RC {11} \
   CONFIG.PCW_NOR_CS0_T_TR {1} \
   CONFIG.PCW_NOR_CS0_T_WC {11} \
   CONFIG.PCW_NOR_CS0_T_WP {1} \
   CONFIG.PCW_NOR_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_CS1_T_PC {1} \
   CONFIG.PCW_NOR_CS1_T_RC {11} \
   CONFIG.PCW_NOR_CS1_T_TR {1} \
   CONFIG.PCW_NOR_CS1_T_WC {11} \
   CONFIG.PCW_NOR_CS1_T_WP {1} \
   CONFIG.PCW_NOR_CS1_WE_TIME {0} \
   CONFIG.PCW_NOR_GRP_A25_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS0_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_CS1_ENABLE {0} \
   CONFIG.PCW_NOR_GRP_SRAM_INT_ENABLE {0} \
   CONFIG.PCW_NOR_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_NOR_SRAM_CS0_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS0_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS0_WE_TIME {0} \
   CONFIG.PCW_NOR_SRAM_CS1_T_CEOE {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_PC {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_RC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_TR {1} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WC {11} \
   CONFIG.PCW_NOR_SRAM_CS1_T_WP {1} \
   CONFIG.PCW_NOR_SRAM_CS1_WE_TIME {0} \
   CONFIG.PCW_OVERRIDE_BASIC_CLOCK {0} \
   CONFIG.PCW_P2F_CAN0_INTR {0} \
   CONFIG.PCW_P2F_CAN1_INTR {0} \
   CONFIG.PCW_P2F_CTI_INTR {0} \
   CONFIG.PCW_P2F_DMAC0_INTR {0} \
   CONFIG.PCW_P2F_DMAC1_INTR {0} \
   CONFIG.PCW_P2F_DMAC2_INTR {0} \
   CONFIG.PCW_P2F_DMAC3_INTR {0} \
   CONFIG.PCW_P2F_DMAC4_INTR {0} \
   CONFIG.PCW_P2F_DMAC5_INTR {0} \
   CONFIG.PCW_P2F_DMAC6_INTR {0} \
   CONFIG.PCW_P2F_DMAC7_INTR {0} \
   CONFIG.PCW_P2F_DMAC_ABORT_INTR {0} \
   CONFIG.PCW_P2F_ENET0_INTR {0} \
   CONFIG.PCW_P2F_ENET1_INTR {0} \
   CONFIG.PCW_P2F_GPIO_INTR {0} \
   CONFIG.PCW_P2F_I2C0_INTR {0} \
   CONFIG.PCW_P2F_I2C1_INTR {0} \
   CONFIG.PCW_P2F_QSPI_INTR {0} \
   CONFIG.PCW_P2F_SDIO0_INTR {0} \
   CONFIG.PCW_P2F_SDIO1_INTR {0} \
   CONFIG.PCW_P2F_SMC_INTR {0} \
   CONFIG.PCW_P2F_SPI0_INTR {0} \
   CONFIG.PCW_P2F_SPI1_INTR {0} \
   CONFIG.PCW_P2F_UART0_INTR {0} \
   CONFIG.PCW_P2F_UART1_INTR {0} \
   CONFIG.PCW_P2F_USB0_INTR {0} \
   CONFIG.PCW_P2F_USB1_INTR {0} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY0 {0.109} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY1 {0.098} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY2 {0.100} \
   CONFIG.PCW_PACKAGE_DDR_BOARD_DELAY3 {0.106} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_0 {-0.022} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_1 {0.007} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_2 {-0.008} \
   CONFIG.PCW_PACKAGE_DDR_DQS_TO_CLK_DELAY_3 {-0.015} \
   CONFIG.PCW_PACKAGE_NAME {ffg900} \
   CONFIG.PCW_PCAP_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_PCAP_PERIPHERAL_DIVISOR0 {9} \
   CONFIG.PCW_PCAP_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_PERIPHERAL_BOARD_PRESET {None} \
   CONFIG.PCW_PJTAG_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_PLL_BYPASSMODE_ENABLE {0} \
   CONFIG.PCW_PRESET_BANK0_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PRESET_BANK1_VOLTAGE {LVCMOS 3.3V} \
   CONFIG.PCW_PS7_SI_REV {PRODUCTION} \
   CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_IO1_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE {0} \
   CONFIG.PCW_QSPI_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_QSPI_INTERNAL_HIGHADDRESS {0xFCFFFFFF} \
   CONFIG.PCW_QSPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_QSPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_QSPI_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_QSPI_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_SD0_GRP_CD_ENABLE {1} \
   CONFIG.PCW_SD0_GRP_CD_IO {MIO 46} \
   CONFIG.PCW_SD0_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_POW_IO {<Select>} \
   CONFIG.PCW_SD0_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD0_GRP_WP_IO {<Select>} \
   CONFIG.PCW_SD0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_SD0_SD0_IO {MIO 40 .. 45} \
   CONFIG.PCW_SD1_GRP_CD_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_POW_ENABLE {0} \
   CONFIG.PCW_SD1_GRP_WP_ENABLE {0} \
   CONFIG.PCW_SD1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SDIO0_BASEADDR {0xE0100000} \
   CONFIG.PCW_SDIO0_HIGHADDR {0xE0100FFF} \
   CONFIG.PCW_SDIO1_BASEADDR {0xE0101000} \
   CONFIG.PCW_SDIO1_HIGHADDR {0xE0101FFF} \
   CONFIG.PCW_SDIO_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SDIO_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SDIO_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SMC_CYCLE_T0 {NA} \
   CONFIG.PCW_SMC_CYCLE_T1 {NA} \
   CONFIG.PCW_SMC_CYCLE_T2 {NA} \
   CONFIG.PCW_SMC_CYCLE_T3 {NA} \
   CONFIG.PCW_SMC_CYCLE_T4 {NA} \
   CONFIG.PCW_SMC_CYCLE_T5 {NA} \
   CONFIG.PCW_SMC_CYCLE_T6 {NA} \
   CONFIG.PCW_SMC_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SMC_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_SMC_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_SMC_PERIPHERAL_VALID {1} \
   CONFIG.PCW_SPI0_BASEADDR {0xE0006000} \
   CONFIG.PCW_SPI0_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI0_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI0_HIGHADDR {0xE0006FFF} \
   CONFIG.PCW_SPI0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI0_SPI0_IO {<Select>} \
   CONFIG.PCW_SPI1_BASEADDR {0xE0007000} \
   CONFIG.PCW_SPI1_GRP_SS0_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS1_ENABLE {0} \
   CONFIG.PCW_SPI1_GRP_SS2_ENABLE {0} \
   CONFIG.PCW_SPI1_HIGHADDR {0xE0007FFF} \
   CONFIG.PCW_SPI1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_SPI_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_SPI_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_SPI_PERIPHERAL_FREQMHZ {166.666666} \
   CONFIG.PCW_SPI_PERIPHERAL_VALID {0} \
   CONFIG.PCW_S_AXI_ACP_ARUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_AWUSER_VAL {31} \
   CONFIG.PCW_S_AXI_ACP_ID_WIDTH {3} \
   CONFIG.PCW_S_AXI_GP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_GP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP0_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP0_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP1_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP1_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP2_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP2_ID_WIDTH {6} \
   CONFIG.PCW_S_AXI_HP3_DATA_WIDTH {64} \
   CONFIG.PCW_S_AXI_HP3_ID_WIDTH {6} \
   CONFIG.PCW_TPIU_PERIPHERAL_CLKSRC {External} \
   CONFIG.PCW_TPIU_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TPIU_PERIPHERAL_FREQMHZ {200} \
   CONFIG.PCW_TRACE_BUFFER_CLOCK_DELAY {12} \
   CONFIG.PCW_TRACE_BUFFER_FIFO_SIZE {128} \
   CONFIG.PCW_TRACE_GRP_16BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_2BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_32BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_4BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_GRP_8BIT_ENABLE {0} \
   CONFIG.PCW_TRACE_INTERNAL_WIDTH {2} \
   CONFIG.PCW_TRACE_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TRACE_PIPELINE_WIDTH {8} \
   CONFIG.PCW_TTC0_BASEADDR {0xE0104000} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC0_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC0_HIGHADDR {0xE0104fff} \
   CONFIG.PCW_TTC0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC0_TTC0_IO {<Select>} \
   CONFIG.PCW_TTC1_BASEADDR {0xE0105000} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK0_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK1_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_TTC1_CLK2_PERIPHERAL_FREQMHZ {133.333333} \
   CONFIG.PCW_TTC1_HIGHADDR {0xE0105fff} \
   CONFIG.PCW_TTC1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_TTC_PERIPHERAL_FREQMHZ {50} \
   CONFIG.PCW_UART0_BASEADDR {0xE0000000} \
   CONFIG.PCW_UART0_BAUD_RATE {115200} \
   CONFIG.PCW_UART0_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART0_HIGHADDR {0xE0000FFF} \
   CONFIG.PCW_UART0_PERIPHERAL_ENABLE {1} \
   CONFIG.PCW_UART0_UART0_IO {MIO 18 .. 19} \
   CONFIG.PCW_UART1_BASEADDR {0xE0001000} \
   CONFIG.PCW_UART1_BAUD_RATE {115200} \
   CONFIG.PCW_UART1_GRP_FULL_ENABLE {0} \
   CONFIG.PCW_UART1_HIGHADDR {0xE0001FFF} \
   CONFIG.PCW_UART1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_UART1_UART1_IO {<Select>} \
   CONFIG.PCW_UART_PERIPHERAL_CLKSRC {IO PLL} \
   CONFIG.PCW_UART_PERIPHERAL_DIVISOR0 {18} \
   CONFIG.PCW_UART_PERIPHERAL_FREQMHZ {100} \
   CONFIG.PCW_UART_PERIPHERAL_VALID {1} \
   CONFIG.PCW_UIPARAM_ACT_DDR_FREQ_MHZ {533.333374} \
   CONFIG.PCW_UIPARAM_DDR_ADV_ENABLE {0} \
   CONFIG.PCW_UIPARAM_DDR_AL {0} \
   CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT {3} \
   CONFIG.PCW_UIPARAM_DDR_BL {8} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3 {0.25} \
   CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH {32 Bit} \
   CONFIG.PCW_UIPARAM_DDR_CL {7} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {97.8165} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {97.8165} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {97.8165} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {97.8165} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_CLOCK_STOP_EN {0} \
   CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT {10} \
   CONFIG.PCW_UIPARAM_DDR_CWL {6} \
   CONFIG.PCW_UIPARAM_DDR_DEVICE_CAPACITY {4096 MBits} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH {119.765} \
   CONFIG.PCW_UIPARAM_DDR_DQS_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH {90.906} \
   CONFIG.PCW_UIPARAM_DDR_DQS_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH {106.248} \
   CONFIG.PCW_UIPARAM_DDR_DQS_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH {113.2035} \
   CONFIG.PCW_UIPARAM_DDR_DQS_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3 {0.0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH {120.1555} \
   CONFIG.PCW_UIPARAM_DDR_DQ_0_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH {97.811} \
   CONFIG.PCW_UIPARAM_DDR_DQ_1_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH {102.5285} \
   CONFIG.PCW_UIPARAM_DDR_DQ_2_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM {0} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH {113.5445} \
   CONFIG.PCW_UIPARAM_DDR_DQ_3_PROPOGATION_DELAY {160} \
   CONFIG.PCW_UIPARAM_DDR_DRAM_WIDTH {16 Bits} \
   CONFIG.PCW_UIPARAM_DDR_ECC {Disabled} \
   CONFIG.PCW_UIPARAM_DDR_ENABLE {1} \
   CONFIG.PCW_UIPARAM_DDR_FREQ_MHZ {533.333333} \
   CONFIG.PCW_UIPARAM_DDR_HIGH_TEMP {Normal (0-85)} \
   CONFIG.PCW_UIPARAM_DDR_MEMORY_TYPE {DDR 3} \
   CONFIG.PCW_UIPARAM_DDR_PARTNO {MT41K256M16 RE-125} \
   CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT {15} \
   CONFIG.PCW_UIPARAM_DDR_SPEED_BIN {DDR3_1066F} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE {1} \
   CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL {1} \
   CONFIG.PCW_UIPARAM_DDR_T_FAW {40.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN {35.0} \
   CONFIG.PCW_UIPARAM_DDR_T_RC {48.75} \
   CONFIG.PCW_UIPARAM_DDR_T_RCD {7} \
   CONFIG.PCW_UIPARAM_DDR_T_RP {7} \
   CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF {0} \
   CONFIG.PCW_UIPARAM_GENERATE_SUMMARY {NA} \
   CONFIG.PCW_USB0_BASEADDR {0xE0102000} \
   CONFIG.PCW_USB0_HIGHADDR {0xE0102fff} \
   CONFIG.PCW_USB0_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB0_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB0_RESET_ENABLE {0} \
   CONFIG.PCW_USB0_USB0_IO {<Select>} \
   CONFIG.PCW_USB1_BASEADDR {0xE0103000} \
   CONFIG.PCW_USB1_HIGHADDR {0xE0103fff} \
   CONFIG.PCW_USB1_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_USB1_PERIPHERAL_FREQMHZ {60} \
   CONFIG.PCW_USB1_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_ENABLE {0} \
   CONFIG.PCW_USB_RESET_POLARITY {Active Low} \
   CONFIG.PCW_USE_AXI_FABRIC_IDLE {0} \
   CONFIG.PCW_USE_AXI_NONSECURE {0} \
   CONFIG.PCW_USE_CORESIGHT {0} \
   CONFIG.PCW_USE_CROSS_TRIGGER {0} \
   CONFIG.PCW_USE_CR_FABRIC {1} \
   CONFIG.PCW_USE_DDR_BYPASS {0} \
   CONFIG.PCW_USE_DEBUG {0} \
   CONFIG.PCW_USE_DEFAULT_ACP_USER_VAL {0} \
   CONFIG.PCW_USE_DMA0 {0} \
   CONFIG.PCW_USE_DMA1 {0} \
   CONFIG.PCW_USE_DMA2 {0} \
   CONFIG.PCW_USE_DMA3 {0} \
   CONFIG.PCW_USE_EXPANDED_IOP {0} \
   CONFIG.PCW_USE_EXPANDED_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_FABRIC_INTERRUPT {1} \
   CONFIG.PCW_USE_HIGH_OCM {0} \
   CONFIG.PCW_USE_M_AXI_GP0 {1} \
   CONFIG.PCW_USE_M_AXI_GP1 {0} \
   CONFIG.PCW_USE_PROC_EVENT_BUS {0} \
   CONFIG.PCW_USE_PS_SLCR_REGISTERS {0} \
   CONFIG.PCW_USE_S_AXI_ACP {0} \
   CONFIG.PCW_USE_S_AXI_GP0 {0} \
   CONFIG.PCW_USE_S_AXI_GP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP0 {0} \
   CONFIG.PCW_USE_S_AXI_HP1 {0} \
   CONFIG.PCW_USE_S_AXI_HP2 {0} \
   CONFIG.PCW_USE_S_AXI_HP3 {0} \
   CONFIG.PCW_USE_TRACE {0} \
   CONFIG.PCW_USE_TRACE_DATA_EDGE_DETECTOR {0} \
   CONFIG.PCW_VALUE_SILVERSION {3} \
   CONFIG.PCW_WDT_PERIPHERAL_CLKSRC {CPU_1X} \
   CONFIG.PCW_WDT_PERIPHERAL_DIVISOR0 {1} \
   CONFIG.PCW_WDT_PERIPHERAL_ENABLE {0} \
   CONFIG.PCW_WDT_PERIPHERAL_FREQMHZ {133.333333} \
 ] $processing_system7_0

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [ list \
   CONFIG.NUM_MI {2} \
   CONFIG.NUM_SI {1} \
 ] $smartconnect_0

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [ list \
   CONFIG.C_BRAM_CNT {12.5} \
   CONFIG.C_NUM_MONITOR_SLOTS {2} \
   CONFIG.C_SLOT {0} \
   CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
   CONFIG.C_SLOT_3_INTF_TYPE {xilinx.com:interface:axis_rtl:1.0} \
 ] $system_ila_0

  # Create instance: util_vector_logic_0, and set properties
  set util_vector_logic_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_0 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_0

  # Create instance: util_vector_logic_1, and set properties
  set util_vector_logic_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 util_vector_logic_1 ]
  set_property -dict [ list \
   CONFIG.C_OPERATION {not} \
   CONFIG.C_SIZE {1} \
   CONFIG.LOGO_FILE {data/sym_notgate.png} \
 ] $util_vector_logic_1

  # Create instance: xlconcat_0, and set properties
  set xlconcat_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 xlconcat_0 ]
  set_property -dict [ list \
   CONFIG.NUM_PORTS {3} \
 ] $xlconcat_0

  # Create interface connections
  connect_bd_intf_net -intf_net gmii_to_rgmii_0_MDIO_PHY [get_bd_intf_ports MDIO_PHY_0] [get_bd_intf_pins gmii_to_rgmii_0/MDIO_PHY]
  connect_bd_intf_net -intf_net gmii_to_rgmii_0_RGMII [get_bd_intf_ports RGMII_0] [get_bd_intf_pins gmii_to_rgmii_0/RGMII]
  connect_bd_intf_net -intf_net processing_system7_0_DDR [get_bd_intf_ports DDR_0] [get_bd_intf_pins processing_system7_0/DDR]
  connect_bd_intf_net -intf_net processing_system7_0_FIXED_IO [get_bd_intf_ports FIXED_IO_0] [get_bd_intf_pins processing_system7_0/FIXED_IO]
  connect_bd_intf_net -intf_net processing_system7_0_GMII_ETHERNET_0 [get_bd_intf_pins gmii_to_rgmii_0/GMII] [get_bd_intf_pins processing_system7_0/GMII_ETHERNET_0]
  connect_bd_intf_net -intf_net processing_system7_0_GPIO_0 [get_bd_intf_ports GPIO_0_0] [get_bd_intf_pins processing_system7_0/GPIO_0]
  connect_bd_intf_net -intf_net processing_system7_0_MDIO_ETHERNET_0 [get_bd_intf_pins gmii_to_rgmii_0/MDIO_GEM] [get_bd_intf_pins processing_system7_0/MDIO_ETHERNET_0]
  connect_bd_intf_net -intf_net processing_system7_0_M_AXI_GP0 [get_bd_intf_pins processing_system7_0/M_AXI_GP0] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_ports h2c_maxi] [get_bd_intf_pins smartconnect_0/M00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets smartconnect_0_M00_AXI] [get_bd_intf_ports h2c_maxi] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_ports c2h_maxi] [get_bd_intf_pins smartconnect_0/M01_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets smartconnect_0_M01_AXI] [get_bd_intf_ports c2h_maxi] [get_bd_intf_pins system_ila_0/SLOT_1_AXI]

  # Create port connections
  connect_bd_net -net ENET0_EXT_INTIN_0_1 [get_bd_ports ENET0_EXT_INTIN_0] [get_bd_pins util_vector_logic_0/Op1]
  connect_bd_net -net In1_0_1 [get_bd_ports h2c_irpt] [get_bd_pins xlconcat_0/In1]
  connect_bd_net -net In2_0_1 [get_bd_ports c2h_irpt] [get_bd_pins xlconcat_0/In2]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins system_ila_0/resetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_reset [get_bd_ports peripheral_reset_0] [get_bd_pins proc_sys_reset_0/peripheral_reset]
  connect_bd_net -net processing_system7_0_FCLK_CLK0 [get_bd_pins gmii_to_rgmii_0/clkin] [get_bd_pins processing_system7_0/FCLK_CLK0]
  connect_bd_net -net processing_system7_0_FCLK_CLK2 [get_bd_ports FCLK_CLK1_0] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins processing_system7_0/FCLK_CLK1] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK] [get_bd_pins smartconnect_0/aclk] [get_bd_pins system_ila_0/clk]
  connect_bd_net -net processing_system7_0_FCLK_RESET0_N [get_bd_pins processing_system7_0/FCLK_RESET0_N] [get_bd_pins util_vector_logic_1/Op1]
  connect_bd_net -net processing_system7_0_FCLK_RESET1_N [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins processing_system7_0/FCLK_RESET1_N]
  connect_bd_net -net util_vector_logic_0_Res [get_bd_pins util_vector_logic_0/Res] [get_bd_pins xlconcat_0/In0]
  connect_bd_net -net util_vector_logic_1_Res [get_bd_pins gmii_to_rgmii_0/rx_reset] [get_bd_pins gmii_to_rgmii_0/tx_reset] [get_bd_pins util_vector_logic_1/Res]
  connect_bd_net -net xlconcat_0_dout [get_bd_pins processing_system7_0/IRQ_F2P] [get_bd_pins xlconcat_0/dout]

  # Create address segments
  assign_bd_address -offset 0x40010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs c2h_maxi/Reg] -force
  assign_bd_address -offset 0x40000000 -range 0x00010000 -target_address_space [get_bd_addr_spaces processing_system7_0/Data] [get_bd_addr_segs h2c_maxi/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


