#include "systemc"
#include "SYSC_FPGA.hpp"
using namespace sc_core;
using namespace sc_dt;
using namespace std;


int sc_main(int argc, char* argv[])
{
	sc_set_time_resolution(1, SC_NS);
	SYSC_FPGA* sysc_fpga = new SYSC_FPGA("SYSC_FPGA");
	sc_start();
	return 0;
}
