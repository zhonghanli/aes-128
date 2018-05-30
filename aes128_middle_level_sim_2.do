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
vcom -work work "aes128_middle_level_tb_2.vhd"

vsim +notimingchecks -L work work.aes128_middle_level_tb_2 -wlf aes128_middle_level_sim.wlf

add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/clock
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/reset

add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/keyormsg
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/output_fifo_full
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/wr_en

add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/hist3
add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/hist2
add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/hist1
add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/hist0

add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/mc_to_ascii_component/makecode
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/mc_to_ascii_component/asciikey
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/mc_to_ascii_component/read

add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/keyprocess_component/keyormsg
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/keyprocess_component/state
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/keyprocess_component/next_state
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/keyprocess_component/tempvector
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/keyprocess_component/send_key_out
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/keyprocess_component/cipherkey
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/keyprocess_component/wr_enable_out
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/keyprocess_component/din

add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/dout

add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/keyexpansion_component/start
add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/keyexpansion_component/cipher_key
add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/keyexpansion_component/keyset

add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/data2aes_fifo/din
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/data2aes_fifo/full
add wave -noupdate -group aes128_middle_level_tb_2 /aes128_middle_level_tb_2/dut/data2aes_fifo/empty

add wave -noupdate -group aes128_middle_level_tb_2 -radix ASCII /aes128_middle_level_tb_2/dut/aes128_full_component/input_fifo_data
add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/aes128_full_component/roundkeys
add wave -noupdate -group aes128_middle_level_tb_2 -radix hexadecimal /aes128_middle_level_tb_2/dut/aes128_full_component/output_fifo_data
