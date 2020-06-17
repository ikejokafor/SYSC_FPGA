#pragma once


#define SC_INCLUDE_DYNAMIC_PROCESSES


#include "systemc"
#include "CNN_Layer_Accel.hpp"
#include "SYSC_FPGA_shim.hpp"
#include "myNetProto.hpp"


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
	sc_core::sc_clock clk;
    CNN_Layer_Accel* cnn_layer_accel;

    SC_CTOR(SYSC_FPGA)
		: clk("clk", CLK_PRD, sc_core::SC_NS)
    {
        cnn_layer_accel = new CNN_Layer_Accel("CNN_Layer_Accel");
        cnn_layer_accel->clk(clk);
	    SC_THREAD(main)
            sensitive << clk.posedge_event();
        m_pyld = new DummyPayload();
        m_pyld->m_address = (uint64_t)malloc(sizeof(double) * 2);
    }

	~SYSC_FPGA();
    void start_of_simulation();
	void main();

    SYSC_FPGA_hndl* m_sysc_fpga_hndl;
    DummyPayload* m_pyld;
};