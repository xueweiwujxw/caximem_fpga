create_project prj ./vivadoPrj -part xc7z100ffg900-2

source zynq/zynq_bd.tcl
set verilog_source [glob ./zynq/*.v]
puts $verilog_source
import_files -norecurse $verilog_source
import_files -norecurse CAxiMemTransfer.v
update_compile_order -fileset sources_1
set_property top zynq_top_wrapper [current_fileset]
if [file exists ila.tcl ] {
    source ila.tcl
}
add_files -fileset constrs_1 -norecurse zynq/pins.xdc
import_files -fileset constrs_1 zynq/pins.xdc
update_compile_order -fileset sources_1

#generate_target {instantiation_template} [get_files ./vivadoPrj/prj.srcs/sources_1/ip/gtwizard_0/gtwizard_0.xci]
