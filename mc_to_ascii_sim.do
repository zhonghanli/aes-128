setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "mc_to_ascii.vhd"
vcom -work work "mc_to_ascii_tb.vhd"

vsim +notimingchecks -L work work.mc_to_ascii_tb -wlf mc_to_ascii_sim.wlf

add wave -noupdate -group mc_to_ascii_tb /mc_to_ascii_tb/clock
add wave -noupdate -group mc_to_ascii_tb /mc_to_ascii_tb/reset

add wave -noupdate -group mc_to_ascii_tb /mc_to_ascii_tb/dut/flag
add wave -noupdate -group mc_to_ascii_tb /mc_to_ascii_tb/dut/sent
add wave -noupdate -group mc_to_ascii_tb /mc_to_ascii_tb/dut/read

add wave -noupdate -group mc_to_ascii_tb -radix hexadecimal /mc_to_ascii_tb/dut/hist3
add wave -noupdate -group mc_to_ascii_tb -radix hexadecimal /mc_to_ascii_tb/dut/hist2
add wave -noupdate -group mc_to_ascii_tb -radix hexadecimal /mc_to_ascii_tb/dut/hist1
add wave -noupdate -group mc_to_ascii_tb -radix hexadecimal /mc_to_ascii_tb/dut/hist0

add wave -noupdate -group mc_to_ascii_tb -radix hexadecimal /mc_to_ascii_tb/dut/makecode
add wave -noupdate -group mc_to_ascii_tb -radix ASCII /mc_to_ascii_tb/dut/asciikey
