`ifndef __SOC_IT_VPI_TRANSACTION__
`define __SOC_IT_VPI_TRANSACTION__
						
/////////////////////////////////////////////////////////////////////////////
// Packet Type
/////////////////////////////////////////////////////////////////////////////
typedef enum bit[7:0] 	{
						NOP             = 0,
                        READ			= 1, 
                        READ_RSP        = 2,
						WRITE			= 3,
                        WRITE_RSP       = 4,
                        MSG_RECV        = 5,
                        MSG_SEND        = 6,
                        DELAY           = 7,
                        DELAY_RSP       = 8
					} TransactionType;

/////////////////////////////////////////////////////////////////////////////
// Transaction Info Class
/////////////////////////////////////////////////////////////////////////////
class TransactionInfo;
	rand 	bit [35:0] 		LengthBytes;
	rand	TransactionType	Type;
			bit	[15:0]		TransactionID;
	rand 	bit	[63:0]		Address;
	
	extern function new(); 
    extern function void initialize();
	extern virtual function bit equals(TransactionInfo other);
	extern virtual function TransactionInfo copy();
endclass : TransactionInfo

//-----------------------------------------------------------------------------
function TransactionInfo::new(); 
endfunction : new
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void TransactionInfo::initialize(); 
    LengthBytes = 0;
    Type = NOP;
    TransactionID = 0;
    Address = 64'd0;
endfunction : initialize
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function bit TransactionInfo::equals(TransactionInfo other);		
	if ((this.LengthBytes == other.LengthBytes) &&
		(this.Type == other.Type) &&
		(this.TransactionID == other.TransactionID) &&
		(this.Address == other.Address))
			return 1;
	
	return 0;
endfunction : equals
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function TransactionInfo TransactionInfo::copy(); 
	copy = new();
	copy.LengthBytes = this.LengthBytes;
	copy.Type = this.Type;
	copy.TransactionID = this.TransactionID;
	copy.Address = this.Address;
endfunction : copy
//-----------------------------------------------------------------------------

typedef bit[7:0] data_words[$];

/////////////////////////////////////////////////////////////////////////////
// Transaction Data Class
/////////////////////////////////////////////////////////////////////////////
class TransactionData;
	bit	[7:0] source_data[bit[63:0]];
	
	extern function new(); 
	extern function void initialize();
	//extern function void setData(bit [63:0] baseAddress, bit [127:0] data);
    extern function void setData(bit [63:0] baseAddress, bit [7:0] data);
	extern function bit equals(TransactionData other);
	extern virtual function TransactionData copy();
	extern function bit[7:0] getData(bit [63:0] baseAddress);
endclass : TransactionData

//-----------------------------------------------------------------------------
function TransactionData::new(); 
endfunction : new
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function bit[7:0] TransactionData::getData(bit [63:0] baseAddress);
    getData = source_data[baseAddress];
endfunction : getData
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void TransactionData::initialize(); 
	source_data.delete();
endfunction : initialize
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
//function void TransactionData::setData(bit [63:0] baseAddress, bit [127:0] data); 
//	for (int i=0; i<16; i++)
//        source_data[baseAddress + i] = data[i*8 +: 8];
//endfunction : setData
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void TransactionData::setData(bit [63:0] baseAddress, bit [7:0] data); 
	source_data[baseAddress] = data;
endfunction : setData
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function bit TransactionData::equals(TransactionData other);		
endfunction : equals
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function TransactionData TransactionData::copy(); 
	copy = new();
	copy.source_data = this.source_data;
		
endfunction : copy
//-----------------------------------------------------------------------------


/////////////////////////////////////////////////////////////////////////////
// Base Packet
/////////////////////////////////////////////////////////////////////////////

class Transaction;
	TransactionInfo		Info;
	TransactionData		Data;
		
	extern function new(); 
	extern virtual function bit equals(Transaction other);
	extern virtual function Transaction copy(input Transaction to=null);
	extern function void copy_data(input Transaction copy);
	extern function bit[7:0] get_slv_data(bit[63:0] address);
	//extern function void set_slv_data(bit[63:0] address, bit[127:0] data);
    extern function void set_slv_data(bit[63:0] address, bit[7:0] data);
    extern function integer from_bits(ref bit [127:0] data[4096]);
    extern function void to_bits(ref bit[127:0] response[4096]);
    extern function void initialize();
