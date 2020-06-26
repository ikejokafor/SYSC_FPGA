#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "CNN_Layer_Accel.hpp"
#include "SYSC_FPGA_shim.hpp"
#include "MyNetProto.hpp"


class DummyPayload : public Accel_Payload
{
    public:
        DummyPayload() { }
        ~DummyPayload() { }
		uint64_t allocate(int size) { }
		void deallocate() { }
		void serialize() { }
        void deserialize() { }
};


SC_MODULE(SYSC_FPGA)
{
#ifdef SIMULATE_MEMORY
	sc_core::sc_in<bool>						clk				;
	sc_core::sc_in<bool >  						axi_awready		;	// Indicates slave is ready to accept a 
	sc_core::sc_out<sc_lv<32> >  				axi_awid		;	// Write ID
	sc_core::sc_out<sc_lv<33> > 				axi_awaddr		;	// Write address
	sc_core::sc_out<sc_lv<8> >  				axi_awlen		;	// Write Burst Length
	sc_core::sc_out<sc_lv<3> >  				axi_awsize		;	// Write Burst size
	sc_core::sc_out<sc_lv<2> >  				axi_awburst		;	// Write Burst type
	sc_core::sc_out<sc_lv<4> >  				axi_awcache		;	// Write Cache type
	sc_core::sc_out<sc_lv<3> >					axi_awprot		;	// Write Protection type
	sc_core::sc_out<bool >  					axi_awvalid		;	// Write address valid
	// AXI write data channel signals
	sc_core::sc_in<bool >  						axi_wready		;	// Write data ready
	sc_core::sc_out<sc_lv<512> >  				axi_wdata		;	// Write data
	sc_core::sc_out<sc_lv<64> >  				axi_wstrb		;	// Write strobes
	sc_core::sc_out<bool >  					axi_wlast		;	// Last write transaction   
	sc_core::sc_out<bool >  					axi_wvalid		;	// Write valid  
	// AXI write response channel signals
	sc_core::sc_in<sc_lv<32> >  				axi_bid			;	// Response ID
	sc_core::sc_in<sc_lv<2> >  					axi_bresp		;	// Write response
	sc_core::sc_in<bool >  						axi_bvalid		;	// Write reponse valid
	sc_core::sc_out<bool>  						axi_bready		;	// Response ready
	// AXI read address channel signals
	sc_core::sc_in<bool >  						axi_arready		;   // Read address ready
	sc_core::sc_out<sc_lv<32> > 				axi_arid		;	// Read ID
	sc_core::sc_out<sc_lv<33> >					axi_araddr		;   // Read address
	sc_core::sc_out<sc_lv<8> > 					axi_arlen		;   // Read Burst Length
	sc_core::sc_out<sc_lv<3> > 					axi_arsize		;   // Read Burst size
	sc_core::sc_out<sc_lv<2> > 					axi_arburst		;   // Read Burst type
	sc_core::sc_out<sc_lv<4> > 					axi_arcache		;   // Read Cache type
	sc_core::sc_out<bool >  					axi_arvalid		;   // Read address valid 
	// AXI read data channel signals   
	sc_core::sc_in<sc_lv<32> > 					axi_rid			;   // Response ID
	sc_core::sc_in<sc_lv<2> > 					axi_rresp		;   // Read response
	sc_core::sc_in<bool> 						axi_rvalid		;   // Read reponse valid
	sc_core::sc_in<sc_lv<512> > 				axi_rdata		;   // Read data
	sc_core::sc_in<bool> 						axi_rlast		;   // Read last
	sc_core::sc_out<bool> 						axi_rready		;   // Read Response ready
#else
	sc_core::sc_clock clk;	
#endif


    CNN_Layer_Accel* cnn_layer_accel;

    SC_CTOR(SYSC_FPGA)
#ifndef SIMULATE_MEMORY
		: clk("clk", CLK_PRD, sc_core::SC_NS)
#endif
    {
        cnn_layer_accel = new CNN_Layer_Accel("CNN_Layer_Accel");
        cnn_layer_accel->clk(clk);
#ifdef SIMULATE_MEMORY
		cnn_layer_accel->axi_awready(axi_awready);
		axi_awid(cnn_layer_accel->axi_awid);
		axi_awaddr(cnn_layer_accel->axi_awaddr);
		axi_awlen(cnn_layer_accel->axi_awlen);
		axi_awsize(cnn_layer_accel->axi_awsize);
		axi_awburst(cnn_layer_accel->axi_awburst);
		axi_awcache(cnn_layer_accel->axi_awcache);
		axi_awprot(cnn_layer_accel->axi_awprot);
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
		axi_arcache(cnn_layer_accel->axi_arcache);
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
        m_pyld = new DummyPayload();
        m_pyld->m_address = (uint64_t)malloc(ACCL_OUTPUT_SIZE);
        m_pyld->m_size = ACCL_OUTPUT_SIZE;
    }

	~SYSC_FPGA();
    void start_of_simulation();
	void main();

    SYSC_FPGA_hndl* m_sysc_fpga_hndl;
    DummyPayload* m_pyld;
};