setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "aes_const.vhd"
vcom -work work "aes128_step.vhd"
vcom -work work "aes128_full.vhd"
vcom -work work "aes128_full_tb.vhd"

vsim +notimingchecks -L work work.aes128_full_tb -wlf aes128_full_sim.wlf

add wave -noupdate -group aes128_full_tb
add wave -noupdate -group aes128_full_tb -radix hexadecimal /aes128_full_tb/dut/*
add wave -noupdate -group aes128_full_tb -radix hexadecimal /aes128_full_tb/dut/gen_aes128_steps(0)/first_step/initial_step/*
add wave -noupdate -group aes128_full_tb -radix hexadecimal /aes128_full_tb/dut/gen_aes128_steps(1)/other_steps/other_steps/*
add wave -noupdate -group aes128_full_tb -radix hexadecimal /aes128_full_tb/dut/gen_aes128_steps(6)/other_steps/other_steps/*
add wave -noupdate -group aes128_full_tb -radix hexadecimal /aes128_full_tb/dut/gen_aes128_steps(7)/other_steps/other_steps/*
add wave -noupdate -group aes128_full_tb -radix hexadecimal /aes128_full_tb/dut/gen_aes128_steps(8)/other_steps/other_steps/*


