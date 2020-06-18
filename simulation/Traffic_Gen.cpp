#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "string.h"
#include <deque>
#include <sstream>
using namespace std;
using namespace sc_core;
using namespace sc_dt;


SC_MODULE(Traffic_Gen)
{
	sc_in<bool>		clk				;
	sc_in<bool >  	axi_awready		;	// Indicates slave is ready to accept a 
	sc_out<sc_lv<4> >  	axi_awid		;	// Write ID
	sc_out<sc_lv<29> >  	axi_awaddr		;	// Write address
	sc_out<sc_lv<8> >  	axi_awlen		;	// Write Burst Length
	sc_out<sc_lv<3> >  	axi_awsize		;	// Write Burst size
	sc_out<sc_lv<2> >  	axi_awburst		;	// Write Burst type
	sc_out<sc_lv<4> >  	axi_awcache		;	// Write Cache type
	sc_out<bool >  	axi_awvalid		;	// Write address valid
	// AXI write data channel signals
	sc_in<bool >  	axi_wready		;	// Write data ready
	sc_out<sc_lv<64> >  	axi_wdata		;	// Write data
	sc_out<sc_lv<8> >  	axi_wstrb		;	// Write strobes
	sc_out<bool >  	axi_wlast		;	// Last write transaction   
	sc_out<bool >  	axi_wvalid		;	// Write valid  
	// AXI write response channel signals
	sc_in<sc_lv<4> >  	axi_bid			;	// Response ID
	sc_in<sc_lv<2> >  	axi_bresp		;	// Write response
	sc_in<bool >  	axi_bvalid		;	// Write reponse valid
	sc_out<bool>  	axi_bready		;	// Response ready
	// AXI read address channel signals
	sc_in<bool >  	axi_arready		;   // Read address ready
	sc_out<sc_lv<4> > axi_arid		;	// Read ID
	sc_out<sc_lv<29> >axi_araddr		;   // Read address
	sc_out<sc_lv<8> > axi_arlen		;   // Read Burst Length
	sc_out<sc_lv<3> > axi_arsize		;   // Read Burst size
	sc_out<sc_lv<2> > axi_arburst		;   // Read Burst type
	sc_out<sc_lv<4> > axi_arcache		;   // Read Cache type
	sc_out<bool >  	axi_arvalid		;   // Read address valid 
	// AXI read data channel signals   
	sc_in<sc_lv<4> > axi_rid			;   // Response ID
	sc_in<sc_lv<2> > axi_rresp		;   // Read response
	sc_in<bool> axi_rvalid		;   // Read reponse valid
	sc_in<sc_lv<64> > axi_rdata		;   // Read data
	sc_in<bool> axi_rlast		;   // Read last
	sc_out<bool> axi_rready		;   // Read Response ready
	
	

	
	
	SC_CTOR(Traffic_Gen)
	{
		SC_THREAD(run)
			sensitive << clk.pos();
	}
	
	void run()
	{
		
		axi_awid		= 0;
		axi_awaddr		= 0;
		axi_awlen		= 0;
		axi_awsize		= 0;
		axi_awburst		= 0;
		axi_awcache		= 0;
		axi_awvalid		= 0;

		axi_wdata		= 0;
		axi_wstrb		= 0;
		axi_wlast		= 0;  
		axi_wvalid		= 0;

		axi_bready		= 1;
		
		axi_arid		= 0;
		axi_araddr		= 0;
		axi_arlen	    = 0;
		axi_arsize	    = 0;
		axi_arburst	    = 0;
		axi_arcache	    = 0;
		axi_arvalid	    = 0;

		axi_rready		= 1;


		
		std::stringstream stream;
		deque<int> mem_queue;
		
		
		for(int i = 0; i < 64; i++)
		{
			mem_queue.push_back(rand());
		}
		
		while(true) {
			wait();
			if(axi_awready->read()) {
				break;
			}
		}


		wait();
		axi_awvalid = true;		
		axi_awid = "0x0"; 			
		axi_awaddr = "0x00000000";
		axi_awlen = "0x3F";		
		axi_awsize = "0x3";
		axi_awburst = "0x1";
		axi_wstrb = "0xFF";
		wait();
		axi_awvalid->write(false);


		// stream << std::hex << mem_queue.pop_front();
		axi_wdata.write("0xDEADBEEFDEADBEEF");
		wait();
		axi_wvalid->write(true);
		while(true) {
			wait();
			if(mem_queue.size() == 0) {
				break;
			}
			if(mem_queue.size() == 1) {
				axi_wlast = true;
			}
			if(axi_wready->read()) {
				// stream << std::hex << mem_queue.pop_front();
				axi_wdata = "0xDEADBEEFDEADBEEF";
			}
		}
		axi_wvalid->write(true);
		axi_wlast->write("0x0");

		while(true) {
			wait();
			if(axi_bvalid->read()) {
				break;
			}
		}
		axi_awvalid = false;	
		axi_awid = "0x0"; 			
		axi_awaddr = "0x00000000";
		axi_awlen = "0x00";	
		axi_awsize = "0x0";
		axi_awburst = "0x0";
		axi_wstrb = "0x00";

	}
};


SC_MODULE_EXPORT(Traffic_Gen);