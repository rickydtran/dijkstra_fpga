set prj_name "dijkstra_fpga"
set lab "dijkstra_hw"
set curr_dir [pwd]
set prj_dir $curr_dir/$prj_name

open_project $prj_dir/dijkstra_fpga.xpr
update_compile_order -fileset sources_1
update_ip_catalog -rebuild -repo_path $curr_dir/ip_repo
report_ip_status -name ip_status 
upgrade_ip -vlnv ufl.edu:user:accelerator:1.0 [get_ips  dijkstra_hw_accelerator_0_0] -log ip_upgrade.log
export_ip_user_files -of_objects [get_ips dijkstra_hw_accelerator_0_0] -no_script -sync -force -quiet
report_ip_status -name ip_status