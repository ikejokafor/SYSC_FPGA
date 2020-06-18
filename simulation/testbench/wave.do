onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/clk
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_adder_tree_rdv_count
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_AWP_complt_arr
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_co_high_watermark_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_complete
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_complete_ack
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_conv_out_fmt0_cfg
add wave -noupdate -group FAS -radix unsigned /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_convMap_bram_sz
add wave -noupdate -group FAS -radix unsigned /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_dpth_count
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_FAS_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_FAS_id
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_five_cycles_later
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_four_cycles_later
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_inMapAddrArr
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_inMapDepthFetchAmt
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_inMapFetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_inMapFetchFactor_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_inMapFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1_pad_bgn_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1_pad_end_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1_pding_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1Addr_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1BiasAddr_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1BiasFetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1BiasFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1Depth_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1FetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl1x1FetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl3x3AddrArr
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl3x3BiasAddrArr
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl3x3BiasFetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl3x3BiasFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl3x3FetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl3x3FetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl_1x1_bias_bram_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl_1x1_bram_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_krnl_count
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_last_CO_recvd
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_last_wrt
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_mem_mng
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_num_1x1_kernels_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_num_QUAD_cfgd
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_ob_dwc_fifo_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_opcode_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_outBuf_fifo_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_outMapAddr_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_outMapStoreCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_outMapStoreFactor_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_outMapStoreTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_partMap_bram_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_partMapAddr_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_partMapFetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_partMapFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_pixelSeqAddr_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_pixSeqCfgFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_pm_fetch_amount_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_pm_low_watermark_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_prevMap_dwc_fifo_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_prevMap_fifo_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_prevMapFetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_prevMapFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_prog_factor
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_pv_fetch_amount_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_pv_low_watermark_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_QUAD_en_arr
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_resdMap_bram_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_resdMap_dwc_fifo_sz
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_resdMapAddr_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_resdMapFetchCount
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_resdMapFetchTotal_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_rm_fetch_amount_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_rm_low_watermark_cfg
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_start
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_start_ack
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_state
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_three_cycles_later
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_trans_fifo
add wave -noupdate -group FAS /testbench/i0_SYSC_FPGA/CNN_Layer_Accel/FAS_0/m_two_cycles_later
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3410 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 190
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
WaveRestoreZoom {3324 ns} {3553 ns}
