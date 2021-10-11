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


module example_top # (
    parameter nCK_PER_CLK           = 4,   // This parameter is controllerwise
    parameter         APP_DATA_WIDTH          = 512, // This parameter is controllerwise
    parameter         APP_MASK_WIDTH          = 64,  // This parameter is controllerwise
    parameter C_AXI_ID_WIDTH                = 4,
                                              // Width of all master and slave ID signals.
                                              // # = >= 1.
    parameter C_AXI_ADDR_WIDTH              = 32,
                                              // Width of S_AXI_AWADDR, S_AXI_ARADDR, M_AXI_AWADDR and
                                              // M_AXI_ARADDR for all SI/MI slots.
                                              // # = 32.
    parameter C_AXI_DATA_WIDTH              = 512,
                                              // Width of WDATA and RDATA on SI slot.
                                              // Must be <= APP_DATA_WIDTH.
                                              // # = 32, 64, 128, 256.
    parameter C_AXI_NBURST_SUPPORT   = 0,

  `ifdef SIMULATION_MODE
    parameter SIMULATION            = "TRUE" 
  `else
    parameter SIMULATION            = "FALSE"
  `endif

  )
   (
    input                   sys_rst, //Common port for all controllers
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
    //  Includes
    //-----------------------------------------------------------------------------------------------------------------------------------------------
    `include "math.svh"
    `include "axi_defs.svh"
    `include "cnn_layer_accel_FAS.svh"

  
    //-----------------------------------------------------------------------------------------------------------------------------------------------
    //  Local Parameters
    //-----------------------------------------------------------------------------------------------------------------------------------------------  
    localparam  APP_ADDR_WIDTH = 29;
    localparam  MEM_ADDR_ORDER = "ROW_COLUMN_BANK";
    localparam DBG_WR_STS_WIDTH      = 32;
    localparam DBG_RD_STS_WIDTH      = 32;
    localparam ECC                   = "OFF";
  
    localparam C_NUM_RD_CLIENTS         = 4;
    localparam C_NUM_WR_CLIENTS         = 1;
    localparam C_NUM_TOTAL_CLIENTS      = C_NUM_RD_CLIENTS + C_NUM_WR_CLIENTS;
    
    localparam C_AXI_ID_WTH             = C_NUM_TOTAL_CLIENTS * `AXI_ID_WTH;
    localparam C_AXI_ADDR_WTH           = C_NUM_TOTAL_CLIENTS * `AXI_ADDR_WTH;
    localparam C_AXI_LEN_WTH            = C_NUM_TOTAL_CLIENTS * `AXI_LEN_WTH;
    localparam C_AXI_DATA_WTH           = C_NUM_TOTAL_CLIENTS * `AXI_DATA_WTH;
    localparam C_AXI_RESP_WTH           = C_NUM_TOTAL_CLIENTS * `AXI_RESP_WTH;
    localparam C_AXI_BR_WTH             = C_NUM_TOTAL_CLIENTS * `AXI_BR_WTH;    
    localparam C_AXI_SZ_WTH             = C_NUM_TOTAL_CLIENTS * `AXI_SZ_WTH;
    localparam C_AXI_WSTRB_WTH          = C_NUM_TOTAL_CLIENTS * `AXI_WSTRB_WTH;
    
    localparam C_INIT_ID_WTH            = C_NUM_RD_CLIENTS * `AXI_ID_WTH;
    localparam C_INIT_ADDR_WTH          = C_NUM_RD_CLIENTS * `AXI_ADDR_WTH;
    localparam C_INIT_LEN_WTH           = C_NUM_RD_CLIENTS * `AXI_LEN_WTH;  
    localparam C_INIT_DATA_WTH          = C_NUM_RD_CLIENTS * `AXI_DATA_WTH;
    

    //-----------------------------------------------------------------------------------------------------------------------------------------------
    // Local Variables
    //-----------------------------------------------------------------------------------------------------------------------------------------------
 	// AXI Write Address Ports   
    logic [C_NUM_TOTAL_CLIENTS - 1:0]    axi_awready		 ;	// Wrire address is ready
	logic [       C_AXI_ID_WTH - 1:0]  	 axi_awid		     ;	// Write ID
	logic [     C_AXI_ADDR_WTH - 1:0]  	 axi_awaddr		     ;	// Write address
	logic [      C_AXI_LEN_WTH - 1:0]  	 axi_awlen		     ;	// Write Burst Length
	logic [       C_AXI_SZ_WTH - 1:0]  	 axi_awsize		     ;	// Write Burst size
	logic [       C_AXI_BR_WTH - 1:0]  	 axi_awburst		 ;	// Write Burst type
	logic [C_NUM_TOTAL_CLIENTS - 1:0] 	 axi_awvalid		 ;	// Write address valid
	// AXI write data channel signals
	logic [C_NUM_TOTAL_CLIENTS - 1:0]	 axi_wready		     ;	// Write data ready
	logic [     C_AXI_DATA_WTH - 1:0]  	 axi_wdata		     ;	// Write data
	logic [    C_AXI_WSTRB_WTH - 1:0]  	 axi_wstrb		     ;	// Write strobes
	logic [C_NUM_TOTAL_CLIENTS - 1:0]	 axi_wlast		     ;	// Last write transaction   
	logic [C_NUM_TOTAL_CLIENTS - 1:0]	 axi_wvalid		     ;	// Write valid  
	// AXI write response channel signals
	logic [       C_AXI_ID_WTH - 1:0]  	 axi_bid			 ;	// Response ID
	logic [     C_AXI_RESP_WTH - 1:0]  	 axi_bresp		     ;	// Write response
	logic [C_NUM_TOTAL_CLIENTS - 1:0] 	 axi_bvalid		     ;	// Write reponse valid
	logic [C_NUM_TOTAL_CLIENTS - 1:0] 	 axi_bready		     ;	// Response ready
	// AXI read address channel signals
	logic [C_NUM_TOTAL_CLIENTS - 1:0]    axi_arready		 ;   // Read address ready
	logic [       C_AXI_ID_WTH - 1:0]    axi_arid		     ;	// Read ID
	logic [     C_AXI_ADDR_WTH - 1:0]    axi_araddr		     ;   // Read address
	logic [      C_AXI_LEN_WTH - 1:0]    axi_arlen		     ;   // Read Burst Length
	logic [       C_AXI_SZ_WTH - 1:0]    axi_arsize		     ;   // Read Burst size
	logic [       C_AXI_BR_WTH - 1:0]    axi_arburst		 ;   // Read Burst type
	logic [C_NUM_TOTAL_CLIENTS - 1:0]    axi_arvalid		 ;   // Read address valid 
	// AXI read data channel signals   
	logic [       C_AXI_ID_WTH - 1:0]    axi_rid			 ;   // Response ID
	logic [     C_AXI_DATA_WTH - 1:0]    axi_rdata		     ;   // Read data
	logic [     C_AXI_RESP_WTH - 1:0]    axi_rresp		     ;   // Read response
	logic [C_NUM_TOTAL_CLIENTS - 1:0]    axi_rlast		     ;   // Read last
	logic [C_NUM_TOTAL_CLIENTS - 1:0]    axi_rvalid		     ;   // Read reponse valid
	logic [C_NUM_TOTAL_CLIENTS - 1:0]    axi_rready		     ;   // Read Response ready
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
    logic [   C_NUM_RD_CLIENTS - 1:0]    init_rd_req         ;
    logic [      C_INIT_ID_WTH - 1:0]    init_rd_req_id      ;
    logic [    C_INIT_ADDR_WTH - 1:0]    init_rd_addr        ;
    logic [     C_INIT_LEN_WTH - 1:0]    init_rd_len         ;
    logic [   C_NUM_RD_CLIENTS - 1:0]    init_rd_req_ack     ;
    // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
    logic [    C_INIT_DATA_WTH - 1:0]    init_rd_data        ;
    logic [   C_NUM_RD_CLIENTS - 1:0]    init_rd_data_vld    ;
    logic [   C_NUM_RD_CLIENTS - 1:0]    init_rd_data_rdy    ;
    logic [   C_NUM_RD_CLIENTS - 1:0]    init_rd_cmpl        ;
    // BEGIN ---------------------------------------------------------------------------------------------------------------------------------------- 
    logic [   C_NUM_WR_CLIENTS - 1:0]    init_wr_req         ;
    logic [       `INIT_ID_WTH - 1:0]    init_wr_req_id      ;
    logic [     `INIT_ADDR_WTH - 1:0]    init_wr_addr        ;
    logic [      `INIT_LEN_WTH - 1:0]    init_wr_len         ;
    logic                                init_wr_req_ack     ;
    // BEGIN ---------------------------------------------------------------------------------------------------------------------------------------- 
    logic [     `INIT_DATA_WTH - 1:0]    init_wr_data        ;
    logic                                init_wr_data_vld    ;
    logic                                init_wr_data_rdy    ;
    logic                                init_wr_cmpl  	     ;





  wire [APP_ADDR_WIDTH-1:0]            c0_ddr4_app_addr;
  wire [2:0]            c0_ddr4_app_cmd;
  wire                  c0_ddr4_app_en;
  wire [APP_DATA_WIDTH-1:0]            c0_ddr4_app_wdf_data;
  wire                  c0_ddr4_app_wdf_end;
  wire [APP_MASK_WIDTH-1:0]            c0_ddr4_app_wdf_mask;
  wire                  c0_ddr4_app_wdf_wren;
  wire [APP_DATA_WIDTH-1:0]            c0_ddr4_app_rd_data;
  wire                  c0_ddr4_app_rd_data_end;
  wire                  c0_ddr4_app_rd_data_valid;
  wire                  c0_ddr4_app_rdy;
  wire                  c0_ddr4_app_wdf_rdy;
  wire                  c0_ddr4_clk;
  wire                  c0_ddr4_rst;
  wire                  dbg_clk;
  wire                  c0_wr_rd_complete;


  reg                              c0_ddr4_aresetn;
  wire                             c0_ddr4_data_msmatch_err;
  wire                             c0_ddr4_write_err;
  wire                             c0_ddr4_read_err;
  wire                             c0_ddr4_test_cmptd;
  wire                             c0_ddr4_write_cmptd;
  wire                             c0_ddr4_read_cmptd;
  wire                             c0_ddr4_cmptd_one_wr_rd;

  // Slave Interface Write Address Ports
  wire [3:0]      c0_ddr4_s_axi_awid;
  wire [31:0]    c0_ddr4_s_axi_awaddr;
  wire [7:0]                       c0_ddr4_s_axi_awlen;
  wire [2:0]                       c0_ddr4_s_axi_awsize;
  wire [1:0]                       c0_ddr4_s_axi_awburst;
  wire [3:0]                       c0_ddr4_s_axi_awcache;
  wire [2:0]                       c0_ddr4_s_axi_awprot;
  wire                             c0_ddr4_s_axi_awvalid;
  wire                             c0_ddr4_s_axi_awready;
   // Slave Interface Write Data Ports
  wire [511:0]    c0_ddr4_s_axi_wdata;
  wire [63:0]  c0_ddr4_s_axi_wstrb;
  wire                             c0_ddr4_s_axi_wlast;
  wire                             c0_ddr4_s_axi_wvalid;
  wire                             c0_ddr4_s_axi_wready;
   // Slave Interface Write Response Ports
  wire                             c0_ddr4_s_axi_bready;
  wire [3:0]      c0_ddr4_s_axi_bid;
  wire [1:0]                       c0_ddr4_s_axi_bresp;
  wire                             c0_ddr4_s_axi_bvalid;
   // Slave Interface Read Address Ports
  wire [3:0]      c0_ddr4_s_axi_arid;
  wire [31:0]    c0_ddr4_s_axi_araddr;
  wire [7:0]                       c0_ddr4_s_axi_arlen;
  wire [2:0]                       c0_ddr4_s_axi_arsize;
  wire [1:0]                       c0_ddr4_s_axi_arburst;
  wire [3:0]                       c0_ddr4_s_axi_arcache;
  wire                             c0_ddr4_s_axi_arvalid;
  wire                             c0_ddr4_s_axi_arready;
   // Slave Interface Read Data Ports
  wire                             c0_ddr4_s_axi_rready;
  wire [3:0]      c0_ddr4_s_axi_rid;
  wire [511:0]    c0_ddr4_s_axi_rdata;
  wire [1:0]                       c0_ddr4_s_axi_rresp;
  wire                             c0_ddr4_s_axi_rlast;
  wire                             c0_ddr4_s_axi_rvalid;

  wire                             c0_ddr4_cmp_data_valid;
  wire [511:0]    c0_ddr4_cmp_data;     // Compare data
  wire [511:0]    c0_ddr4_rdata_cmp;      // Read data

  wire                             c0_ddr4_dbg_wr_sts_vld;
  wire [DBG_WR_STS_WIDTH-1:0]      c0_ddr4_dbg_wr_sts;
  wire                             c0_ddr4_dbg_rd_sts_vld;
  wire [DBG_RD_STS_WIDTH-1:0]      c0_ddr4_dbg_rd_sts;
  assign c0_data_compare_error = c0_ddr4_data_msmatch_err | c0_ddr4_write_err | c0_ddr4_read_err;


  // Debug Bus
  wire [511:0]                         dbg_bus;        





