`ifndef __SOC_IT_AXI_MASTER_INTERFACE__
`define __SOC_IT_AXI_MASTER_INTERFACE__

`timescale 1ns / 1ps

`include "transaction.sv"
`include "axi_transaction.sv"
`include "soc_it_vpi_virtual_slave_interface.sv"
`include "math.vh"


interface axi_master
(
	output	logic								aclk			,
	output	logic								arstn			,
	
	output	logic								awvalid			,
    output  logic                               arvalid         ,
    output  logic   [63:0]                      awaddr          ,
    output  logic   [63:0]                      araddr          ,
    output  logic   [3:0]                       awqos           ,
    output  logic   [3:0]                       arqos           ,
    output  logic   [3:0]                       awcache         ,
    output  logic   [3:0]                       arcache         ,
    output  logic   [7:0]                       awlen           ,
    output  logic   [7:0]                       arlen           ,
    output  logic   [1:0]                       awlock          ,
    output  logic   [1:0]                       arlock          ,
    output  logic   [1:0]                       awburst         ,
    output  logic   [1:0]                       arburst         ,
    output  logic   [2:0]                       awsize          ,
    output  logic   [2:0]                       arsize          ,
    output  logic   [2:0]                       awprot          ,
    output  logic   [2:0]                       arprot          ,
    input   logic                               awready         ,
    input   logic                               arready         ,
    
    input   logic                               wready          ,
    output  logic                               wvalid          ,
    output  logic                               wlast           ,
    output  logic   [31:0]                      wstrb           ,
    output  logic   [255:0]                     wdata           ,
    
    input   logic                               rvalid          ,
    output  logic                               rready          ,
    input   logic                               rlast           ,
    input   logic   [1:0]                       rresp           ,
    input   logic   [255:0]                     rdata           ,
    
    input   logic                               bvalid          ,
    input   logic   [1:0]                       bresp           ,
    output  logic                               bready          ,
    
    input   logic                               irq 
);
	
	clocking axi_addr @(posedge aclk);
		inout	    awvalid			;
        inout       arvalid         ;
        output      awaddr          ;
        output      araddr          ;
        output      awqos           ;
        output      arqos           ;
        output      awcache         ;
        output      arcache         ;
        output      awlen           ;
        output      arlen           ;
        output      awlock          ;
        output      arlock          ;
        output      awburst         ;
        output      arburst         ;
        output      awsize          ;
        output      arsize          ;
        output      awprot          ;
        output      arprot          ;
        input       awready         ;
        input       arready         ;
	endclocking : axi_addr
	modport AXI_Address (clocking axi_addr);
	
	clocking axi_wr @(posedge aclk);
		input       wready          ;
        inout       wvalid          ;
        output      wlast           ;
        output      wstrb           ;
        output      wdata           ;
	endclocking : axi_wr
	modport AXI_Write (clocking axi_wr);
	
	clocking axi_rd @(posedge aclk);
		input       rvalid          ;
        inout       rready          ;
        input       rlast           ;
        input       rresp           ;
        input       rdata           ;
	endclocking : axi_rd
	modport AXI_Read (clocking axi_rd);
	
    clocking axi_resp @(posedge aclk);
		input       bvalid          ;
        input       bresp           ;
        inout       bready          ;
	endclocking : axi_resp
	modport AXI_Response (clocking axi_resp);
    
    clocking axi_irq @(posedge aclk);
        input       irq             ;
    endclocking : axi_irq
    modport AXI_Interrupt (clocking axi_irq);
	
    class concrete_axi_interface extends soc_it_vpi_virtual_slave_interface;
        typedef axi_transaction axi_transaction_group[$];
        bit interrupt_r0;
        bit interrupt_r1;
        bit interrupt_pending;
        
        function new();
        endfunction
    
        task automatic wait_delay(int delay);
		for(int i=0; i<delay; i++)
			@(posedge aclk);
                
        endtask : wait_delay
        
        task automatic wait_clk();
            @(posedge aclk);
        endtask : wait_clk
        
        task automatic wait_rst();
            while (arstn !== 0)
                @(posedge aclk);
                    
            while (arstn === 0)
                @(posedge aclk);
        endtask : wait_rst
        
        task automatic initialize();
            aclk = 0;
            arstn = 1;
      
            fork
                begin
                    forever
                    begin
                        #2;
                        aclk = ~aclk;
                    end
                end
                
                begin
                    arstn = 0;
                    repeat(16)
                        @(posedge aclk);
                        
                    arstn = 1;
                end
                
            join_none
            
            watch_interrupt();
                
        endtask : initialize
        
        task automatic watch_interrupt();
            interrupt_r0        = 1'b0;
            interrupt_r1        = 1'b0;
            interrupt_pending   = 1'b0;
            
            fork
            begin
                wait_rst();
                forever
                begin
                    @(posedge axi_irq.irq)
                        interrupt_pending = 1'b1;
                    /*
                    interrupt_r1 = interrupt_r0;
                    interrupt_r0 = axi_irq.irq;
                    
                    case ({interrupt_r1,interrupt_r0})
                        2'b00 : interrupt_pending = 1'b0;
                        2'b10 : interrupt_pending = 1'b0;
                        2'b01 : interrupt_pending = 1'b1;
                        2'b11 : interrupt_pending = interrupt_pending;
                    endcase
                    */
                end
            end
            join_none
        endtask : watch_interrupt
        //-----------------------------------------------------------------------------
        function void deassert();
            awvalid			= 0;
            arvalid         = 0;
            awaddr          = 0;
            araddr          = 0;
            awqos           = 0;
            arqos           = 0;
            awcache         = 0;
            arcache         = 0;
            awlen           = 0;
            arlen           = 0;
            awlock          = 0;
            arlock          = 0;
            awburst         = 0;
            arburst         = 0;
            awsize          = 0;
            arsize          = 0;
            awprot          = 0;
            arprot          = 0;
            wvalid          = 0;
            wlast           = 0;
            wstrb           = 0;
            wdata           = 0;
            rready          = 0;
            bready          = 0;
        endfunction : deassert
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        function bit has_interrupt();
            has_interrupt = interrupt_pending;
            interrupt_pending = 1'b0;
        endfunction : has_interrupt
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        task automatic address_handler(input axi_transaction transaction);
            bit         addressPhaseComplete;
            /*
            int         burst_size;
            int         max_bytes;
            int         burst_length;
            bit  [64:0] aligned_address;
            bit  [64:0] address;
            bit  [64:0] address_diff;
            
            bit  [14:0] length_bytes;
            real        address_span_bytes_r;
            int         address_span_bytes_i;
                    
            addressPhaseComplete    = 0;
            max_bytes               = (transaction.Info.LengthBytes >= 32) ? 32 : transaction.Info.LengthBytes;
            burst_size              = 2**clog2(max_bytes);
            //burst_length            = transaction.Info.LengthBytes / burst_size;
            address                 = transaction.Info.Address;
            aligned_address         =($unsigned(transaction.Info.Address) / burst_size) * burst_size;
            length_bytes            = transaction.Info.LengthBytes;
            
            address_diff            = (address + length_bytes);
            address_diff            = $unsigned(address_diff - aligned_address);
            address_span_bytes_r    = address_diff;
            address_span_bytes_r    = address_span_bytes_r / burst_size;
            burst_length            = $ceil(address_span_bytes_r);
            */
            
            //if ((length_bytes + address) > (length_bytes + aligned_address))
            //    burst_length        = burst_length + 1;
                
            if ((transaction.transaction.Info.Type == READ))
            begin
                axi_addr.arburst    <= 2'b01;
                axi_addr.arsize     <= transaction.AxSIZE;
                axi_addr.arlen      <= transaction.AxLEN;
                axi_addr.araddr     <= transaction.AxADDR;
                axi_addr.arvalid    <= 1'b1;
            end
            else
            begin
                axi_addr.awburst    <= 2'b01;
                axi_addr.awsize     <= transaction.AxSIZE;
                axi_addr.awlen      <= transaction.AxLEN;
                axi_addr.awaddr     <= transaction.AxADDR;
                axi_addr.awvalid    <= 1'b1;
            end
            
            while (!addressPhaseComplete)
            begin
                @(axi_addr)
                
                if ((axi_addr.awvalid & axi_addr.awready) || (axi_addr.arvalid & axi_addr.arready))
                begin
                    axi_addr.awvalid    <= 0;
                    axi_addr.arvalid    <= 0;
                    axi_addr.awlen      <= 0;
                    axi_addr.arlen      <= 0;
                    axi_addr.awaddr     <= 0;
                    axi_addr.araddr     <= 0;
                    axi_addr.awsize     <= 0;
                    axi_addr.arsize     <= 0;
                    addressPhaseComplete = 1;
                end
            end
            
            @(axi_addr);
            
        endtask : address_handler
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        task automatic wrreq_data_handler(input axi_transaction transaction);
            int 			    delay;
            int                 burstSize;
            reg [255:0]         data_32_bytes;
            int                 lower_byte;
            int                 upper_byte;
            longint unsigned    address_n;
            longint unsigned    address;
            int                 N;
            int                 bytes_this_xfer;
            int                 byte_idx;
            
            burstSize       = transaction.length;
            address         = transaction.start_address;
            delay           = 0;
            N               = 1;
            bytes_this_xfer = 0;
            
            while (burstSize > 0)
            begin
                @(axi_wr)
                
                delay = (delay > 0) ? delay - 1 : 0;
                
                if (delay == 0)
                begin
                    if (N==1)
                    begin
                        lower_byte  = address - ((address/transaction.C_DATA_BUS_SIZE) * transaction.C_DATA_BUS_SIZE);
                        upper_byte  = transaction.aligned_address + (transaction.number_bytes - 1) - ((address/transaction.C_DATA_BUS_SIZE) * transaction.C_DATA_BUS_SIZE);
                    end
                    else
                    begin
                        address_n   = transaction.aligned_address + ((N - 1) * transaction.number_bytes);
                        lower_byte  = address_n-((address_n/transaction.C_DATA_BUS_SIZE)*transaction.C_DATA_BUS_SIZE);
                        upper_byte  = lower_byte + transaction.number_bytes - 1; 
                    end
                    
                    bytes_this_xfer = (upper_byte - lower_byte) + 1;
                    bytes_this_xfer = (bytes_this_xfer > burstSize)  ? burstSize : bytes_this_xfer;
                    
                    axi_wr.wvalid           <= 1'b1;
                                        
                    //data_32_bytes[127:0]    = transaction.get_slv_data(address);
                    //$display("Retrieved Data %X from address %X",data_32_bytes, address);
                    
                    //if (bytes_this_xfer > 16)
                    //    data_32_bytes[255:128]  = transaction.get_slv_data(address+16);
                    //else
                    //    data_32_bytes[255:128]  = 128'd0;
`ifdef DEBUG_MSG                    
                    $display("WRREQ_DATA_HANDLER START_ADDRESS is 0x%X",transaction.start_address);
                    $display("WRREQ_DATA_HANDLER CURRENT_ADDRESS is 0x%X",address);
                    $display("WRREQ_DATA_HANDLER LOWER_BYTE is %d",lower_byte);
                    $display("WRREQ_DATA_HANDLER UPPER_BYTE is %d",upper_byte);
