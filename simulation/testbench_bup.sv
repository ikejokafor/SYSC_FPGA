/******************************************************************************
// (c) Copyright 2013 - 2014 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
******************************************************************************/
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor             : Xilinx
// \   \   \/     Version            : 1.0
//  \   \         Application        : MIG
//  /   /         Filename           : example_top.sv
// /___/   /\     Date Last Modified : $Date: 2014/09/03 $
// \   \  /  \    Date Created       : Thu Apr 18 2013
//  \___\/\___\
//
// Device           : UltraScale
// Design Name      : DDR4_SDRAM
// Purpose          :
//                    Top-level  module. This module serves both as an example,
//                    and allows the user to synthesize a self-contained
//                    design, which they can be used to test their hardware.
//                    In addition to the memory controller,
//                    the module instantiates:
//                      1. Synthesizable testbench - used to model
//                      user's backend logic and generate different
//                      traffic patterns
//
// Reference        :
// Revision History :
//*****************************************************************************
`ifdef MODEL_TECH
    `define SIMULATION_MODE
`elsif INCA
    `define SIMULATION_MODE
`elsif VCS
    `define SIMULATION_MODE
`elsif XILINX_SIMULATOR
    `define SIMULATION_MODE
`elsif _VCP
    `define SIMULATION_MODE
