setenv LMC_TIMEUNIT -9
vlib work

vcom -work work "aes_const.vhd"
vcom -work work "aes128_step.vhd"
vcom -work work "aes128_full.vhd"
vcom -work work "fifo.vhd"
vcom -work work "keyexpansion.vhd"
vcom -work work "keyprocessing.vhd"
vcom -work work "mc_to_ascii.vhd"
vcom -work work "rkey_gen.vhd"
vcom -work work "aes128_middle_level.vhd"
vcom -work work "aes128_upper_level.vhd"
vcom -work work "aes128_upper_level_tb.vhd"

vsim +notimingchecks -L work work.aes128_upper_level_tb -wlf aes128_upper_level_sim.wlf

add wave -noupdate -group aes128_upper_level_tb /aes128_upper_level_tb/dut/*

