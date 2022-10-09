launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run synth_1
wait_on_run impl_1
open_run impl_1
report_utilization -file post_utilization.rpt
report_utilization -file util_hiel.rpt -hierarchical
report_timing_summary -file post_route_timing_summary.rpt
write_hw_platform -fixed -include_bit -force -file ./vivadoPrj/zynq_top_wrapper.xsa
