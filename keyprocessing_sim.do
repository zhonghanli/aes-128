setenv LMC_TIMEUNIT -9
vlib work
vcom -work work "keyprocessing.vhd"
vcom -work work "keyprocessing_tb.vhd"

vsim +notimingchecks -L work work.keyprocessing_tb -wlf rkey_gen_sim.wlf

add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/clock
add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/reset
add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/read

add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/dut/keyormsg
add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/dut/counter_c
add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/dut/full
add wave -noupdate -group keyprocessing_tb -radix ASCII /keyprocessing_tb/dut/asciikey
add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/wr_enable
add wave -noupdate -group keyprocessing_tb -radix ASCII /keyprocessing_tb/din
add wave -noupdate -group keyprocessing_tb /keyprocessing_tb/send_key

add wave -noupdate -group keyprocessing_tb -radix ASCII /keyprocessing_tb/dut/cipherkey
add wave -noupdate -group keyprocessing_tb -radix ASCII /keyprocessing_tb/dut/tempvector_c

