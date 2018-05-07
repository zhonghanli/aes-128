setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "aes_const.vhd"
vcom -work work "aes128_step.vhd"
vcom -work work "aes128_step_tb.vhd"

vsim +notimingchecks -L work work.aes128_step_tb -wlf aes128_step_sim.wlf

add wave -noupdate -group aes128_step_tb
add wave -noupdate -group aes128_step_tb -radix hexadecimal /aes128_step_tb/dut/*
