#include "SYSC_FPGA.hpp"
using namespace std;
using namespace sc_core;
using namespace sc_dt;


SYSC_FPGA::~SYSC_FPGA()
{
    delete m_sysc_fpga_hndl;
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
    cnn_layer_accel->m_accelCfg->m_fpga_hndl = reinterpret_cast<FPGA_hndl*>(m_sysc_fpga_hndl);
}


#ifdef DDR_AXI_MEM_SIM
void SYSC_FPGA::b_wait_sys_boot()
{
    while(true)
    {
        wait();
        if(ce->read() == 0x1)
        {
            break;
        }
    }
}
#endif


void SYSC_FPGA::main()
{
	uint64_t addr;
	int size;
	double* ptr;
    int max_sys_mem_trans;    
	double elapsedTime;
	double memPower;
	double QUAD_time;
	double FAS_time;
#ifdef DDR_AXI_MEM_SIM
    b_wait_sys_boot();
#endif
	while(true)
	{

        wait();

        // SystemC config
        wait();
        addr = m_sysc_fpga_hndl->wait_sysC_FPGAconfig();
        max_sys_mem_trans = *((int*)addr);
        cnn_layer_accel->m_max_sys_mem_trans = max_sys_mem_trans;
        wait();

		// Config
		wait();
		addr = m_sysc_fpga_hndl->waitConfig();
		wait();
		cnn_layer_accel->setMemory(0, addr, -1);    // FIXME: Hardcoding
        wait();

		// // Input Map
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(1, addr, size);    // FIXME: Hardcoding
        // wait();
        //
		// // Kernels 3x3
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(2, addr, size);    // FIXME: Hardcoding
        // wait();
        //
        // // Kernels 3x3 Bias
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(3, addr, size);    // FIXME: Hardcoding
        // wait();
        //
		// // Kernels 1x1
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(4, addr, size);    // FIXME: Hardcoding
        // wait();
        //
        // // Kernels 1x1 Bias
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(5, addr, size);    // FIXME: Hardcoding
        // wait();
        //
		// // Partial Maps
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(6, addr, size);    // FIXME: Hardcoding
        // wait();
        //
		// // ResidualMaps
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(7, addr, size);    // FIXME: Hardcoding
        // wait();
        //
        // // Prev1x1Maps Maps
		// wait();
		// m_sysc_fpga_hndl->waitParam(addr, size);
		// wait();
		// cnn_layer_accel->setMemory(8, addr, size);    // FIXME: Hardcoding
        // wait();
        
        // Start and Wait
		wait();
		m_sysc_fpga_hndl->waitStart();
		wait();
		cnn_layer_accel->start();
		wait();
		cnn_layer_accel->waitComplete(elapsedTime, memPower, QUAD_time, FAS_time);
		wait();
		m_sysc_fpga_hndl->sendComplete();
        wait();
        
        // // Output Maps
        // mem_ele_t* mem_ele = cnn_layer_accel->getMemory(9);    // FIXME: Hardcoding
        // m_pyld->m_buffer = (void*)mem_ele->addr;
        // m_pyld->m_size = mem_ele->size;
        // m_sysc_fpga_hndl->sendOutput(m_pyld);

        // Stat output
        wait();
		ptr = (double*)m_pyld->m_buffer;
        ptr[0] = elapsedTime;
        ptr[1] = memPower;
        ptr[2] = QUAD_time;
        ptr[3] = FAS_time;
		m_pyld->m_size = ACCL_META_OUTPUT_SIZE;        
        m_sysc_fpga_hndl->sendOutput(m_pyld);
        
        cout << endl << endl;
        cout << "[SYSC_FPGA]: Layer Processing Complete" << endl;
        cout << endl << endl;
	}
    
}

#ifdef MODEL_TECH
SC_MODULE_EXPORT(SYSC_FPGA);
#endif