wire c0_ddr4_reset_n_int;
  assign c0_ddr4_reset_n = c0_ddr4_reset_n_int;

//***************************************************************************
// The User design is instantiated below. The memory interface ports are
// connected to the top-level and the application interface ports are
// connected to the traffic generator module. This provides a reference
// for connecting the memory controller to system.
//***************************************************************************

  // user design top is one instance for all controllers
ddr4 u_ddr4
  (
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
  .dbg_bus         (dbg_bus)                                             

  );
   always @(posedge c0_ddr4_clk) begin
     c0_ddr4_aresetn <= ~c0_ddr4_rst;
   end
   
   
   axi_interconnect 
   i0_axi_interconnect (
        .INTERCONNECT_ACLK      ( c0_ddr4_clk                                        ),  
        .INTERCONNECT_ARESETN   ( c0_ddr4_rst                                        ),  
        .S00_AXI_ARESET_OUT_N   (                                                    ),  
        .S00_AXI_ACLK           ( c0_ddr4_clk                                        ),  
        .S00_AXI_AWID           ( axi_awid[(0 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),
        .S00_AXI_AWADDR         ( axi_awaddr[(0 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),
        .S00_AXI_AWLEN          ( axi_awlen[(0 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),
        .S00_AXI_AWSIZE         ( 3'b011                                             ),  
        .S00_AXI_AWBURST        ( 2'b01                                              ),  
        .S00_AXI_AWLOCK         (                                                    ),  
        .S00_AXI_AWCACHE        (                                                    ),  
        .S00_AXI_AWPROT         (                                                    ),  
        .S00_AXI_AWQOS          (                                                    ),  
        .S00_AXI_AWVALID        ( axi_awvalid[0]                                     ),
        .S00_AXI_AWREADY        ( axi_awready[0]                                     ),
        .S00_AXI_WDATA          ( axi_wdata[(0 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),
        .S00_AXI_WSTRB          ( 64'hFFFFFFFFFFFFFFFF                               ),  
        .S00_AXI_WLAST          ( axi_wlast[0]                                       ),  
        .S00_AXI_WVALID         ( axi_wvalid[0]                                      ),  
        .S00_AXI_WREADY         ( axi_wready[0]                                      ),  
        .S00_AXI_BID            ( axi_bid[(0 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S00_AXI_BRESP          ( axi_bresp[(0 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S00_AXI_BVALID         ( axi_bvalid[0]                                      ),  
        .S00_AXI_BREADY         ( axi_bready[0]                                      ),  
        .S00_AXI_ARID           ( axi_arid[(0 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),  
        .S00_AXI_ARADDR         ( axi_araddr[(0 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),  
        .S00_AXI_ARLEN          ( axi_arlen[(0 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),  
        .S00_AXI_ARSIZE         ( 3'b011                                             ),  
        .S00_AXI_ARBURST        ( 2'b01                                              ),  
        .S00_AXI_ARLOCK         (                                                    ),  
        .S00_AXI_ARCACHE        (                                                    ),  
        .S00_AXI_ARPROT         (                                                    ),  
        .S00_AXI_ARQOS          (                                                    ),  
        .S00_AXI_ARVALID        ( axi_arvalid[0]                                     ),  
        .S00_AXI_ARREADY        ( axi_arready[0]                                     ),  
        .S00_AXI_RID            ( axi_rid[(0 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S00_AXI_RDATA          ( axi_rdata[(0 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),  
        .S00_AXI_RRESP          ( axi_rresp[(0 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S00_AXI_RLAST          ( axi_rlast[0]                                       ),  
        .S00_AXI_RVALID         ( axi_rvalid[0]                                      ),  
        .S00_AXI_RREADY         ( axi_rready[0]                                      ), 
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .S01_AXI_ARESET_OUT_N   (                                                    ),  
        .S01_AXI_ACLK           ( c0_ddr4_clk                                        ),  
        .S01_AXI_AWID           ( axi_awid[(1 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),
        .S01_AXI_AWADDR         ( axi_awaddr[(1 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),
        .S01_AXI_AWLEN          ( axi_awlen[(1 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),
        .S01_AXI_AWSIZE         ( 3'b011                                             ),  
        .S01_AXI_AWBURST        ( 2'b01                                              ),  
        .S01_AXI_AWLOCK         (                                                    ),  
        .S01_AXI_AWCACHE        (                                                    ),  
        .S01_AXI_AWPROT         (                                                    ),  
        .S01_AXI_AWQOS          (                                                    ),  
        .S01_AXI_AWVALID        ( axi_awvalid[1]                                     ),
        .S01_AXI_AWREADY        ( axi_awready[1]                                     ),
        .S01_AXI_WDATA          ( axi_wdata[(1 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),
        .S01_AXI_WSTRB          ( 64'hFFFFFFFFFFFFFFFF                               ),  
        .S01_AXI_WLAST          ( axi_wlast[1]                                       ),  
        .S01_AXI_WVALID         ( axi_wvalid[1]                                      ),  
        .S01_AXI_WREADY         ( axi_wready[1]                                      ),  
        .S01_AXI_BID            ( axi_bid[(1 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S01_AXI_BRESP          ( axi_bresp[(1 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S01_AXI_BVALID         ( axi_bvalid[1]                                      ),  
        .S01_AXI_BREADY         ( axi_bready[1]                                      ),  
        .S01_AXI_ARID           ( axi_arid[(1 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),  
        .S01_AXI_ARADDR         ( axi_araddr[(1 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),  
        .S01_AXI_ARLEN          ( axi_arlen[(1 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),  
        .S01_AXI_ARSIZE         ( 3'b011                                             ),  
        .S01_AXI_ARBURST        ( 2'b01                                              ),  
        .S01_AXI_ARLOCK         (                                                    ),  
        .S01_AXI_ARCACHE        (                                                    ),  
        .S01_AXI_ARPROT         (                                                    ),  
        .S01_AXI_ARQOS          (                                                    ),  
        .S01_AXI_ARVALID        ( axi_arvalid[1]                                     ),  
        .S01_AXI_ARREADY        ( axi_arready[1]                                     ),  
        .S01_AXI_RID            ( axi_rid[(1 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S01_AXI_RDATA          ( axi_rdata[(1 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),  
        .S01_AXI_RRESP          ( axi_rresp[(1 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S01_AXI_RLAST          ( axi_rlast[1]                                       ),  
        .S01_AXI_RVALID         ( axi_rvalid[1]                                      ),  
        .S01_AXI_RREADY         ( axi_rready[1]                                      ),      
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .S02_AXI_ARESET_OUT_N   (                                                    ),  
        .S02_AXI_ACLK           ( c0_ddr4_clk                                        ),  
        .S02_AXI_AWID           ( axi_awid[(2 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),
        .S02_AXI_AWADDR         ( axi_awaddr[(2 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),
        .S02_AXI_AWLEN          ( axi_awlen[(2 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),
        .S02_AXI_AWSIZE         ( 3'b011                                             ),  
        .S02_AXI_AWBURST        ( 2'b01                                              ),  
        .S02_AXI_AWLOCK         (                                                    ),  
        .S02_AXI_AWCACHE        (                                                    ),  
        .S02_AXI_AWPROT         (                                                    ),  
        .S02_AXI_AWQOS          (                                                    ),  
        .S02_AXI_AWVALID        ( axi_awvalid[2]                                     ),
        .S02_AXI_AWREADY        ( axi_awready[2]                                     ),
        .S02_AXI_WDATA          ( axi_wdata[(2 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),
        .S02_AXI_WSTRB          ( 64'hFFFFFFFFFFFFFFFF                               ),  
        .S02_AXI_WLAST          ( axi_wlast[2]                                       ),  
        .S02_AXI_WVALID         ( axi_wvalid[2]                                      ),  
        .S02_AXI_WREADY         ( axi_wready[2]                                      ),  
        .S02_AXI_BID            ( axi_bid[(2 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S02_AXI_BRESP          ( axi_bresp[(2 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S02_AXI_BVALID         ( axi_bvalid[2]                                      ),  
        .S02_AXI_BREADY         ( axi_bready[2]                                      ),  
        .S02_AXI_ARID           ( axi_arid[(2 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),  
        .S02_AXI_ARADDR         ( axi_araddr[(2 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),  
        .S02_AXI_ARLEN          ( axi_arlen[(2 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),  
        .S02_AXI_ARSIZE         ( 3'b011                                             ),  
        .S02_AXI_ARBURST        ( 2'b01                                              ),  
        .S02_AXI_ARLOCK         (                                                    ),  
        .S02_AXI_ARCACHE        (                                                    ),  
        .S02_AXI_ARPROT         (                                                    ),  
        .S02_AXI_ARQOS          (                                                    ),  
        .S02_AXI_ARVALID        ( axi_arvalid[2]                                     ),  
        .S02_AXI_ARREADY        ( axi_arready[2]                                     ),  
        .S02_AXI_RID            ( axi_rid[(2 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S02_AXI_RDATA          ( axi_rdata[(2 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),  
        .S02_AXI_RRESP          ( axi_rresp[(2 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S02_AXI_RLAST          ( axi_rlast[2]                                       ),  
        .S02_AXI_RVALID         ( axi_rvalid[2]                                      ),  
        .S02_AXI_RREADY         ( axi_rready[2]                                      ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .S03_AXI_ARESET_OUT_N   (                                                    ),  
        .S03_AXI_ACLK           ( c0_ddr4_clk                                        ),  
        .S03_AXI_AWID           ( axi_awid[(3 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),
        .S03_AXI_AWADDR         ( axi_awaddr[(3 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),
        .S03_AXI_AWLEN          ( axi_awlen[(3 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),
        .S03_AXI_AWSIZE         ( 3'b011                                             ),  
        .S03_AXI_AWBURST        ( 2'b01                                              ),  
        .S03_AXI_AWLOCK         (                                                    ),  
        .S03_AXI_AWCACHE        (                                                    ),  
        .S03_AXI_AWPROT         (                                                    ),  
        .S03_AXI_AWQOS          (                                                    ),  
        .S03_AXI_AWVALID        ( axi_awvalid[3]                                     ),
        .S03_AXI_AWREADY        ( axi_awready[3]                                     ),
        .S03_AXI_WDATA          ( axi_wdata[(3 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),
        .S03_AXI_WSTRB          ( 64'hFFFFFFFFFFFFFFFF                               ),  
        .S03_AXI_WLAST          ( axi_wlast[3]                                       ),  
        .S03_AXI_WVALID         ( axi_wvalid[3]                                      ),  
        .S03_AXI_WREADY         ( axi_wready[3]                                      ),  
        .S03_AXI_BID            ( axi_bid[(3 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S03_AXI_BRESP          ( axi_bresp[(3 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S03_AXI_BVALID         ( axi_bvalid[3]                                      ),  
        .S03_AXI_BREADY         ( axi_bready[3]                                      ),  
        .S03_AXI_ARID           ( axi_arid[(3 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),  
        .S03_AXI_ARADDR         ( axi_araddr[(3 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),  
        .S03_AXI_ARLEN          ( axi_arlen[(3 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),  
        .S03_AXI_ARSIZE         ( 3'b011                                             ),  
        .S03_AXI_ARBURST        ( 2'b01                                              ),  
        .S03_AXI_ARLOCK         (                                                    ),  
        .S03_AXI_ARCACHE        (                                                    ),  
        .S03_AXI_ARPROT         (                                                    ),  
        .S03_AXI_ARQOS          (                                                    ),  
        .S03_AXI_ARVALID        ( axi_arvalid[3]                                     ),  
        .S03_AXI_ARREADY        ( axi_arready[3]                                     ),  
        .S03_AXI_RID            ( axi_rid[(3 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S03_AXI_RDATA          ( axi_rdata[(3 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),  
        .S03_AXI_RRESP          ( axi_rresp[(3 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S03_AXI_RLAST          ( axi_rlast[3]                                       ),  
        .S03_AXI_RVALID         ( axi_rvalid[3]                                      ),  
        .S03_AXI_RREADY         ( axi_rready[3]                                      ),    
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .S04_AXI_ARESET_OUT_N   (                                                    ),  
        .S04_AXI_ACLK           ( c0_ddr4_clk                                        ),  
        .S04_AXI_AWID           ( axi_awid[(4 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),
        .S04_AXI_AWADDR         ( axi_awaddr[(4 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),
        .S04_AXI_AWLEN          ( axi_awlen[(4 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),
        .S04_AXI_AWSIZE         ( 3'b011                                             ),  
        .S04_AXI_AWBURST        ( 2'b01                                              ),  
        .S04_AXI_AWLOCK         (                                                    ),  
        .S04_AXI_AWCACHE        (                                                    ),  
        .S04_AXI_AWPROT         (                                                    ),  
        .S04_AXI_AWQOS          (                                                    ),  
        .S04_AXI_AWVALID        ( axi_awvalid[4]                                     ),  
        .S04_AXI_AWREADY        ( axi_awready[4]                                     ),  
        .S04_AXI_WDATA          ( axi_wdata[(4 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),  
        .S04_AXI_WSTRB          ( 64'hFFFFFFFFFFFFFFFF                               ),  
        .S04_AXI_WLAST          ( axi_wlast[4]                                       ),  
        .S04_AXI_WVALID         ( axi_wvalid[4]                                      ),  
        .S04_AXI_WREADY         ( axi_wready[4]                                      ),  
        .S04_AXI_BID            ( axi_bid[(4 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),  
        .S04_AXI_BRESP          ( axi_bresp[(4 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),  
        .S04_AXI_BVALID         ( axi_bvalid[4]                                      ),  
        .S04_AXI_BREADY         ( axi_bready[4]                                      ),  
        .S04_AXI_ARID           ( axi_arid[(4 * `AXI_ID_WTH) +: `AXI_ID_WTH]         ),  
        .S04_AXI_ARADDR         ( axi_araddr[(4 * `AXI_ADDR_WTH) +: `AXI_ADDR_WTH]   ),  
        .S04_AXI_ARLEN          ( axi_arlen[(4 * `AXI_LEN_WTH) +: `AXI_LEN_WTH]      ),  
        .S04_AXI_ARSIZE         ( 3'b011                                             ),  
        .S04_AXI_ARBURST        ( 2'b01                                              ),  
        .S04_AXI_ARLOCK         (                                                    ),  
        .S04_AXI_ARCACHE        (                                                    ),  
        .S04_AXI_ARPROT         (                                                    ),  
        .S04_AXI_ARQOS          (                                                    ),  
        .S04_AXI_ARVALID        ( axi_arvalid[4]                                     ),
        .S04_AXI_ARREADY        ( axi_arready[4]                                     ),
        .S04_AXI_RID            ( axi_rid[(4 * `AXI_ID_WTH) +: `AXI_ID_WTH]          ),
        .S04_AXI_RDATA          ( axi_rdata[(4 * `AXI_DATA_WTH) +: `AXI_DATA_WTH]    ),
        .S04_AXI_RRESP          ( axi_rresp[(4 * `AXI_RESP_WTH) +: `AXI_RESP_WTH]    ),
        .S04_AXI_RLAST          ( axi_rlast[4]                                       ),
        .S04_AXI_RVALID         ( axi_rvalid[4]                                      ),
        .S04_AXI_RREADY         ( axi_rready[4]                                      ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .M00_AXI_ARESET_OUT_N   (                                                    ),
        .M00_AXI_ACLK           ( c0_ddr4_clk                                        ),        
        .M00_AXI_AWID           ( c0_ddr4_s_axi_awid                                 ),     
        .M00_AXI_AWADDR         ( c0_ddr4_s_axi_awaddr                               ),      
        .M00_AXI_AWLEN          ( c0_ddr4_s_axi_awlen                                ),      
        .M00_AXI_AWSIZE         ( c0_ddr4_s_axi_awsize                               ),      
        .M00_AXI_AWBURST        ( c0_ddr4_s_axi_awburst                              ),      
        .M00_AXI_AWLOCK         (                                                    ),      
        .M00_AXI_AWCACHE        (                                                    ),      
        .M00_AXI_AWPROT         (                                                    ),      
        .M00_AXI_AWQOS          (                                                    ),      
        .M00_AXI_AWVALID        ( c0_ddr4_s_axi_awvalid                              ),      
        .M00_AXI_AWREADY        ( c0_ddr4_s_axi_awready                              ),      
        .M00_AXI_WDATA          ( c0_ddr4_s_axi_wdata                                ),      
        .M00_AXI_WSTRB          ( c0_ddr4_s_axi_wstrb                                ),      
        .M00_AXI_WLAST          ( c0_ddr4_s_axi_wlast                                ),      
        .M00_AXI_WVALID         ( c0_ddr4_s_axi_wvalid                               ),      
        .M00_AXI_WREADY         ( c0_ddr4_s_axi_wready                               ),      
        .M00_AXI_BID            ( c0_ddr4_s_axi_bid                                  ),      
        .M00_AXI_BRESP          ( c0_ddr4_s_axi_bresp                                ),      
        .M00_AXI_BVALID         ( c0_ddr4_s_axi_bvalid                               ),      
        .M00_AXI_BREADY         ( c0_ddr4_s_axi_bready                               ),      
        .M00_AXI_ARID           ( c0_ddr4_s_axi_arid                                 ),      
        .M00_AXI_ARADDR         ( c0_ddr4_s_axi_araddr                               ),      
        .M00_AXI_ARLEN          ( c0_ddr4_s_axi_arlen                                ),      
        .M00_AXI_ARSIZE         ( c0_ddr4_s_axi_arsize                               ),      
        .M00_AXI_ARBURST        ( c0_ddr4_s_axi_arburst                              ),      
        .M00_AXI_ARLOCK         (                                                    ),
        .M00_AXI_ARCACHE        (                                                    ),
        .M00_AXI_ARPROT         (                                                    ),
        .M00_AXI_ARQOS          (                                                    ),
        .M00_AXI_ARVALID        ( c0_ddr4_s_axi_arvalid                              ),
        .M00_AXI_ARREADY        ( c0_ddr4_s_axi_arready                              ),
        .M00_AXI_RID            ( c0_ddr4_s_axi_rid                                  ),
        .M00_AXI_RDATA          ( c0_ddr4_s_axi_rdata                                ),
        .M00_AXI_RRESP          ( c0_ddr4_s_axi_rresp                                ),
        .M00_AXI_RLAST          ( c0_ddr4_s_axi_rlast                                ),
        .M00_AXI_RVALID         ( c0_ddr4_s_axi_rvalid                               ),
        .M00_AXI_RREADY         ( c0_ddr4_s_axi_rready                               ) 
    );


    cnn_layer_accel_axi_bridge #(
        .C_NUM_RD_CLIENTS( 4 ),
        .C_NUM_WR_CLIENTS( 1 )
    ) 
    i0_cnn_layer_accel_axi_bridge (
        .clk				 ( c0_ddr4_clk          ),
        .rst				 ( c0_ddr4_rst          ),
        // AXI Write Address Ports      
        .axi_awready		 ( axi_awready          ), // Indicates slave is ready to accept a 
        .axi_awid		     ( axi_awid	            ), // Write ID
        .axi_awaddr		     ( axi_awaddr	        ), // Write address
        .axi_awlen		     ( axi_awlen	        ), // Write Burst Length
        .axi_awsize		     ( axi_awsize	        ), // Write Burst size
        .axi_awburst		 ( axi_awburst          ), // Write Burst type
        .axi_awvalid		 ( axi_awvalid          ), // Write address valid
        // AXI write data channel signals              
        .axi_wready		     ( axi_wready	        ), // Write data ready
        .axi_wdata		     ( axi_wdata	        ), // Write data
        .axi_wstrb		     ( axi_wstrb	        ), // Write strobes
        .axi_wlast		     ( axi_wlast	        ), // Last write transaction   
        .axi_wvalid		     ( axi_wvalid	        ), // Write valid  
        // AXI write response channel signals
        .axi_bid			 ( axi_bid	            ), // Response ID
        .axi_bresp		     ( axi_bresp	        ), // Write response
        .axi_bvalid		     ( axi_bvalid	        ), // Write reponse valid
        .axi_bready		     ( axi_bready	        ), // Response ready
        // AXI read address channel signals
        .axi_arready		 ( axi_arready          ), // Read address ready
        .axi_arid		     ( axi_arid	            ), // Read ID
        .axi_araddr		     ( axi_araddr	        ), // Read address
        .axi_arlen		     ( axi_arlen	        ), // Read Burst Length
        .axi_arsize		     ( axi_arsize	        ), // Read Burst size
        .axi_arburst		 ( axi_arburst          ), // Read Burst type
        .axi_arvalid		 ( axi_arvalid          ), // Read address valid 
        // AXI Read Data Ports 
        .axi_rid             ( axi_rid              ),
        .axi_rdata           ( axi_rdata            ),
        .axi_rresp           ( axi_rresp            ),
        .axi_rlast           ( axi_rlast            ),
        .axi_rvalid          ( axi_rvalid           ),
        .axi_rready          ( axi_rready           ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .init_rd_req         ( init_rd_req          ),
        .init_rd_req_id      ( init_rd_req_id       ),
        .init_rd_addr        ( init_rd_addr         ),
        .init_rd_len         ( init_rd_len          ),
        .init_rd_req_ack     ( init_rd_req_ack      ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_rd_data        ( init_rd_data         ),
        .init_rd_data_vld    ( init_rd_data_vld     ),
        .init_rd_data_rdy    ( init_rd_data_rdy     ),
        .init_rd_cmpl        ( init_rd_cmpl         ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_wr_req         ( init_wr_req         ),
        .init_wr_req_id      ( init_wr_req_id      ),
        .init_wr_addr        ( init_wr_addr        ),
        .init_wr_len         ( init_wr_len         ),
        .init_wr_req_ack     ( init_wr_req_ack     ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------   
        .init_wr_data        ( init_wr_data        ),
        .init_wr_data_vld    ( init_wr_data_vld    ),
        .init_wr_data_rdy    ( init_wr_data_rdy    ),
        .init_wr_cmpl        ( init_wr_cmpl        )
    );


    SYSC_FPGA
    i0_SYSC_FPGA (
		.clk                  ( c0_ddr4_clk			),
		.rst				  ( c0_ddr4_rst			),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------
        .init_rd_req          ( init_rd_req        ),
        .init_rd_req_id       ( init_rd_req_id     ),
        .init_rd_addr         ( init_rd_addr       ),
        .init_rd_len          ( init_rd_len        ),
        .init_rd_req_ack      ( init_rd_req_ack    ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_rd_data         ( init_rd_data       ),
        .init_rd_data_vld     ( init_rd_data_vld   ),
        .init_rd_data_rdy     ( init_rd_data_rdy   ),
        .init_rd_cmpl         ( init_rd_cmpl       ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------    
        .init_wr_req          ( init_wr_req       ),
        .init_wr_req_id       ( init_wr_req_id    ),
        .init_wr_addr         ( init_wr_addr      ),
        .init_wr_len          ( init_wr_len       ),
        .init_wr_req_ack      ( init_wr_req_ack   ),
        // BEGIN ----------------------------------------------------------------------------------------------------------------------------------------   
        .init_wr_data         ( init_wr_data      ),
        .init_wr_data_vld     ( init_wr_data_vld  ),
        .init_wr_data_rdy     ( init_wr_data_rdy  ),
        .init_wr_cmpl         ( init_wr_cmpl      )
	);
endmodule
