analyze -format verilog {
../fp16_multiplier.v
}
elaborate FPMult_16 -architecture verilog -library DEFAULT
link
#set_implementation pparch Adder/M1/u_add1
#set_implementation pparch Adder/M1/u_add2
#set_implementation pparch Adder/M2/u_add
#set_implementation pparch Adder/M2/u_sub
#set_implementation pparch Adder/M3/u_sub
#set_implementation pparch Multiplier/M1/u_mult
#set_implementation pparch Multiplier/M2/u_mult
#set_implementation pparch Multiplier/M2/u_add1
#set_implementation pparch Multiplier/M2/u_add2
#set_implementation pparch Multiplier/M3/u_sub1
#set_implementation pparch Multiplier/M3/u_sub2
set_dp_smartgen_options -all_options auto -hierarchy -smart_compare true -optimize_for speed -sop2pos_transformation false
create_clock -name "clk" -period 2.4 -waveform { 0 1.2 }  { clk  }
set_operating_conditions -library gscl45nm typical
remove_wire_load_model
compile -exact_map
uplevel #0 { report_timing -path full -delay max -nworst 1 -max_paths 1 -significant_digits 2 -sort_by group } >> Report.timing.max.txt
uplevel #0 { report_timing -path_type end -from [all_inputs] } >> Report.timing.all.txt
uplevel #0 { report_timing -path_type end } >> Report.timing.all.txt
uplevel #0 { report_timing -path_type end -to [all_outputs] } >> Report.timing.all.txt
uplevel #0 { report_area } >> Report.area.txt
uplevel #0 { report_power -analysis_effort low } >> Report.power.txt
uplevel #0 { report_design -nosplit } >> Report.design.txt
exit

