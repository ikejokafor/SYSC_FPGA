#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "CNN_Layer_Accel.hpp"
#include "SYSC_FPGA_shim.hpp"
#include "myNetProto.hpp"


SC_MODULE(SYSC_FPGA)
{
	public:
#ifdef SIMULATE_MEMORY
		sc_core::sc_in<bool>						clk				;
		sc_core::sc_in<bool>						rst				;

		sc_core::sc_in<bool >  						a_axi_awready	;	// Indicates slave is ready to accept a 
		sc_core::sc_out<sc_bv<32> >  				a_axi_awid		;	// Write ID
		sc_core::sc_out<sc_bv<33> > 				a_axi_awaddr	;	// Write address
		sc_core::sc_out<sc_bv<8> >  				a_axi_awlen		;	// Write Burst Length
		sc_core::sc_out<sc_bv<3> >  				a_axi_awsize	;	// Write Burst size
		sc_core::sc_out<sc_bv<2> >  				a_axi_awburst	;	// Write Burst type
		sc_core::sc_out<bool >  					a_axi_awvalid	;	// Write address valid
		// AXI write data channel signals
		sc_core::sc_in<bool >  						a_axi_wready	;	// Write data ready
		sc_core::sc_out<sc_bv<512> >  				a_axi_wdata		;	// Write data
		sc_core::sc_out<sc_bv<64> >  				a_axi_wstrb		;	// Write strobes
		sc_core::sc_out<bool >  					a_axi_wlast		;	// Last write transaction   
		sc_core::sc_out<bool >  					a_axi_wvalid	;	// Write valid  
		// AXI write response channel signals
		sc_core::sc_in<sc_bv<32> >  				a_axi_bid		;	// Response ID
		sc_core::sc_in<sc_bv<2> >  					a_axi_bresp		;	// Write response
		sc_core::sc_in<bool >  						a_axi_bvalid	;	// Write reponse valid
		sc_core::sc_out<bool>  						a_axi_bready	;	// Response ready
		// AXI read address channel signals
		sc_core::sc_in<bool >  						a_axi_arready	;   // Read address ready
		sc_core::sc_out<sc_bv<32> > 				a_axi_arid		;	// Read ID
		sc_core::sc_out<sc_bv<33> >					a_axi_araddr	;   // Read address
		sc_core::sc_out<sc_bv<8> > 					a_axi_arlen		;   // Read Burst Length
		sc_core::sc_out<sc_bv<3> > 					a_axi_arsize	;   // Read Burst size
		sc_core::sc_out<sc_bv<2> > 					a_axi_arburst	;   // Read Burst type
		sc_core::sc_out<bool >  					a_axi_arvalid	;   // Read address valid 
		// AXI read data channel signals   
		sc_core::sc_in<sc_bv<32> > 					a_axi_rid		;   // Response ID
		sc_core::sc_in<sc_bv<2> > 					a_axi_rresp		;   // Read response
		sc_core::sc_in<bool> 						a_axi_rvalid    ;   // Read reponse valid
		sc_core::sc_in<sc_bv<512> > 				a_axi_rdata		;   // Read data
		sc_core::sc_in<bool> 						a_axi_rlast		;   // Read last
		sc_core::sc_out<bool> 						a_axi_rready	;   // Read Response ready
        
        sc_core::sc_in<bool >  						c_axi_awready	;	// Indicates slave is ready to accept a 
		sc_core::sc_out<sc_bv<32> >  				c_axi_awid		;	// Write ID
		sc_core::sc_out<sc_bv<33> > 				c_axi_awaddr	;	// Write address
		sc_core::sc_out<sc_bv<8> >  				c_axi_awlen		;	// Write Burst Length
		sc_core::sc_out<sc_bv<3> >  				c_axi_awsize	;	// Write Burst size
		sc_core::sc_out<sc_bv<2> >  				c_axi_awburst	;	// Write Burst type
		sc_core::sc_out<bool >  					c_axi_awvalid	;	// Write address valid
		// AXI write data channel signals
		sc_core::sc_in<bool >  						c_axi_wready	;	// Write data ready
		sc_core::sc_out<sc_bv<512> >  				c_axi_wdata		;	// Write data
		sc_core::sc_out<sc_bv<64> >  				c_axi_wstrb		;	// Write strobes
		sc_core::sc_out<bool >  					c_axi_wlast		;	// Last write transaction   
		sc_core::sc_out<bool >  					c_axi_wvalid	;	// Write valid  
		// AXI write response channel signals
		sc_core::sc_in<sc_bv<32> >  				c_axi_bid		;	// Response ID
		sc_core::sc_in<sc_bv<2> >  					c_axi_bresp		;	// Write response
		sc_core::sc_in<bool >  						c_axi_bvalid	;	// Write reponse valid
		sc_core::sc_out<bool>  						c_axi_bready	;	// Response ready
		// AXI read address channel signals
		sc_core::sc_in<bool >  						c_axi_arready	;   // Read address ready
		sc_core::sc_out<sc_bv<32> > 				c_axi_arid		;	// Read ID
		sc_core::sc_out<sc_bv<33> >					c_axi_araddr	;   // Read address
		sc_core::sc_out<sc_bv<8> > 					c_axi_arlen		;   // Read Burst Length
		sc_core::sc_out<sc_bv<3> > 					c_axi_arsize	;   // Read Burst size
		sc_core::sc_out<sc_bv<2> > 					c_axi_arburst	;   // Read Burst type
		sc_core::sc_out<bool >  					c_axi_arvalid	;   // Read address valid 
		// AXI read data channel signals   
		sc_core::sc_in<sc_bv<32> > 					c_axi_rid		;   // Response ID
		sc_core::sc_in<sc_bv<2> > 					c_axi_rresp		;   // Read response
		sc_core::sc_in<bool> 						c_axi_rvalid    ;   // Read reponse valid
		sc_core::sc_in<sc_bv<512> > 				c_axi_rdata		;   // Read data
		sc_core::sc_in<bool> 						c_axi_rlast		;   // Read last
		sc_core::sc_out<bool> 						c_axi_rready	;   // Read Response ready
#else
		sc_core::sc_clock clk;
#endif


    CNN_Layer_Accel* cnn_layer_accel;

    SC_CTOR(SYSC_FPGA)
#ifndef SIMULATE_MEMORY
		: 	clk("clk", CLK_PRD, sc_core::SC_NS)
#endif
    {
        cnn_layer_accel = new CNN_Layer_Accel("CNN_Layer_Accel");
        cnn_layer_accel->clk(clk);
#ifdef SIMULATE_MEMORY
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