vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib
vlib questa_lib/msim/xpm
vlib questa_lib/msim/microblaze_v11_0_0
vlib questa_lib/msim/lib_cdc_v1_0_2
vlib questa_lib/msim/proc_sys_reset_v5_0_13
vlib questa_lib/msim/lmb_v10_v3_0_9
vlib questa_lib/msim/lmb_bram_if_cntlr_v4_0_15
vlib questa_lib/msim/blk_mem_gen_v8_4_2
vlib questa_lib/msim/iomodule_v3_1_4

vmap xil_defaultlib questa_lib/msim/xil_defaultlib
vmap xpm questa_lib/msim/xpm
vmap microblaze_v11_0_0 questa_lib/msim/microblaze_v11_0_0
vmap lib_cdc_v1_0_2 questa_lib/msim/lib_cdc_v1_0_2
vmap proc_sys_reset_v5_0_13 questa_lib/msim/proc_sys_reset_v5_0_13
vmap lmb_v10_v3_0_9 questa_lib/msim/lmb_v10_v3_0_9
vmap lmb_bram_if_cntlr_v4_0_15 questa_lib/msim/lmb_bram_if_cntlr_v4_0_15
vmap blk_mem_gen_v8_4_2 questa_lib/msim/blk_mem_gen_v8_4_2
vmap iomodule_v3_1_4 questa_lib/msim/iomodule_v3_1_4

vlog -work xil_defaultlib -64 -sv "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/map" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports" \
"/home/software/vivado-2018.3/Vivado/2018.3/data/ip/xpm/xpm_memory/hdl/xpm_memory.sv" \

vcom -work xpm -64 -93 \
"/home/software/vivado-2018.3/Vivado/2018.3/data/ip/xpm/xpm_VCOMP.vhd" \

vcom -work microblaze_v11_0_0 -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/hdl/microblaze_v11_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_0/sim/bd_c703_microblaze_I_0.vhd" \

vcom -work lib_cdc_v1_0_2 -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/hdl/lib_cdc_v1_0_rfs.vhd" \

vcom -work proc_sys_reset_v5_0_13 -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/hdl/proc_sys_reset_v5_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_1/sim/bd_c703_rst_0_0.vhd" \

vcom -work lmb_v10_v3_0_9 -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/hdl/lmb_v10_v3_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_2/sim/bd_c703_ilmb_0.vhd" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_3/sim/bd_c703_dlmb_0.vhd" \

vcom -work lmb_bram_if_cntlr_v4_0_15 -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/hdl/lmb_bram_if_cntlr_v4_0_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_4/sim/bd_c703_dlmb_cntlr_0.vhd" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_5/sim/bd_c703_ilmb_cntlr_0.vhd" \

vlog -work blk_mem_gen_v8_4_2 -64 "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/map" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/simulation/blk_mem_gen_v8_4.v" \

vlog -work xil_defaultlib -64 "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/map" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_6/sim/bd_c703_lmb_bram_I_0.v" \

vcom -work xil_defaultlib -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_7/sim/bd_c703_second_dlmb_cntlr_0.vhd" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_8/sim/bd_c703_second_ilmb_cntlr_0.vhd" \

vlog -work xil_defaultlib -64 "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/map" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_9/sim/bd_c703_second_lmb_bram_I_0.v" \

vcom -work iomodule_v3_1_4 -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.ip_user_files/ipstatic/hdl/iomodule_v3_1_vh_rfs.vhd" \

vcom -work xil_defaultlib -64 -93 \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/ip/ip_10/sim/bd_c703_iomodule_0_0.vhd" \

vlog -work xil_defaultlib -64 "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/map" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/bd_0/sim/bd_c703.v" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_0/sim/ddr4_microblaze_mcs.v" \

vlog -work xil_defaultlib -64 -sv "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/map" "+incdir+/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/phy/ddr4_phy_v2_2_xiphy_behav.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/phy/ddr4_phy_v2_2_xiphy.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/iob/ddr4_phy_v2_2_iob_byte.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/iob/ddr4_phy_v2_2_iob.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/clocking/ddr4_phy_v2_2_pll.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_tristate_wrapper.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_riuor_wrapper.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_control_wrapper.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_byte_wrapper.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/xiphy_files/ddr4_phy_v2_2_xiphy_bitslice_wrapper.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/phy/ddr4_phy_ddr4.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/ip_1/rtl/ip_top/ddr4_phy.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_wtr.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ref.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_rd_wr.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_periodic.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_group.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ecc_merge_enc.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ecc_gen.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ecc_fi_xor.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ecc_dec_fix.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ecc_buf.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ecc.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_ctl.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_cmd_mux_c.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_cmd_mux_ap.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_arb_p.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_arb_mux_p.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_arb_c.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_arb_a.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_act_timer.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc_act_rank.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/controller/ddr4_v2_2_mc.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ui/ddr4_v2_2_ui_wr_data.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ui/ddr4_v2_2_ui_rd_data.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ui/ddr4_v2_2_ui_cmd.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ui/ddr4_v2_2_ui.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_ar_channel.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_aw_channel.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_b_channel.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_cmd_arbiter.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_cmd_fsm.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_cmd_translator.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_fifo.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_incr_cmd.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_r_channel.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_w_channel.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_wr_cmd_fsm.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_wrap_cmd.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_a_upsizer.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_register_slice.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axi_upsizer.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_axic_register_slice.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_carry_and.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_carry_latch_and.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_carry_latch_or.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_carry_or.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_command_fifo.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_comparator.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_comparator_sel.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_comparator_sel_static.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_r_upsizer.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi/ddr4_v2_2_w_upsizer.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_addr_decode.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_read.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_reg_bank.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_reg.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_top.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/axi_ctrl/ddr4_v2_2_axi_ctrl_write.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/clocking/ddr4_v2_2_infrastructure.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_xsdb_bram.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_write.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_wr_byte.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_wr_bit.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_sync.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_read.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_rd_en.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_pi.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_mc_odt.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_debug_microblaze.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_cplx_data.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_cplx.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_config_rom.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_addr_decode.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_top.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal_xsdb_arbiter.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_cal.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_chipscope_xsdb_slave.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_v2_2_dp_AB9.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top/ddr4.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top/ddr4_ddr4.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/ip_top/ddr4_ddr4_mem_intfc.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/rtl/cal/ddr4_ddr4_cal_riu.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/ddr4_ex.srcs/sources_1/ip/ddr4/tb/microblaze_mcs_0.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/arch_package.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/proj_package.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_model.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_axi_opcode_gen.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_axi_tg_top.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_axi_wrapper.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_boot_mode_gen.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_custom_mode_gen.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_data_chk.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_data_gen.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/ddr4_v2_2_prbs_mode_gen.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/example_top.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/interface.sv" \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/imports/sim_tb_top.sv" \

vlog -work xil_defaultlib \
"/home/mdl/izo5011/IkennaWorkSpace/SYSC_FPGA/ip/ddr4_ex/questa/glbl.v"

