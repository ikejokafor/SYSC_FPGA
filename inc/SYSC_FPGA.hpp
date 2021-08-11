#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "CNN_Layer_Accel.hpp"
#include "SYSC_FPGA_shim.hpp"
#include "syscNetProto.hpp"


SC_MODULE(SYSC_FPGA)
{
	public:
#ifdef DDR_AXI_MEMORY
    sc_core::sc_in<bool>						      clk				                                        ;
    sc_core::sc_in<bool>						      rst				                                        ;
   // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    output logic [            `MAX_FAS_RD_ID - 1:0]   init_read_req              							    ;
    output logic [         C_INIT_REQ_ID_WTH - 1:0]   init_read_req_id           							    ;
    output logic [    C_INIT_MEM_RD_ADDR_WTH - 1:0]   init_read_addr             							    ;
    output logic [     C_INIT_MEM_RD_LEN_WTH - 1:0]   init_read_len              							    ;
    input  logic [            `MAX_FAS_RD_ID - 1:0]   init_read_req_ack          							    ;
    input  logic [            `MAX_FAS_RD_ID - 1:0]   init_read_in_prog          							    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
    input  logic [       `INIT_RD_DATA_WIDTH - 1:0]   init_read_data             							    ;
    input  logic [            `MAX_FAS_RD_ID - 1:0]   init_read_data_vld         							    ;
    output logic [            `MAX_FAS_RD_ID - 1:0]   init_read_data_rdy         							    ;
    input  logic [            `MAX_FAS_RD_ID - 1:0]   init_read_cmpl             							    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
    output logic                                      init_write_req             							    ;
    output logic                                      init_write_req_id          							    ;
    output logic [       `INIT_WR_ADDR_WIDTH - 1:0]   init_write_addr            							    ;
    output logic [        `INIT_WR_LEN_WIDTH - 1:0]   init_write_len             							    ;
    input  logic                                      init_write_req_ack         							    ;
    input  logic                                      init_write_in_prog         							    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------   
    output logic [       `INIT_RD_DATA_WIDTH - 1:0]   init_write_data            							    ;
    output logic                                      init_write_data_vld        							    ;
    input  logic                                      init_write_data_rdy        							    ;
    input  logic                                      init_write_cmpl            							    ;
#else
		sc_core::sc_clock clk;
#endif


    CNN_Layer_Accel* cnn_layer_accel;

    SC_CTOR(SYSC_FPGA)
#ifndef DDR_AXI_MEMORY
		: 	clk("clk", CLK_PRD, sc_core::SC_NS)
#endif
    {
        cnn_layer_accel = new CNN_Layer_Accel("CNN_Layer_Accel");
        cnn_layer_accel->clk(clk);
#ifdef DDR_AXI_MEMORY
		cnn_layer_accel->rst(rst);
		cnn_layer_accel->axi_awready(axi_awready);
		axi_awid(cnn_layer_accel->axi_awid);
		axi_awaddr(cnn_layer_accel->axi_awaddr);
		axi_awlen(cnn_layer_accel->axi_awlen);
		axi_awsize(cnn_layer_accel->axi_awsize);
		axi_awburst(cnn_layer_accel->axi_awburst);
		axi_awvalid(cnn_layer_accel->axi_awvalid);
		// AXI write data channel signals
		cnn_layer_accel->axi_wready(axi_wready);
		axi_wdata(cnn_layer_accel->axi_wdata);
		axi_wstrb(cnn_layer_accel->axi_wstrb);
		axi_wlast(cnn_layer_accel->axi_wlast);
		axi_wvalid(cnn_layer_accel->axi_wvalid);
		// AXI write response channel signals
		cnn_layer_accel->axi_bid(axi_bid);
		cnn_layer_accel->axi_bresp(axi_bresp);
		cnn_layer_accel->axi_bvalid(axi_bvalid);
		axi_bready(cnn_layer_accel->axi_bready);
		// AXI read address channel signals
		cnn_layer_accel->axi_arready(axi_arready);
		axi_arid(cnn_layer_accel->axi_arid);
		axi_araddr(cnn_layer_accel->axi_araddr);
		axi_arlen(cnn_layer_accel->axi_arlen);
		axi_arsize(cnn_layer_accel->axi_arsize); 
		axi_arburst(cnn_layer_accel->axi_arburst);
		axi_arvalid(cnn_layer_accel->axi_arvalid);
		// AXI read data channel signals   
		cnn_layer_accel->axi_rid(axi_rid);
		cnn_layer_accel->axi_rresp(axi_rresp);
		cnn_layer_accel->axi_rvalid(axi_rvalid);  
		cnn_layer_accel->axi_rdata(axi_rdata);   
		cnn_layer_accel->axi_rlast(axi_rlast);   
		axi_rready(cnn_layer_accel->axi_rready);   
#endif

	    SC_THREAD(main)
            sensitive << clk.posedge_event();
			
		m_sysc_fpga_hndl    = reinterpret_cast<SYSC_FPGA_hndl*>(NULL);
		m_pyld = new SYSC_FPGA_shim_pyld();
		m_pyld->m_size = ACCL_META_OUTPUT_SIZE;
		m_pyld->m_buffer = (void*)malloc(m_pyld->m_size);
    }

	~SYSC_FPGA();
    void start_of_simulation();
	void main();

    SYSC_FPGA_hndl* m_sysc_fpga_hndl;
    SYSC_FPGA_shim_pyld* m_pyld;
};