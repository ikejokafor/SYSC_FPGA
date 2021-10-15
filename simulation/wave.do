onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group TOP /sim_tb_top/u_example_top/*
add wave -noupdate -group BRDG /sim_tb_top/u_example_top/i0_cnn_layer_accel_axi_bridge/axi_addr_rd_ack/*
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2864750 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 216
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1075303 ps} {10090971 ps}
