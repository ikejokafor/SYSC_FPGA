# onbreak {quit -f}
# onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib sim_tb_top_opt

do {wave.do}

view wave
view structure
view signals

# do {sim_tb_top.udo}

# run -all

# quit -force