`endif
                    axi_wr.wdata <= 256'd0;
                    byte_idx = 0;
                    for (int i=lower_byte; i<=upper_byte; i++)
                    begin
                        //axi_wr.wdata[i*8 +: 8]  <= data_32_bytes[(i-lower_byte)*8 +: 8];
                        axi_wr.wdata[i*8 +: 8]  <= transaction.get_slv_data(address + byte_idx);
                        byte_idx++;
                    end
                    
                    axi_wr.wstrb <= 32'd0;
                    
                    for (int i=lower_byte; i<(lower_byte+bytes_this_xfer); i++)
                    begin
                        axi_wr.wstrb[i] <= 1'b1;;
                    end
                    
                    if ((burstSize - bytes_this_xfer) == 0)
                        axi_wr.wlast    <= 1'b1;
                end
                
                if (axi_wr.wvalid & axi_wr.wready)
                begin
                    address         = address + bytes_this_xfer;
                    delay           = $urandom_range(0,10);
                    burstSize       = burstSize - bytes_this_xfer;
                    N               = N + 1;
                    
                    axi_wr.wvalid   <= 0;
                    axi_wr.wlast    <= 0;
                end
            end
            
            @(axi_wr);
        endtask : wrreq_data_handler
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        task automatic rdreq_data_handler(input axi_transaction transaction);
            int 			delay;
            bit	[63:0]  	address;
            int             byte_idx;
            bit             first;
            int             burstSize;
            reg [255:0]     data_32_bytes;
            int             lower_byte;
            int             upper_byte;
            int             address_n;
            int             N;
            int             number_bytes;
            int             aligned_address;
            int             bytes_this_xfer;
            
            burstSize       = transaction.length;
            address         = transaction.start_address;
            delay           = 0;
            N               = 1;
            bytes_this_xfer = 0;
            
            while (burstSize > 0)
            begin
                @(axi_rd)
                
                delay = (delay > 0) ? delay - 1 : 0;
                
                if (delay == 0)
                begin
                    if (N==1)
                    begin
                        lower_byte  = address - ((address/transaction.C_DATA_BUS_SIZE) * transaction.C_DATA_BUS_SIZE);
                        upper_byte  = transaction.aligned_address + (transaction.number_bytes - 1) - ((address/transaction.C_DATA_BUS_SIZE) * transaction.C_DATA_BUS_SIZE);
                    end
                    else
                    begin
                        address_n   = transaction.aligned_address + ((N - 1) * transaction.number_bytes);
                        lower_byte  = address_n-((address_n/transaction.C_DATA_BUS_SIZE)*transaction.C_DATA_BUS_SIZE);
                        upper_byte  = lower_byte + transaction.number_bytes - 1; 
                    end
                    
                    axi_rd.rready <= 1'b1;
                end
                
                if (axi_rd.rvalid & axi_rd.rready)
                begin
                    byte_idx = 0;
                    for (int i=lower_byte; i<=upper_byte; i++)
                    begin
                        transaction.set_slv_data(address + byte_idx,axi_rd.rdata[i*8 +: 8]);
                        //data_32_bytes[(i-lower_byte)*8 +: 8] = axi_rd.rdata[i*8 +: 8];
                        byte_idx++;
                    end
                    
                    bytes_this_xfer = (upper_byte - lower_byte) + 1;
                    bytes_this_xfer = (bytes_this_xfer > burstSize)  ? burstSize : bytes_this_xfer;
                    
                    axi_rd.rready <= 0;
                    //transaction.set_slv_data(address+0 , data_32_bytes[127:0]);
                    
                    //if (bytes_this_xfer > 16)
                    //    transaction.set_slv_data(address+16, data_32_bytes[255:128]);
                    
                    address     = address + bytes_this_xfer;
                    burstSize   = burstSize - bytes_this_xfer;
                    
                    delay = $urandom_range(0,10);
                    
                    N = N + 1;
                    
                    if (axi_rd.rlast)
                        break;
                end
            end
            
            @(axi_rd);
        endtask : rdreq_data_handler
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        task automatic wrreq_resp_handler(input axi_transaction transaction);
            bit responseReceived;
            
            responseReceived = 0;
            
            axi_resp.bready      <= 1'b1;
            
            while (!responseReceived)
            begin
                @(axi_resp)
                
                if (axi_resp.bvalid & axi_resp.bready)
                begin
                    axi_resp.bready     <= 0;
                    responseReceived = 1;
                end
            end
        endtask : wrreq_resp_handler
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        task automatic delay_handler(input Transaction transaction);
            bit[63:0] cycles;
            
            cycles = (transaction.Info.Address == 0) ? 64'h7FFFFFFF_FFFFFFFF : transaction.Info.Address;
            
            $display("Preparing to delay for %d cycles", cycles);
            
            repeat(cycles)
                wait_clk();
            
            $display("Finishing delay");
            
        endtask : delay_handler
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        function void create_axi_transactions(input Transaction transaction, output axi_transaction_group axi_transactions);
            int unsigned max_bytes_this_chunk;
            longint unsigned address;
            int unsigned bytes_remaining;
            axi_transaction a;
            
            address = transaction.Info.Address;
            bytes_remaining = transaction.Info.LengthBytes;
            
            while (bytes_remaining > 0)
            begin
                if (|address[11:0]) //Don't cross 4k boundaries
                    max_bytes_this_chunk = $unsigned(~address[11:0]) + 1;
                else
                    max_bytes_this_chunk = 4096;
                    
                max_bytes_this_chunk = (bytes_remaining > max_bytes_this_chunk) ? max_bytes_this_chunk : bytes_remaining;
                
                a = new(32,transaction,address,max_bytes_this_chunk);
                address += max_bytes_this_chunk;
                bytes_remaining -= max_bytes_this_chunk;
                axi_transactions.push_back(a);
                /*
                //Now split into max axi transfer 
                while (max_bytes_this_chunk > 0)
                begin
                    axi_transaction a = new(32,transaction,address,max_bytes_this_chunk);
                    address += a.length;
                    max_bytes_this_chunk -= a.length;
                    bytes_remaining -= a.length;
                    axi_transactions.push_back(a);
                end
                */
            end
        endfunction : create_axi_transactions
        //-----------------------------------------------------------------------------
        
        //-----------------------------------------------------------------------------
        task automatic do_transaction(input Transaction transaction);
            
            axi_transaction_group axi_transactions;
            
            if (transaction.Info.Type == DELAY)
            begin
                fork
                    delay_handler(transaction);
                join
            end
            else
            begin
                create_axi_transactions(transaction, axi_transactions);
                
                foreach(axi_transactions[i])
                begin
                    address_handler(axi_transactions[i]);
                    
                    if (axi_transactions[i].transaction.Info.Type == READ)
                    begin
                        rdreq_data_handler(axi_transactions[i]);
                    end
                    else if (axi_transactions[i].transaction.Info.Type == WRITE)
                    begin 
                        wrreq_data_handler(axi_transactions[i]);
                        wrreq_resp_handler(axi_transactions[i]);
                    end
                end
            end
        endtask
    endclass
    //-----------------------------------------------------------------------------
    
    concrete_axi_interface concrete_inst;
        
    function soc_it_vpi_virtual_slave_interface get_concrete_interface_inst();
        concrete_inst = new();
        return concrete_inst;
    endfunction
    
endinterface: axi_master

typedef virtual axi_master 				    vAxiMaster;
typedef virtual axi_master.AXI_Address 	    vAxiMasterAddress;
typedef virtual axi_master.AXI_Write 	    vAxiMasterWrite;
typedef virtual axi_master.AXI_Read 		vAxiMasterRead;
typedef virtual axi_master.AXI_Response 	vAxiMasterResponse;

`endif