setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "aes_const.vhd"
vcom -work work "rkey_gen.vhd"
vcom -work work "rkey_gen_tb.vhd"

vsim +notimingchecks -L work work.rkey_gen_tb -wlf rkey_gen_sim.wlf

add wave -noupdate -group rkey_gen_tb
add wave -noupdate -group rkey_gen_tb -radix hexadecimal /rkey_gen_tb/dut/*
