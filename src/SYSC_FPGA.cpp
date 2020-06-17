#include "SYSC_FPGA.hpp"
using namespace std;
using namespace sc_core;
using namespace sc_dt;


SYSC_FPGA::~SYSC_FPGA()
{

}


void SYSC_FPGA::start_of_simulation()
{
	m_sysc_fpga_hndl = new SYSC_FPGA_hndl();
	if(m_sysc_fpga_hndl->hardware_init() == -1)
	{
		std::cout << "Hardware Init Failed" << std::endl;
		sc_core::sc_stop();
		exit(1);
	}
}


void SYSC_FPGA::main()
{
	uint64_t addr;
	while(true)
	{
		// Config
		wait();
		addr = m_sysc_fpga_hndl->waitConfig();
		wait();
		cnn_layer_accel->setMemory(addr);

		// Image
		// wait();
		// addr = m_sysc_fpga_hndl->waitParam();
		// wait();
		// cnn_layer_accel->setMemory(addr);
		//
		// // Kernels 3x3
		// wait();
		// addr = m_sysc_fpga_hndl->waitParam();
		// wait();
		// cnn_layer_accel->setMemory(addr);
		//
		// // Kernels 1x1
		// wait();
		// addr = m_sysc_fpga_hndl->waitParam();
		// wait();
		// cnn_layer_accel->setMemory(addr);
		//
		// // PartialMaps
		// wait();
		// addr = m_sysc_fpga_hndl->waitParam();
		// wait();
		// cnn_layer_accel->setMemory(addr);
		//
		// // ResidualMaps
		// wait();
		// addr = m_sysc_fpga_hndl->waitParam();
		// wait();
		// cnn_layer_accel->setMemory(addr);
		//
		// // Output
		// wait();
		// addr = m_sysc_fpga_hndl->waitParam();
		// wait();
		// cnn_layer_accel->setMemory(addr);

		wait();
		m_sysc_fpga_hndl->waitStart();
		wait();
		cnn_layer_accel->start();
		wait();
        double* ptr = (double*)m_pyld->m_address;
        double elapsedTime;
		double memPower;
		cnn_layer_accel->waitComplete(elapsedTime, memPower);
        ptr[0] = elapsedTime;
        ptr[1] = memPower;
		wait();
		m_sysc_fpga_hndl->sendComplete();
		wait();
		m_sysc_fpga_hndl->sendOutput(reinterpret_cast<Accel_Payload*>(m_pyld));
		wait();
	}
}

#ifdef MODEL_TECH
SC_MODULE_EXPORT(SYSC_FPGA);
#endif
