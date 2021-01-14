set my_files [list  ../fp32_to_fp16.v] 
set my_top_level fp32_to_fp16
set my_clock_pin clk
set link_library "/home/projects/ljohn/aarora1/cadence_gpdk/gsclib045_all_v4.4/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v0_basicCells.modif.db dw_foundation.sldb"
set target_library /home/projects/ljohn/aarora1/cadence_gpdk/gsclib045_all_v4.4/lan/flow/t1u1/reference_libs/GPDK045/gsclib045_all_v4.4/gsclib045/timing/fast_vdd1v0_basicCells.modif.db
#set power_analysis_mode "averaged"
define_design_lib WORK -path ./WORK 
analyze -f verilog $my_files 
elaborate $my_top_level 
current_design $my_top_level 
check_design >  checkprecompile_32to16.rpt
link 
uniquify 
set my_period 3.0 
set find_clock [ find port [list $my_clock_pin] ] 
if { $find_clock != [list] } { 
set clk_name $my_clock_pin 
create_clock -period $my_period $clk_name} 
compile_ultra
check_design >  check_32to16.rpt
link 
#write_file -format ddc -hierarchy -output matmul_slice.ddc 
#set_switching_activity -static_probability 0.5 -base_clock $clk_name -toggle_rate 25 [get_nets] 
ungroup -all -flatten 
#report_power > power_32to16.rpt
report_area -nosplit -hierarchy > area_32to16.rpt
#report_resources -nosplit -hierarchy > resources_32to16.rpt
report_timing > timing_32to16.rpt
#change_names -hier -rule verilog 
#write -f verilog -output synthesized.v
#write_sdf synthsized.sdf 
#write_parasitics -output synthesized.spef 
#write_sdc synthesized.sdc 
quit 
