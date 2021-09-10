`timescale 1ns/10ps

module verilator_dut (
        ap_clk,
        ap_rst_n,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        m_axi_a_AWVALID,
        m_axi_a_AWREADY,
        m_axi_a_AWADDR,
        m_axi_a_AWID,
        m_axi_a_AWLEN,
        m_axi_a_AWSIZE,
        m_axi_a_AWBURST,
        m_axi_a_AWLOCK,
        m_axi_a_AWCACHE,
        m_axi_a_AWPROT,
        m_axi_a_AWQOS,
        m_axi_a_AWREGION,
        m_axi_a_AWUSER,
        m_axi_a_WVALID,
        m_axi_a_WREADY,
        m_axi_a_WDATA,
        m_axi_a_WSTRB,
        m_axi_a_WLAST,
        m_axi_a_WID,
        m_axi_a_WUSER,
        m_axi_a_ARVALID,
        m_axi_a_ARREADY,
        m_axi_a_ARADDR,
        m_axi_a_ARID,
        m_axi_a_ARLEN,
        m_axi_a_ARSIZE,
        m_axi_a_ARBURST,
        m_axi_a_ARLOCK,
        m_axi_a_ARCACHE,
        m_axi_a_ARPROT,
        m_axi_a_ARQOS,
        m_axi_a_ARREGION,
        m_axi_a_ARUSER,
        m_axi_a_RVALID,
        m_axi_a_RREADY,
        m_axi_a_RDATA,
        m_axi_a_RLAST,
        m_axi_a_RID,
        m_axi_a_RUSER,
        m_axi_a_RRESP,
        m_axi_a_BVALID,
        m_axi_a_BREADY,
        m_axi_a_BRESP,
        m_axi_a_BID,
        m_axi_a_BUSER
);

parameter    ap_ST_fsm_state1 = 17'd1;
parameter    ap_ST_fsm_state2 = 17'd2;
parameter    ap_ST_fsm_state3 = 17'd4;
parameter    ap_ST_fsm_state4 = 17'd8;
parameter    ap_ST_fsm_state5 = 17'd16;
parameter    ap_ST_fsm_state6 = 17'd32;
parameter    ap_ST_fsm_state7 = 17'd64;
parameter    ap_ST_fsm_pp0_stage0 = 17'd128;
parameter    ap_ST_fsm_state11 = 17'd256;
parameter    ap_ST_fsm_pp1_stage0 = 17'd512;
parameter    ap_ST_fsm_state14 = 17'd1024;
parameter    ap_ST_fsm_pp2_stage0 = 17'd2048;
parameter    ap_ST_fsm_state18 = 17'd4096;
parameter    ap_ST_fsm_state19 = 17'd8192;
parameter    ap_ST_fsm_state20 = 17'd16384;
parameter    ap_ST_fsm_state21 = 17'd32768;
parameter    ap_ST_fsm_state22 = 17'd65536;
parameter    C_M_AXI_A_ID_WIDTH = 1;
parameter    C_M_AXI_A_ADDR_WIDTH = 64;
parameter    C_M_AXI_A_DATA_WIDTH = 32;
parameter    C_M_AXI_A_AWUSER_WIDTH = 1;
parameter    C_M_AXI_A_ARUSER_WIDTH = 1;
parameter    C_M_AXI_A_WUSER_WIDTH = 1;
parameter    C_M_AXI_A_RUSER_WIDTH = 1;
parameter    C_M_AXI_A_BUSER_WIDTH = 1;
parameter    C_M_AXI_A_TARGET_ADDR = 0;
parameter    C_M_AXI_A_USER_VALUE = 0;
parameter    C_M_AXI_A_PROT_VALUE = 0;
parameter    C_M_AXI_A_CACHE_VALUE = 3;
parameter    C_M_AXI_DATA_WIDTH = 32;

parameter C_M_AXI_A_WSTRB_WIDTH = (32 / 8);
parameter C_M_AXI_WSTRB_WIDTH = (32 / 8);

input   ap_clk;
input   ap_rst_n;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
output   m_axi_a_AWVALID;
input   m_axi_a_AWREADY;
output  [C_M_AXI_A_ADDR_WIDTH - 1:0] m_axi_a_AWADDR;
output  [C_M_AXI_A_ID_WIDTH - 1:0] m_axi_a_AWID;
output  [7:0] m_axi_a_AWLEN;
output  [2:0] m_axi_a_AWSIZE;
output  [1:0] m_axi_a_AWBURST;
output  [1:0] m_axi_a_AWLOCK;
output  [3:0] m_axi_a_AWCACHE;
output  [2:0] m_axi_a_AWPROT;
output  [3:0] m_axi_a_AWQOS;
output  [3:0] m_axi_a_AWREGION;
output  [C_M_AXI_A_AWUSER_WIDTH - 1:0] m_axi_a_AWUSER;
output   m_axi_a_WVALID;
input   m_axi_a_WREADY;
output  [C_M_AXI_A_DATA_WIDTH - 1:0] m_axi_a_WDATA;
output  [C_M_AXI_A_WSTRB_WIDTH - 1:0] m_axi_a_WSTRB;
output   m_axi_a_WLAST;
output  [C_M_AXI_A_ID_WIDTH - 1:0] m_axi_a_WID;
output  [C_M_AXI_A_WUSER_WIDTH - 1:0] m_axi_a_WUSER;
output   m_axi_a_ARVALID;
input   m_axi_a_ARREADY;
output  [C_M_AXI_A_ADDR_WIDTH - 1:0] m_axi_a_ARADDR;
output  [C_M_AXI_A_ID_WIDTH - 1:0] m_axi_a_ARID;
output  [7:0] m_axi_a_ARLEN;
output  [2:0] m_axi_a_ARSIZE;
output  [1:0] m_axi_a_ARBURST;
output  [1:0] m_axi_a_ARLOCK;
output  [3:0] m_axi_a_ARCACHE;
output  [2:0] m_axi_a_ARPROT;
output  [3:0] m_axi_a_ARQOS;
output  [3:0] m_axi_a_ARREGION;
output  [C_M_AXI_A_ARUSER_WIDTH - 1:0] m_axi_a_ARUSER;
input   m_axi_a_RVALID;
output   m_axi_a_RREADY;
input  [C_M_AXI_A_DATA_WIDTH - 1:0] m_axi_a_RDATA;
input   m_axi_a_RLAST;
input  [C_M_AXI_A_ID_WIDTH - 1:0] m_axi_a_RID;
input  [C_M_AXI_A_RUSER_WIDTH - 1:0] m_axi_a_RUSER;
input  [1:0] m_axi_a_RRESP;
input   m_axi_a_BVALID;
output   m_axi_a_BREADY;
input  [1:0] m_axi_a_BRESP;
input  [C_M_AXI_A_ID_WIDTH - 1:0] m_axi_a_BID;
input  [C_M_AXI_A_BUSER_WIDTH - 1:0] m_axi_a_BUSER;

  example #(
      .ap_ST_fsm_state1(ap_ST_fsm_state1),
      .ap_ST_fsm_state2(ap_ST_fsm_state2),
      .ap_ST_fsm_state3(ap_ST_fsm_state3),
      .ap_ST_fsm_state4(ap_ST_fsm_state4),
      .ap_ST_fsm_state5(ap_ST_fsm_state5),
      .ap_ST_fsm_state6(ap_ST_fsm_state6),
      .ap_ST_fsm_state7(ap_ST_fsm_state7),
      .ap_ST_fsm_pp0_stage0(ap_ST_fsm_pp0_stage0),
      .ap_ST_fsm_state11(ap_ST_fsm_state11),
      .ap_ST_fsm_pp1_stage0(ap_ST_fsm_pp1_stage0),
      .ap_ST_fsm_state14(ap_ST_fsm_state14),
      .ap_ST_fsm_pp2_stage0(ap_ST_fsm_pp2_stage0),
      .ap_ST_fsm_state18(ap_ST_fsm_state18),
      .ap_ST_fsm_state19(ap_ST_fsm_state19),
      .ap_ST_fsm_state20(ap_ST_fsm_state20),
      .ap_ST_fsm_state21(ap_ST_fsm_state21),
      .ap_ST_fsm_state22(ap_ST_fsm_state22),
      .C_M_AXI_A_ID_WIDTH(C_M_AXI_A_ID_WIDTH),
      .C_M_AXI_A_ADDR_WIDTH(C_M_AXI_A_ADDR_WIDTH),
      .C_M_AXI_A_DATA_WIDTH(C_M_AXI_A_DATA_WIDTH),
      .C_M_AXI_A_AWUSER_WIDTH(C_M_AXI_A_AWUSER_WIDTH),
      .C_M_AXI_A_ARUSER_WIDTH(C_M_AXI_A_ARUSER_WIDTH),
      .C_M_AXI_A_WUSER_WIDTH(C_M_AXI_A_WUSER_WIDTH),
      .C_M_AXI_A_RUSER_WIDTH(C_M_AXI_A_RUSER_WIDTH),
      .C_M_AXI_A_BUSER_WIDTH(C_M_AXI_A_BUSER_WIDTH),
      .C_M_AXI_A_TARGET_ADDR(C_M_AXI_A_TARGET_ADDR),
      .C_M_AXI_A_USER_VALUE(C_M_AXI_A_USER_VALUE),
      .C_M_AXI_A_PROT_VALUE(C_M_AXI_A_PROT_VALUE),
      .C_M_AXI_A_CACHE_VALUE(C_M_AXI_A_CACHE_VALUE),
      .C_M_AXI_DATA_WIDTH(C_M_AXI_DATA_WIDTH),
      .C_M_AXI_A_WSTRB_WIDTH(C_M_AXI_A_WSTRB_WIDTH),
      .C_M_AXI_WSTRB_WIDTH(C_M_AXI_WSTRB_WIDTH)
    ) inst_example (
      .ap_clk           (ap_clk),
      .ap_rst_n         (ap_rst_n),
      .ap_start         (ap_start),
      .ap_done          (ap_done),
      .ap_idle          (ap_idle),
      .ap_ready         (ap_ready),
      .m_axi_a_AWVALID  (m_axi_a_AWVALID),
      .m_axi_a_AWREADY  (m_axi_a_AWREADY),
      .m_axi_a_AWADDR   (m_axi_a_AWADDR),
      .m_axi_a_AWID     (m_axi_a_AWID),
      .m_axi_a_AWLEN    (m_axi_a_AWLEN),
      .m_axi_a_AWSIZE   (m_axi_a_AWSIZE),
      .m_axi_a_AWBURST  (m_axi_a_AWBURST),
      .m_axi_a_AWLOCK   (m_axi_a_AWLOCK),
      .m_axi_a_AWCACHE  (m_axi_a_AWCACHE),
      .m_axi_a_AWPROT   (m_axi_a_AWPROT),
      .m_axi_a_AWQOS    (m_axi_a_AWQOS),
      .m_axi_a_AWREGION (m_axi_a_AWREGION),
      .m_axi_a_AWUSER   (m_axi_a_AWUSER),
      .m_axi_a_WVALID   (m_axi_a_WVALID),
      .m_axi_a_WREADY   (m_axi_a_WREADY),
      .m_axi_a_WDATA    (m_axi_a_WDATA),
      .m_axi_a_WSTRB    (m_axi_a_WSTRB),
      .m_axi_a_WLAST    (m_axi_a_WLAST),
      .m_axi_a_WID      (m_axi_a_WID),
      .m_axi_a_WUSER    (m_axi_a_WUSER),
      .m_axi_a_ARVALID  (m_axi_a_ARVALID),
      .m_axi_a_ARREADY  (m_axi_a_ARREADY),
      .m_axi_a_ARADDR   (m_axi_a_ARADDR),
      .m_axi_a_ARID     (m_axi_a_ARID),
      .m_axi_a_ARLEN    (m_axi_a_ARLEN),
      .m_axi_a_ARSIZE   (m_axi_a_ARSIZE),
      .m_axi_a_ARBURST  (m_axi_a_ARBURST),
      .m_axi_a_ARLOCK   (m_axi_a_ARLOCK),
      .m_axi_a_ARCACHE  (m_axi_a_ARCACHE),
      .m_axi_a_ARPROT   (m_axi_a_ARPROT),
      .m_axi_a_ARQOS    (m_axi_a_ARQOS),
      .m_axi_a_ARREGION (m_axi_a_ARREGION),
      .m_axi_a_ARUSER   (m_axi_a_ARUSER),
      .m_axi_a_RVALID   (m_axi_a_RVALID),
      .m_axi_a_RREADY   (m_axi_a_RREADY),
      .m_axi_a_RDATA    (m_axi_a_RDATA),
      .m_axi_a_RLAST    (m_axi_a_RLAST),
      .m_axi_a_RID      (m_axi_a_RID),
      .m_axi_a_RUSER    (m_axi_a_RUSER),
      .m_axi_a_RRESP    (m_axi_a_RRESP),
      .m_axi_a_BVALID   (m_axi_a_BVALID),
      .m_axi_a_BREADY   (m_axi_a_BREADY),
      .m_axi_a_BRESP    (m_axi_a_BRESP),
      .m_axi_a_BID      (m_axi_a_BID),
      .m_axi_a_BUSER    (m_axi_a_BUSER)
    );


//synthesis translate_off
initial begin 
  if ($test$plusargs("trace") != 0) begin 
    $display("[%0t] Tracing to logs/dut.vcd...", $time); 
    $dumpfile("logs/dut.vcd"); 
    $dumpvars(); 
  end 
  $display("[%0t] Model running...", $time);
end
//synthesis translate_on

endmodule 