`endif


`timescale 1ps/1ps
module testbench #
(
	parameter nCK_PER_CLK           = 4,   // This parameter is controllerwise
	parameter APP_DATA_WIDTH        = 512, // This parameter is controllerwise
	parameter APP_MASK_WIDTH        = 64,  // This parameter is controllerwise
	parameter C_AXI_ID_WIDTH        = 32,
											  // Width of all master and slave ID signals.
											  // # = >= 1.
	parameter C_AXI_ADDR_WIDTH      = 33,
											  // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
											  // M_AXI_ARADDR for all SI/MI slots.
											  // # = 32.
	parameter C_AXI_DATA_WIDTH      = 512,
											  // Width of WDATA and RDATA on SI slot.
											  // Must be <= APP_DATA_WIDTH.
											  // # = 32, 64, 128, 256.
	parameter C_AXI_NBURST_SUPPORT   = 1,

	`ifdef SIMULATION_MODE
	parameter SIMULATION            = "TRUE" 
	`else
	parameter SIMULATION            = "FALSE"
	`endif
)
   (
	input                 sys_rst, //Common port for all controllers


	output                  c0_init_calib_complete,
	output                  c0_data_compare_error,
	input                   c0_sys_clk_p,
	input                   c0_sys_clk_n,
	output                  c0_ddr4_act_n,
	output [16:0]           c0_ddr4_adr,
	output [1:0]            c0_ddr4_ba,
	output [1:0]            c0_ddr4_bg,
	output [0:0]            c0_ddr4_cke,
	output [0:0]            c0_ddr4_odt,
	output [0:0]            c0_ddr4_cs_n,
	output [0:0]            c0_ddr4_ck_t,
	output [0:0]            c0_ddr4_ck_c,
	output                  c0_ddr4_reset_n,
	inout  [8:0]            c0_ddr4_dm_dbi_n,
	inout  [71:0]           c0_ddr4_dq,
	inout  [8:0]            c0_ddr4_dqs_t,
	inout  [8:0]            c0_ddr4_dqs_c
);

    //-----------------------------------------------------------------------------------------------------------------------------------------------
    //  Local Parameters
    //-----------------------------------------------------------------------------------------------------------------------------------------------
	// DDR4 Local Params ----------------------------------------------------------------------------------------------------------------------------
    localparam APP_ADDR_WIDTH 	  = 30;
	localparam MEM_ADDR_ORDER 	  = "ROW_COLUMN_BANK";
	localparam DBG_WR_STS_WIDTH   = 32;
	localparam DBG_RD_STS_WIDTH   = 32;
	localparam ECC                = "ON";
    // SYSC FPGA Params -----------------------------------------------------------------------------------------------------------------------------   
    localparam C_INIT_REQ_ID_WTH                    = `MAX_FAS_RD_ID * `MAX_FAS_RD_ID;
    localparam C_INIT_MEM_RD_ADDR_WTH               = `MAX_FAS_RD_ID * `INIT_RD_ADDR_WIDTH;
    localparam C_INIT_MEM_RD_LEN_WTH                = `MAX_FAS_RD_ID * `INIT_RD_LEN_WIDTH;  
    

    //-----------------------------------------------------------------------------------------------------------------------------------------------
    //  Local Variables
    //-----------------------------------------------------------------------------------------------------------------------------------------------
	wire [APP_ADDR_WIDTH-1:0]     c0_ddr4_app_addr;
	wire [2:0]            		  c0_ddr4_app_cmd;
	wire                  		  c0_ddr4_app_en;
	wire [APP_DATA_WIDTH-1:0]     c0_ddr4_app_wdf_data;
	wire                  		  c0_ddr4_app_wdf_end;
	wire [APP_MASK_WIDTH-1:0]     c0_ddr4_app_wdf_mask;
	wire                  		  c0_ddr4_app_wdf_wren;
	wire [APP_DATA_WIDTH-1:0]     c0_ddr4_app_rd_data;
	wire                  		  c0_ddr4_app_rd_data_end;
	wire                  		  c0_ddr4_app_rd_data_valid;
	wire                  		  c0_ddr4_app_rdy;
	wire                  		  c0_ddr4_app_wdf_rdy;
	wire                  		  c0_ddr4_clk;
	wire                  		  c0_ddr4_rst;
	wire                  		  dbg_clk;
	wire                  		  c0_wr_rd_complete;


	reg                           c0_ddr4_aresetn;
	wire                          c0_ddr4_data_msmatch_err;
	wire                          c0_ddr4_write_err;
	wire                          c0_ddr4_read_err;
	wire                          c0_ddr4_test_cmptd;
	wire                          c0_ddr4_write_cmptd;
	wire                          c0_ddr4_read_cmptd;
	wire                          c0_ddr4_cmptd_one_wr_rd;

	// Slave Interface Write Address Ports
	wire [31:0]      			  c0_ddr4_s_axi_awid;
	wire [32:0]    				  c0_ddr4_s_axi_awaddr;
	wire [7:0]                    c0_ddr4_s_axi_awlen;
	wire [2:0]                    c0_ddr4_s_axi_awsize;
	wire [1:0]                    c0_ddr4_s_axi_awburst;
	wire [3:0]                    c0_ddr4_s_axi_awcache;
	wire [2:0]                    c0_ddr4_s_axi_awprot;
	wire                          c0_ddr4_s_axi_awvalid;
	wire                          c0_ddr4_s_axi_awready;
	// Slave Interface Write Data Ports
	wire [511:0]    			  c0_ddr4_s_axi_wdata;
	wire [63:0]  				  c0_ddr4_s_axi_wstrb;
	wire                          c0_ddr4_s_axi_wlast;
	wire                          c0_ddr4_s_axi_wvalid;
	wire                          c0_ddr4_s_axi_wready;
	// Slave Interface Write Response Ports
	wire                          c0_ddr4_s_axi_bready;
	wire [31:0]      			  c0_ddr4_s_axi_bid;
	wire [1:0]                    c0_ddr4_s_axi_bresp;
	wire                          c0_ddr4_s_axi_bvalid;
	// Slave Interface Read Address Ports
	wire [31:0]      			  c0_ddr4_s_axi_arid;
	wire [32:0]    				  c0_ddr4_s_axi_araddr;
	wire [7:0]                    c0_ddr4_s_axi_arlen;
	wire [2:0]                    c0_ddr4_s_axi_arsize;
	wire [1:0]                    c0_ddr4_s_axi_arburst;
	wire [3:0]                    c0_ddr4_s_axi_arcache;
	wire                          c0_ddr4_s_axi_arvalid;
	wire                          c0_ddr4_s_axi_arready;
	// Slave Interface Read Data Ports
	wire                          c0_ddr4_s_axi_rready;
	wire [31:0]      			  c0_ddr4_s_axi_rid;
	wire [511:0]    			  c0_ddr4_s_axi_rdata;
	wire [1:0]                    c0_ddr4_s_axi_rresp;
	wire                          c0_ddr4_s_axi_rlast;
	wire                          c0_ddr4_s_axi_rvalid;

	wire                          c0_ddr4_cmp_data_valid;
	wire [511:0]    			  c0_ddr4_cmp_data;     // Compare data
	wire [511:0]    			  c0_ddr4_rdata_cmp;      // Read data

	wire                          c0_ddr4_dbg_wr_sts_vld;
	wire [DBG_WR_STS_WIDTH-1:0]   c0_ddr4_dbg_wr_sts;
	wire                          c0_ddr4_dbg_rd_sts_vld;
	wire [DBG_RD_STS_WIDTH-1:0]   c0_ddr4_dbg_rd_sts;
	assign c0_data_compare_error = c0_ddr4_data_msmatch_err | c0_ddr4_write_err | c0_ddr4_read_err;

	// Debug Bus
	wire [511:0]                         dbg_bus;        


    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    logic [            `MAX_FAS_RD_ID - 1:0]   init_read_req              							    ;
    logic [         C_INIT_REQ_ID_WTH - 1:0]   init_read_req_id           							    ;
    logic [    C_INIT_MEM_RD_ADDR_WTH - 1:0]   init_read_addr             							    ;
    logic [     C_INIT_MEM_RD_LEN_WTH - 1:0]   init_read_len              							    ;
    logic [            `MAX_FAS_RD_ID - 1:0]   init_read_req_ack          							    ;
    logic [            `MAX_FAS_RD_ID - 1:0]   init_read_in_prog          							    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
    logic [       `INIT_RD_DATA_WIDTH - 1:0]   init_read_data             							    ;
    logic [            `MAX_FAS_RD_ID - 1:0]   init_read_data_vld         							    ;
    logic [            `MAX_FAS_RD_ID - 1:0]   init_read_data_rdy         							    ;
    logic [            `MAX_FAS_RD_ID - 1:0]   init_read_cmpl             							    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
    logic                                      init_write_req             							    ;
    logic                                      init_write_req_id          							    ;
    logic [       `INIT_WR_ADDR_WIDTH - 1:0]   init_write_addr            							    ;
    logic [        `INIT_WR_LEN_WIDTH - 1:0]   init_write_len             							    ;
    logic                                      init_write_req_ack         							    ;
    logic                                      init_write_in_prog         							    ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------   
    logic [       `INIT_RD_DATA_WIDTH - 1:0]   init_write_data            							    ;
    logic                                      init_write_data_vld        							    ;
    logic                                      init_write_data_rdy        							    ;
    logic                                      init_write_cmpl            							    ;




	wire c0_ddr4_reset_n_int;
	assign c0_ddr4_reset_n = c0_ddr4_reset_n_int;

//***************************************************************************
// The User design is instantiated below. The memory interface ports are
// connected to the top-level and the application interface ports are
// connected to the traffic generator module. This provides a reference
// for connecting the memory controller to system.
//***************************************************************************

  // user design top is one instance for all controllers
	ddr4_0 
	u_ddr4_0 (
		.sys_rst           (sys_rst),

		.c0_sys_clk_p                   (c0_sys_clk_p),
		.c0_sys_clk_n                   (c0_sys_clk_n),
		.c0_init_calib_complete (c0_init_calib_complete),
		.c0_ddr4_act_n          (c0_ddr4_act_n),
		.c0_ddr4_adr            (c0_ddr4_adr),
		.c0_ddr4_ba             (c0_ddr4_ba),
		.c0_ddr4_bg             (c0_ddr4_bg),
		.c0_ddr4_cke            (c0_ddr4_cke),
		.c0_ddr4_odt            (c0_ddr4_odt),
		.c0_ddr4_cs_n           (c0_ddr4_cs_n),
		.c0_ddr4_ck_t           (c0_ddr4_ck_t),
		.c0_ddr4_ck_c           (c0_ddr4_ck_c),
		.c0_ddr4_reset_n        (c0_ddr4_reset_n_int),

		.c0_ddr4_dm_dbi_n       (c0_ddr4_dm_dbi_n),
		.c0_ddr4_dq             (c0_ddr4_dq),
		.c0_ddr4_dqs_c          (c0_ddr4_dqs_c),
		.c0_ddr4_dqs_t          (c0_ddr4_dqs_t),

		.c0_ddr4_ui_clk                (c0_ddr4_clk),
		.c0_ddr4_ui_clk_sync_rst       (c0_ddr4_rst),
		.dbg_clk                                    (dbg_clk),
		// AXI CTRL port
		.c0_ddr4_s_axi_ctrl_awvalid       (1'b0),
		.c0_ddr4_s_axi_ctrl_awready       (),
		.c0_ddr4_s_axi_ctrl_awaddr        (32'b0),
		// Slave Interface Write Data Ports
		.c0_ddr4_s_axi_ctrl_wvalid        (1'b0),
		.c0_ddr4_s_axi_ctrl_wready        (),
		.c0_ddr4_s_axi_ctrl_wdata         (32'b0),
		// Slave Interface Write Response Ports
		.c0_ddr4_s_axi_ctrl_bvalid        (),
		.c0_ddr4_s_axi_ctrl_bready        (1'b1),
		.c0_ddr4_s_axi_ctrl_bresp         (),
		// Slave Interface Read Address Ports
		.c0_ddr4_s_axi_ctrl_arvalid       (1'b0),
		.c0_ddr4_s_axi_ctrl_arready       (),
		.c0_ddr4_s_axi_ctrl_araddr        (32'b0),
		// Slave Interface Read Data Ports
		.c0_ddr4_s_axi_ctrl_rvalid        (),
		.c0_ddr4_s_axi_ctrl_rready        (1'b1),
		.c0_ddr4_s_axi_ctrl_rdata         (),
		.c0_ddr4_s_axi_ctrl_rresp         (),
		// Interrupt output
		.c0_ddr4_interrupt                (),
		// Slave Interface Write Address Ports
		.c0_ddr4_aresetn                     (c0_ddr4_aresetn),
		.c0_ddr4_s_axi_awid                  (c0_ddr4_s_axi_awid),
		.c0_ddr4_s_axi_awaddr                (c0_ddr4_s_axi_awaddr),
		.c0_ddr4_s_axi_awlen                 (c0_ddr4_s_axi_awlen),
		.c0_ddr4_s_axi_awsize                (c0_ddr4_s_axi_awsize),
		.c0_ddr4_s_axi_awburst               (c0_ddr4_s_axi_awburst),
		.c0_ddr4_s_axi_awlock                (1'b0),
		.c0_ddr4_s_axi_awcache               (c0_ddr4_s_axi_awcache),
		.c0_ddr4_s_axi_awprot                (c0_ddr4_s_axi_awprot),
		.c0_ddr4_s_axi_awqos                 (4'b0),
		.c0_ddr4_s_axi_awvalid               (c0_ddr4_s_axi_awvalid),
		.c0_ddr4_s_axi_awready               (c0_ddr4_s_axi_awready),
		// Slave Interface Write Data Ports
		.c0_ddr4_s_axi_wdata                 (c0_ddr4_s_axi_wdata),
		.c0_ddr4_s_axi_wstrb                 (c0_ddr4_s_axi_wstrb),
		.c0_ddr4_s_axi_wlast                 (c0_ddr4_s_axi_wlast),
		.c0_ddr4_s_axi_wvalid                (c0_ddr4_s_axi_wvalid),
		.c0_ddr4_s_axi_wready                (c0_ddr4_s_axi_wready),
		// Slave Interface Write Response Ports
		.c0_ddr4_s_axi_bid                   (c0_ddr4_s_axi_bid),
		.c0_ddr4_s_axi_bresp                 (c0_ddr4_s_axi_bresp),
		.c0_ddr4_s_axi_bvalid                (c0_ddr4_s_axi_bvalid),
		.c0_ddr4_s_axi_bready                (c0_ddr4_s_axi_bready),
		// Slave Interface Read Address Ports
		.c0_ddr4_s_axi_arid                  (c0_ddr4_s_axi_arid),
		.c0_ddr4_s_axi_araddr                (c0_ddr4_s_axi_araddr),
		.c0_ddr4_s_axi_arlen                 (c0_ddr4_s_axi_arlen),
		.c0_ddr4_s_axi_arsize                (c0_ddr4_s_axi_arsize),
		.c0_ddr4_s_axi_arburst               (c0_ddr4_s_axi_arburst),
		.c0_ddr4_s_axi_arlock                (1'b0),
		.c0_ddr4_s_axi_arcache               (c0_ddr4_s_axi_arcache),
		.c0_ddr4_s_axi_arprot                (3'b0),
		.c0_ddr4_s_axi_arqos                 (4'b0),
		.c0_ddr4_s_axi_arvalid               (c0_ddr4_s_axi_arvalid),
		.c0_ddr4_s_axi_arready               (c0_ddr4_s_axi_arready),
		// Slave Interface Read Data Ports
		.c0_ddr4_s_axi_rid                   (c0_ddr4_s_axi_rid),
		.c0_ddr4_s_axi_rdata                 (c0_ddr4_s_axi_rdata),
		.c0_ddr4_s_axi_rresp                 (c0_ddr4_s_axi_rresp),
		.c0_ddr4_s_axi_rlast                 (c0_ddr4_s_axi_rlast),
		.c0_ddr4_s_axi_rvalid                (c0_ddr4_s_axi_rvalid),
		.c0_ddr4_s_axi_rready                (c0_ddr4_s_axi_rready),

		// Debug Port
		.dbg_bus         					 (dbg_bus)
	);
	always @(posedge c0_ddr4_clk) begin
		c0_ddr4_aresetn <= ~c0_ddr4_rst;
	end
    
    
    cnn_layer_accel_axi_bridge (
        .C_NUM_RD_CLIENTS( 4 ),
        .C_NUM_WR_CLIENTS( 1 )
    ) 
    i0_cnn_layer_accel_axi_bridge (
        .clk				     ( c0_ddr4_clk ),
        .rst				     ( c0_ddr4_rst ),
        // AXI Write Address Ports
        .axi_awready		     ( c0_ddr4_s_axi_awready ),	// Indicates slave is ready to accept a 
        .axi_awid		         ( c0_ddr4_s_axi_awid	 ),	// Write ID
        .axi_awaddr		         ( c0_ddr4_s_axi_awaddr	 ),	// Write address
        .axi_awlen		         ( c0_ddr4_s_axi_awlen	 ),	// Write Burst Length
        .axi_awsize		         ( c0_ddr4_s_axi_awsize	 ),	// Write Burst size
        .axi_awburst		     ( c0_ddr4_s_axi_awburst ),	// Write Burst type
        .axi_awcache		     (                       ),	// Write Cache type
        .axi_awvalid		     ( c0_ddr4_s_axi_awvalid ),	// Write address valid
        // AXI write data channel signals
        .axi_wready		         ( c0_ddr4_s_axi_wready	 ),	// Write data ready
        .axi_wdata		         ( c0_ddr4_s_axi_wdata	 ),	// Write data
        .axi_wstrb		         ( c0_ddr4_s_axi_wstrb	 ),	// Write strobes
        .axi_wlast		         ( c0_ddr4_s_axi_wlast	 ),	// Last write transaction   
        .axi_wvalid		         ( c0_ddr4_s_axi_wvalid	 ),	// Write valid  
        // AXI write response channel signals
        .axi_bid			     ( c0_ddr4_s_axi_bid	 ),	// Response ID
        .axi_bresp		         ( c0_ddr4_s_axi_bresp	 ),	// Write response
        .axi_bvalid		         ( c0_ddr4_s_axi_bvalid	 ),	// Write reponse valid
        .axi_bready		         ( c0_ddr4_s_axi_bready	 ),	// Response ready
        // AXI read address channel signals
        .axi_arready		     ( c0_ddr4_s_axi_arready ),   // Read address ready
        .axi_arid		         ( c0_ddr4_s_axi_arid	 ),	// Read ID
        .axi_araddr		         ( c0_ddr4_s_axi_araddr	 ),   // Read address
        .axi_arlen		         ( c0_ddr4_s_axi_arlen	 ),   // Read Burst Length
        .axi_arsize		         ( c0_ddr4_s_axi_arsize	 ),   // Read Burst size
        .axi_arburst		     ( c0_ddr4_s_axi_arburst ),   // Read Burst type
        .axi_arcache		     (                       ),   // Read Cache type
        .axi_arvalid		     ( c0_ddr4_s_axi_arvalid ),   // Read address valid 
        // AXI read data channel signals   
        .axi_rid			     ( c0_ddr4_s_axi_rid	 ),   // Response ID
        .axi_rresp		         ( c0_ddr4_s_axi_rresp	 ),   // Read response
        .axi_rvalid		         ( c0_ddr4_s_axi_rvalid	 ),   // Read reponse valid
        .axi_rdata		         ( c0_ddr4_s_axi_rdata	 ),   // Read data
        .axi_rlast		         ( c0_ddr4_s_axi_rlast	 ),   // Read last
        .axi_rready		         ( c0_ddr4_s_axi_rready	 ),   // Read Response ready 
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .init_read_req           ( init_read_req        ),
        .init_read_req_id        ( init_read_req_id     ),
        .init_read_addr          ( init_read_addr       ),
        .init_read_len           ( init_read_len        ),
        .init_read_req_ack       ( init_read_req_ack    ),
        .init_read_in_prog       ( init_read_in_prog    ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_read_data          ( init_read_data       ),
        .init_read_data_vld      ( init_read_data_vld   ),
        .init_read_data_rdy      ( init_read_data_rdy   ),
        .init_read_cmpl          ( init_read_cmpl       ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_write_req          ( init_write_req       ),
        .init_write_req_id       ( init_write_req_id    ),
        .init_write_addr         ( init_write_addr      ),
        .init_write_len          ( init_write_len       ),
        .init_write_req_ack      ( init_write_req_ack   ),
        .init_write_in_prog      ( init_write_in_prog   ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------   
        .init_write_data         ( init_write_data      ),
        .init_write_data_vld     ( init_write_data_vld  ),
        .init_write_data_rdy     ( init_write_data_rdy  ),
        .init_write_cmpl         ( init_write_cmpl      )
    );


    SYSC_FPGA
    i0_SYSC_FPGA (
		.clk                     ( c0_ddr4_clk			),
		.rst					 ( c0_ddr4_rst			),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .init_read_req           ( init_read_req        ),
        .init_read_req_id        ( init_read_req_id     ),
        .init_read_addr          ( init_read_addr       ),
        .init_read_len           ( init_read_len        ),
        .init_read_req_ack       ( init_read_req_ack    ),
        .init_read_in_prog       ( init_read_in_prog    ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_read_data          ( init_read_data       ),
        .init_read_data_vld      ( init_read_data_vld   ),
        .init_read_data_rdy      ( init_read_data_rdy   ),
        .init_read_cmpl          ( init_read_cmpl       ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_write_req          ( init_write_req       ),
        .init_write_req_id       ( init_write_req_id    ),
        .init_write_addr         ( init_write_addr      ),
        .init_write_len          ( init_write_len       ),
        .init_write_req_ack      ( init_write_req_ack   ),
        .init_write_in_prog      ( init_write_in_prog   ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------   
        .init_write_data         ( init_write_data      ),
        .init_write_data_vld     ( init_write_data_vld  ),
        .init_write_data_rdy     ( init_write_data_rdy  ),
        .init_write_cmpl         ( init_write_cmpl      )
	);

endmodule

