setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "keyprocessing.vhd"
vcom -work work "keyprocessing_tb.vhd"

vsim +notimingchecks -L work work.keyprocessing_tb -wlf rkey_gen_sim.wlf

add wave -noupdate -group processing_tb
add wave -noupdate -group processing_tb -radix ASCII /keyprocessing_tb/cipherkey
add wave -noupdate -group processing_tb -radix ASCII /keyprocessing_tb/dut/tempvector_c
