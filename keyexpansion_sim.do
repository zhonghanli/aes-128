setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "aes_const.vhd"
vcom -work work "rkey_gen.vhd"
vcom -work work "keyexpansion.vhd"
vcom -work work "keyexpansion_tb.vhd"

vsim +notimingchecks -L work work.keyexpansion_tb -wlf keyexpansion_sim.wlf

add wave -noupdate -group keyexpansion_tb
add wave -noupdate -group keyexpansion_tb -radix hexadecimal /keyexpansion_tb/dut/*
add wave -noupdate -group keyexpansion_tb -radix hexadecimal /keyexpansion_tb/dut/gen_rk_gen(0)/first_bit/rkg0/*
