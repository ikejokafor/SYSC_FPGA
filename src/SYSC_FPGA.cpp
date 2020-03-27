#include "SYSC_FPGA.hpp"
using namespace std;


SYSC_FPGA::~SYSC_FPGA()
{
	
}


void SYSC_FPGA::main()
{
	uint64_t addr;
	while(true)
	{
		wait();
		addr = m_sysc_fpga_hndl->waitConfig();
		wait();
		cnn_layer_accel->setMemory(addr);

		// Image
		wait();
		addr = m_sysc_fpga_hndl->waitParam();
		wait();
		cnn_layer_accel->setMemory(addr);
		// Kernels
		wait();
		addr = m_sysc_fpga_hndl->waitParam();
		wait();
		cnn_layer_accel->setMemory(addr);
		// Output
		wait();
		addr = m_sysc_fpga_hndl->waitParam();
		wait();
		cnn_layer_accel->setMemory(addr);

		wait();
		m_sysc_fpga_hndl->waitStart();
		wait();
		cnn_layer_accel->start();
		wait();
		cnn_layer_accel->waitComplete();
		wait();
		m_sysc_fpga_hndl->sendComplete();
	}
}
