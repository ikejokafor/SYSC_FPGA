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
  logic [3:0]      c0_ddr4_s_axi_awid;
  logic [31:0]    c0_ddr4_s_axi_awaddr;
  logic [7:0]                       c0_ddr4_s_axi_awlen;
  logic [2:0]                       c0_ddr4_s_axi_awsize;
  logic [1:0]                       c0_ddr4_s_axi_awburst;
  logic [3:0]                       c0_ddr4_s_axi_awcache;
  logic [2:0]                       c0_ddr4_s_axi_awprot;
  logic                             c0_ddr4_s_axi_awvalid;
  logic                             c0_ddr4_s_axi_awready;
   // Slave Interface Write Data Ports
  logic [511:0]    c0_ddr4_s_axi_wdata;
  logic [63:0]  c0_ddr4_s_axi_wstrb;
  logic                             c0_ddr4_s_axi_wlast;
  logic                             c0_ddr4_s_axi_wvalid;
  logic                             c0_ddr4_s_axi_wready;
   // Slave Interface Write Response Ports
  logic                             c0_ddr4_s_axi_bready;
  logic [3:0]      c0_ddr4_s_axi_bid;
  logic [1:0]                       c0_ddr4_s_axi_bresp;
  logic                             c0_ddr4_s_axi_bvalid;
   // Slave Interface Read Address Ports
  logic [3:0]      c0_ddr4_s_axi_arid;
  logic [31:0]    c0_ddr4_s_axi_araddr;
  logic [7:0]                       c0_ddr4_s_axi_arlen;
  logic [2:0]                       c0_ddr4_s_axi_arsize;
  logic [1:0]                       c0_ddr4_s_axi_arburst;
  logic [3:0]                       c0_ddr4_s_axi_arcache;
  logic                             c0_ddr4_s_axi_arvalid;
  logic                             c0_ddr4_s_axi_arready;
   // Slave Interface Read Data Ports
  logic                             c0_ddr4_s_axi_rready;
  logic [3:0]      c0_ddr4_s_axi_rid;
  logic [511:0]    c0_ddr4_s_axi_rdata;
  logic [1:0]                       c0_ddr4_s_axi_rresp;
  logic                             c0_ddr4_s_axi_rlast;
  logic                             c0_ddr4_s_axi_rvalid;

  logic                             c0_ddr4_cmp_data_valid;
  logic [511:0]    c0_ddr4_cmp_data;     // Compare data
  logic [511:0]    c0_ddr4_rdata_cmp;      // Read data

  logic                             c0_ddr4_dbg_wr_sts_vld;
  logic [DBG_WR_STS_WIDTH-1:0]      c0_ddr4_dbg_wr_sts;
  logic                             c0_ddr4_dbg_rd_sts_vld;
  logic [DBG_RD_STS_WIDTH-1:0]      c0_ddr4_dbg_rd_sts;
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
   
    
        // assign c0_ddr4_s_axi_arid = 0;
        // assign c0_ddr4_s_axi_araddr = 0;
        // assign c0_ddr4_s_axi_arlen = 0;
        // assign c0_ddr4_s_axi_arvalid = 0;
        // assign c0_ddr4_s_axi_arburst = 0;
        // assign c0_ddr4_s_axi_arsize = 0;
        // assign c0_ddr4_s_axi_rready = 0;
    
    initial begin
        $timeformat(-12, 2, " ps", 20);
        c0_ddr4_s_axi_arid = 0;
        c0_ddr4_s_axi_araddr = 0;
        c0_ddr4_s_axi_arlen = 0;
        c0_ddr4_s_axi_arvalid = 0;
        c0_ddr4_s_axi_arburst = 0;
        c0_ddr4_s_axi_arsize = 0;
        c0_ddr4_s_axi_rready = 0;
        c0_ddr4_s_axi_awvalid = 0;
        c0_ddr4_s_axi_awaddr = 0;
        c0_ddr4_s_axi_awid = 0;
        c0_ddr4_s_axi_awburst = 0;
        c0_ddr4_s_axi_awsize = 0;
        c0_ddr4_s_axi_awlen = 0;
        c0_ddr4_s_axi_wvalid = 0;
        c0_ddr4_s_axi_wstrb = 0;
        c0_ddr4_s_axi_wdata = 0;
        c0_ddr4_s_axi_bready = 0;
        c0_ddr4_s_axi_wlast = 0;
        forever begin
            @(posedge c0_sys_clk_p);
            if(c0_init_calib_complete == 1 && c0_ddr4_reset_n == 1) begin
                break;
            end
        end
        forever begin
            @(posedge c0_ddr4_clk);
            if(c0_ddr4_s_axi_arready == 1) begin
                break;
            end
        end
        $display("here %t\n", $time);
        @(posedge c0_ddr4_clk);
        c0_ddr4_s_axi_arid = 0;
        c0_ddr4_s_axi_araddr = 3072;
        c0_ddr4_s_axi_arlen = 300;
        c0_ddr4_s_axi_arvalid = 1;
        c0_ddr4_s_axi_arburst = 1;
        c0_ddr4_s_axi_arsize = 3;
        c0_ddr4_s_axi_rready = 1;
        @(posedge c0_ddr4_clk);
        c0_ddr4_s_axi_araddr = 0;
        c0_ddr4_s_axi_arlen = 0;
        c0_ddr4_s_axi_arvalid = 0;
        c0_ddr4_s_axi_arburst = 0;
        c0_ddr4_s_axi_arsize = 0;
    end
endmodule
