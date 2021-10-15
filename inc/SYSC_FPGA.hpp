#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "CNN_Layer_Accel.hpp"
#include "SYSC_FPGA_shim.hpp"
#include "syscNetProto.hpp"


SC_MODULE(SYSC_FPGA)
{
	public:
#ifdef DDR_AXI_MEM_SIM
    sc_core::sc_in<bool>						 clk				    ;
    sc_core::sc_in<bool>                         ce                     ;
    sc_core::sc_in<bool>						 rst				    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core::sc_out<sc_bv<MAX_FAS_RD_REQ> >      init_rd_req            ;
    sc_core::sc_out<sc_bv<N_INIT_ID_WTH> >       init_rd_req_id         ;
    sc_core::sc_out<sc_bv<N_INIT_ADDR_WTH> >     init_rd_addr           ;
    sc_core::sc_out<sc_bv<N_INIT_LEN_WTH> >      init_rd_len            ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >      init_rd_req_ack        ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core:: sc_in<sc_bv<N_INIT_DATA_WTH> >     init_rd_data           ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >      init_rd_data_vld       ;
    sc_core::sc_out<sc_bv<MAX_FAS_RD_REQ> >      init_rd_data_rdy       ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >      init_rd_cmpl           ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core::sc_out<bool>                        init_wr_req            ;
    sc_core::sc_out<sc_bv<INIT_ID_WTH> >         init_wr_req_id         ;
    sc_core::sc_out<sc_bv<INIT_ADDR_WTH> >       init_wr_addr           ;
    sc_core::sc_out<sc_bv<INIT_LEN_WTH> >        init_wr_len            ;
    sc_core:: sc_in<bool>                        init_wr_req_ack        ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core::sc_out<sc_bv<INIT_DATA_WTH> >       init_wr_data           ;
    sc_core::sc_out<bool>                        init_wr_data_vld       ;
    sc_core:: sc_in<bool>                        init_wr_data_rdy       ;
    sc_core:: sc_in<bool>                        init_wr_cmpl           ;
#else
    sc_core::sc_clock clk;
#endif


    CNN_Layer_Accel* cnn_layer_accel;

    SC_CTOR(SYSC_FPGA)
#ifndef DDR_AXI_MEM_SIM
		: 	clk("clk", CLK_PRD, sc_core::SC_NS)
#endif
    {
        cnn_layer_accel = new CNN_Layer_Accel("CNN_Layer_Accel");
        cnn_layer_accel->clk(clk);
#ifdef DDR_AXI_MEM_SIM
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        cnn_layer_accel->ce(ce);
        cnn_layer_accel->init_rd_req(init_rd_req);
        cnn_layer_accel->init_rd_req_id(init_rd_req_id);
        cnn_layer_accel->init_rd_addr(init_rd_addr);
        cnn_layer_accel->init_rd_len(init_rd_len);
        cnn_layer_accel->init_rd_req_ack(init_rd_req_ack);
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        cnn_layer_accel->init_rd_data(init_rd_data);
        cnn_layer_accel->init_rd_data_vld(init_rd_data_vld);
        cnn_layer_accel->init_rd_data_rdy(init_rd_data_rdy);
        cnn_layer_accel->init_rd_cmpl(init_rd_cmpl);
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        cnn_layer_accel->init_wr_req(init_wr_req);
        cnn_layer_accel->init_wr_req_id(init_wr_req_id);
        cnn_layer_accel->init_wr_addr(init_wr_addr);
        cnn_layer_accel->init_wr_len(init_wr_len);
        cnn_layer_accel->init_wr_req_ack(init_wr_req_ack);
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        cnn_layer_accel->init_wr_data(init_wr_data);
        cnn_layer_accel->init_wr_data_vld(init_wr_data_vld);
        cnn_layer_accel->init_wr_data_rdy(init_wr_data_rdy);
        cnn_layer_accel->init_wr_cmpl(init_wr_cmpl);
        SC_THREAD(b_wait_sys_boot)
            sensitive << clk.posedge_event();
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
#ifdef DDR_AXI_MEM_SIM    
    void b_wait_sys_boot();
#endif
    SYSC_FPGA_hndl* m_sysc_fpga_hndl;
    SYSC_FPGA_shim_pyld* m_pyld;
};
