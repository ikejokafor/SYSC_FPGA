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
    sc_core::sc_in<bool>						        clk				        ;
    sc_core::sc_in<bool>						        rst				        ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core::sc_out<sc_bv<MAX_FAS_RD_REQ> >             init_read_req           ;
    sc_core::sc_out<sc_bv<INIT_REQ_ID_WTH> >            init_read_req_id        ;
    sc_core::sc_out<sc_bv<INIT_MEM_RD_ADDR_WTH> >       init_read_addr          ;
    sc_core::sc_out<sc_bv<INIT_MEM_RD_LEN_WTH> >        init_read_len           ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >             init_read_req_ack       ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >             init_read_in_prog       ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core:: sc_in<sc_bv<INIT_RD_DATA_WIDTH> >         init_read_data          ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >             init_read_data_vld      ;
    sc_core::sc_out<sc_bv<MAX_FAS_RD_REQ> >             init_read_data_rdy      ;
    sc_core:: sc_in<sc_bv<MAX_FAS_RD_REQ> >             init_read_cmpl          ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core::sc_out<bool>                               init_write_req          ;
    sc_core::sc_out<bool>                               init_write_req_id       ;
    sc_core::sc_out<sc_bv<32> >                         init_write_addr         ;
    sc_core::sc_out<sc_bv<32> >                         init_write_len          ;
    sc_core:: sc_in<bool>                               init_write_req_ack      ;
    sc_core:: sc_in<bool>                               init_write_in_prog      ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    sc_core::sc_out<sc_bv<32> >                         init_write_data         ;
    sc_core::sc_out<bool>                               init_write_data_vld     ;
    sc_core:: sc_in<bool>                               init_write_data_rdy     ;
    sc_core:: sc_in<bool>                               init_write_cmpl         ;
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
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        init_read_req(cnn_layer_accel->init_read_req);
        init_read_req_id(cnn_layer_accel->init_read_req_id);
        init_read_addr(cnn_layer_accel->init_read_addr);
        init_read_len(cnn_layer_accel->init_read_len);
        cnn_layer_accel->init_read_req_ack(init_read_req_ack);
        cnn_layer_accel->init_read_in_prog(init_read_in_prog);
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        cnn_layer_accel->init_read_data(init_read_data);
        cnn_layer_accel->init_read_data_vld(init_read_data_vld);
        init_read_data_rdy(cnn_layer_accel->init_read_data_rdy);
        cnn_layer_accel->init_read_cmpl(init_read_cmpl);
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        init_write_req(cnn_layer_accel->init_write_req);
        init_write_req_id(cnn_layer_accel->init_write_req_id);
        init_write_addr(cnn_layer_accel->init_write_addr);
        init_write_len(cnn_layer_accel->init_write_len);
        cnn_layer_accel->init_write_req_ack(init_write_req_ack);
        cnn_layer_accel->init_write_in_prog(init_write_in_prog);
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        init_write_data(cnn_layer_accel->init_write_data);
        init_write_data_vld(cnn_layer_accel->init_write_data_vld);
        cnn_layer_accel->init_write_data_rdy(init_write_data_rdy);
        cnn_layer_accel->init_write_cmpl(init_write_cmpl);
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
