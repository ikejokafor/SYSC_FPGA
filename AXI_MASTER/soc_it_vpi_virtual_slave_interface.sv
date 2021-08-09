`ifndef __SOC_IT_VPI_VIRTUAL_SLAVE_INTERFACE__
`define __SOC_IT_VPI_VIRTUAL_SLAVE_INTERFACE__

`include "transaction.sv"

virtual class soc_it_vpi_virtual_slave_interface;
    function new();
    endfunction
    
    pure virtual task do_transaction(input Transaction transaction);
    pure virtual function void deassert();
    pure virtual task initialize();
    pure virtual task wait_rst();
    pure virtual task wait_clk();
    pure virtual function bit has_interrupt();
    
endclass

`endif