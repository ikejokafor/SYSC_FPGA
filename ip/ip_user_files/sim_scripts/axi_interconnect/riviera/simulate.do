onbreak {quit -force}
onerror {quit -force}

asim -t 1ps +access +r +m+axi_interconnect -L xil_defaultlib -L xpm -L fifo_generator_v13_2_3 -L axi_interconnect_v1_7_15 -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.axi_interconnect xil_defaultlib.glbl

do {wave.do}

view wave
view structure

do {axi_interconnect.udo}

run -all

endsim

quit -force
