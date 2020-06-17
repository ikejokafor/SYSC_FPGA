# vopt -64 +acc=npr \
# 	-L work \
# 	-L microblaze_v11_0_0 \
# 	-L lib_cdc_v1_0_2 \
# 	-L proc_sys_reset_v5_0_13 \
# 	-L lmb_v10_v3_0_9 \
# 	-L lmb_bram_if_cntlr_v4_0_15 \
# 	-L blk_mem_gen_v8_4_2 \
# 	-L iomodule_v3_1_4 \
# 	-L unisims_ver \
# 	-L unimacro_ver \
# 	-L secureip \
# 	-L xpm \
# 	-work work work.e work.glbl -o testbench_opt
# 
# vsim -lib work testbench_opt



vopt -64 +acc=npr \
	-L work \
	-work work work.testbench -o testbench_opt

vsim -lib work testbench_opt
# do wave.do
