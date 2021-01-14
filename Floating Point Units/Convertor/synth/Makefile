all: synth clean_synth

synth:
	design_vision -64bit -f synth_16to32.cmd
	design_vision -64bit -f synth_32to16.cmd

clean_synth:
	\rm -rf *.syn *.pvl *.mr *.svf command.log 

clean:
	\rm -rf csrc DVEFiles simv.daidir simv ucli.key vcdplus.vpd *.syn *.pvl *.mr *.svf command.log *.txt

