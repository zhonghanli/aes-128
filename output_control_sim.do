setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "aes_const.vhd"
vcom -work work "output_control.vhd"
vcom -work work "fifo.vhd"
vcom -work work "output_control_tb.vhd"

vsim +notimingchecks -L work work.output_control_tb -wlf output_control_sim.wlf

add wave -noupdate -group output_control_tb
add wave -noupdate -group output_control_tb -radix hexadecimal /output_control_tb/*