endclass : Transaction

//-----------------------------------------------------------------------------
function Transaction::new(); 
	Info			= new();
	Data			= new();
endfunction : new
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void Transaction::initialize();
    Info.initialize();
    Data.initialize();
endfunction : initialize
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function integer Transaction::from_bits(ref bit [127:0] data[4096]);
    
    integer offset = 0;
    integer word_idx = 0 ;
    integer byte_idx = 0;
    
    $cast(Info.Type,data[0][7:0]);
    
    while (Info.Type != NOP)
    begin
    
        Info.LengthBytes = data[offset][63:32];
        Info.TransactionID = data[offset][31:16];
        Info.Address = data[offset][127:64];
        
        for (int i=0; i<Info.LengthBytes; i++)
        begin
            word_idx = i / 16;
            byte_idx = i % 16;
            set_slv_data(Info.Address + i,data[offset + word_idx + 1][byte_idx*8 +: 8]);
        end
            
        offset = offset + $ceil(real'(Info.LengthBytes)/16.0) + 1;
        
        $cast(Info.Type,data[offset][7:0]);
    end
    
    return offset;
endfunction
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------    
function void Transaction::to_bits(ref bit[127:0] response[4096]);
    integer word_idx = 0 ;
    integer byte_idx = 0;
    
    response[0][7:0] = NOP;
    
    if (Info.Type == WRITE)
    begin
        
        response[0][7:0]    =  WRITE_RSP;
        response[0][15:8]   = 0;
        response[0][31:16]  = Info.TransactionID;
        response[0][63:32]  = 0;
    end
    else if (Info.Type == READ)
    begin
        response[0][7:0]    = READ_RSP;
        response[0][15:8]   = 0;
        response[0][31:16]  = Info.TransactionID;
        response[0][63:32]  = Info.LengthBytes;
`ifdef DEBUG_MSG                            
        $display("TO_BITS READ ADDRESS is 0x%X",Info.Address);
`endif
        for (int i=0; i<Info.LengthBytes; i++)
        begin
            word_idx = i / 16;
            byte_idx = i % 16;
            response[word_idx + 1][byte_idx*8 +: 8] = get_slv_data(Info.Address + i);
        end
        
        //dw = Data.getData();
        
        //for (int i=0; i<dw.size(); i++)
        //begin
        //    response[i+1] = dw[i];
        //end
    end
    else if (Info.Type == DELAY)
    begin
        response[0][7:0]    = DELAY_RSP;
        response[0][15:8]   = 0;
        response[0][31:16]  = Info.TransactionID;
        response[0][63:32]  = 0;
    end
endfunction
//-----------------------------------------------------------------------------
    
//-----------------------------------------------------------------------------
function bit Transaction::equals(Transaction other);		
	if (this.Info.equals(other.Info))
	begin
        if (this.Data.equals(other.Data))
			return 1;
`ifdef DEBUG_MSG                    
        else
			$display("Data doesn't match");
`endif    
	end
	
	return 0;
endfunction : equals
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function Transaction Transaction::copy(input Transaction to=null);
	if (to == null) copy = new();
	else			$cast(copy,to);
	copy_data(copy);
	return copy;
endfunction : copy
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void Transaction::copy_data(input Transaction copy);
	copy.Info 	= this.Info.copy();
	copy.Data 	= this.Data.copy();
endfunction : copy_data
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function bit[7:0] Transaction::get_slv_data(bit[63:0] address);
	get_slv_data = Data.getData(address);
endfunction : get_slv_data
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
//function void Transaction::set_slv_data(bit[63:0] address, bit[127:0] data);
//	Data.setData(address,data);
//	//Info.LengthBytes = Data.source_data.size * 16;
//endfunction : set_slv_data
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
function void Transaction::set_slv_data(bit[63:0] address, bit[7:0] data);
	Data.setData(address,data);
	//Info.LengthBytes = Data.source_data.size * 16;
endfunction : set_slv_data
//-----------------------------------------------------------------------------

`endif