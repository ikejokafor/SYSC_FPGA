`ifndef __SOC_IT_VPI_AXI_TRANSACTION__
`define __SOC_IT_VPI_AXI_TRANSACTION__

`include "transaction.sv"

class axi_transaction;
    
    longint unsigned AxADDR;
    int unsigned AxSIZE;
    int unsigned AxLEN;
    int unsigned length;
 
    longint unsigned start_address;
    longint unsigned aligned_address;
    int unsigned number_bytes;
    int C_DATA_BUS_SIZE;
    
    Transaction transaction;
    
	function new(
        input int                   C_DATA_BUS_SIZE ,
        ref Transaction             transaction     ,
        input longint   unsigned    address         ,
        input int       unsigned    length      
    ); 
        longint unsigned  bus_aligned_address;
        int unsigned max_length;
        
        bus_aligned_address     = ((address) / C_DATA_BUS_SIZE) * C_DATA_BUS_SIZE;
        max_length              = (bus_aligned_address + (256*C_DATA_BUS_SIZE)) - (address);
        
        this.start_address      = address;
        this.length             = (length > max_length) ? max_length : length;
        this.transaction        = transaction;
        this.C_DATA_BUS_SIZE    = C_DATA_BUS_SIZE;
        
        AxADDR                  = address;
        AxSIZE                  = clog2((this.length >= C_DATA_BUS_SIZE) ? C_DATA_BUS_SIZE : this.length);
        
        number_bytes            = 2**AxSIZE;
        start_address           = AxADDR;
        aligned_address         = (AxADDR / number_bytes) * number_bytes;
        
        AxLEN                   = $ceil(real'((start_address + this.length) - aligned_address) / real'(number_bytes)) - 1;
	endfunction
	
    extern function bit[127:0] get_slv_data(bit[63:0] address);
	extern function void set_slv_data(bit[63:0] address, bit[127:0] data);

endclass : axi_transaction

//-----------------------------------------------------------------------------
function bit[127:0] axi_transaction::get_slv_data(bit[63:0] address);
	return transaction.get_slv_data(address);
endfunction : get_slv_data
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void axi_transaction::set_slv_data(bit[63:0] address, bit[127:0] data);
	transaction.set_slv_data(address,data);
endfunction : set_slv_data
//-----------------------------------------------------------------------------


`endif