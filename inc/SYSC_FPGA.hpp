#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "CNN_Layer_Accel.hpp"
#include "SYSC_FPGA_shim.hpp"
#include "Network.hpp"
#include "MyNetProto.hpp"


SC_MODULE(SYSC_FPGA)
{
	sc_core::sc_clock clk;
    CNN_Layer_Accel* cnn_layer_accel;


    SC_CTOR(SYSC_FPGA)
		: clk("clk", CLK_PRD, sc_core::SC_NS)
    {
        cnn_layer_accel = new CNN_Layer_Accel("CNN_Layer_Accel");
        cnn_layer_accel->clk(clk);
        m_sysc_fpga_hndl = new SYSC_FPGA_hndl();
        if(m_sysc_fpga_hndl->hardware_init() == -1)
        {
            std::cout << "Hardware Init Failed" << std::endl;
            sc_core::sc_stop();
            exit(1);
        }
	    SC_THREAD(main)
            sensitive << clk.posedge_event();
    }
	
	~SYSC_FPGA();
    
	void main();
    
    SYSC_FPGA_hndl* m_sysc_fpga_hndl;
};