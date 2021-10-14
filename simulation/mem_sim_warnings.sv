  // add after signal declarations in sim_tb_top.sv
  
  initial begin
    #1ps;         //(any time here should work, as long as it is before the writes)
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[0].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[1].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[2].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[3].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[4].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[5].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[6].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[7].ddr4_model.set_memory_warnings(0,0);
    sim_tb_top.mem_model_x8.memModels_Ri1[0].memModel1[8].ddr4_model.set_memory_warnings(0,0);

  end
