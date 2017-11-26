set prj_name "dijkstra_fpga"
set lab "dijkstra_hw"
set curr_dir [pwd]
set prj_dir $curr_dir/$prj_name

create_project $prj_name $curr_dir/$prj_name -part xc7z020clg484-1
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]
create_bd_design $lab
update_compile_order -fileset sources_1
startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:processing_system7:5.5 processing_system7_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:processing_system7 -config {make_external "FIXED_IO, DDR" apply_board_preset "1" Master "Disable" Slave "Disable" }  [get_bd_cells processing_system7_0]
connect_bd_net [get_bd_pins processing_system7_0/FCLK_CLK0] [get_bd_pins processing_system7_0/M_AXI_GP0_ACLK]
make_wrapper -files [get_files $prj_dir/$prj_name.srcs/sources_1/bd/$lab/$lab.bd] -top
add_files -norecurse $prj_dir/$prj_name.srcs/sources_1/bd/$lab/hdl/$lab\_wrapper.vhd
set_property  ip_repo_paths  $curr_dir/ip_repo [current_project]
update_ip_catalog
exit