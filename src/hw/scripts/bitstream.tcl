set prj_name "dijkstra_fpga"
set lab "dijkstra_hw"
set curr_dir [pwd]
set prj_dir $curr_dir/$prj_name

open_project $prj_dir/dijkstra_fpga.xpr
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1
exit