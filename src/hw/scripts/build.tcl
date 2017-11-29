set prj_name "dijkstra_fpga"
set lab "dijkstra_hw"
set curr_dir [pwd]
set prj_dir $curr_dir/$prj_name

create_project $prj_name $curr_dir/$prj_name -part xc7z020clg484-1
set_property board_part em.avnet.com:zed:part0:1.3 [current_project]
set_property target_language VHDL [current_project]
set_property simulator_language VHDL [current_project]
import_files -fileset constrs_1 -force -norecurse $curr_dir/zedboard_master_XDC_RevC_D_v3.xdc
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
update_compile_order -fileset sources_1
open_bd_design $prj_dir/$prj_name.srcs/sources_1/bd/$lab/$lab.bd
startgroup
create_bd_cell -type ip -vlnv ufl.edu:user:accelerator:1.0 accelerator_0
endgroup
apply_bd_automation -rule xilinx.com:bd_rule:axi4 -config {Master "/processing_system7_0/M_AXI_GP0" intc_ip "New AXI Interconnect" Clk_xbar "Auto" Clk_master "Auto" Clk_slave "Auto" }  [get_bd_intf_pins accelerator_0/S00_AXI]
save_bd_design
ipx::edit_ip_in_project -upgrade true -name accelerator_v1_0_project -directory /mnt/windows/Users/ricky/Seafile/Library/School/F17/EEL4720/prj/dijkstra_fpga/src/hw/dijkstra_fpga/dijkstra_fpga.tmp/accelerator_v1_0_project /mnt/windows/Users/ricky/Seafile/Library/School/F17/EEL4720/prj/dijkstra_fpga/src/hw/ip_repo/accelerator_1.0/component.xml
update_compile_order -fileset sources_1
add_files -norecurse -copy_to $curr_dir/ip_repo/accelerator_1.0/src $curr_dir/ip_repo/accelerator_1.0/src/ -force
update_compile_order -fileset sources_1
ipx::merge_project_changes files [ipx::current_core]
set_property core_revision 1 [ipx::current_core]
ipx::update_checksums [ipx::current_core]
ipx::save_core [ipx::current_core]
close_project -delete
update_ip_catalog -rebuild -repo_path $curr_dir/ip_repo
report_ip_status -name ip_status 
upgrade_ip -vlnv ufl.edu:user:accelerator:1.0 [get_ips  dijkstra_hw_accelerator_0_0] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips dijkstra_hw_accelerator_0_0] -no_script -sync -force -quiet
report_ip_status -name ip_status 
update_compile_order -fileset sources_1
launch_runs impl_1 -to_step write_bitstream -jobs 2
wait_on_run impl_1