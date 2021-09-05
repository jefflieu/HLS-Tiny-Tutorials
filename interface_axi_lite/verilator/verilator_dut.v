`timescale 1ns/10ps

module verilator_dut (
        s_axi_BUS_A_AWVALID,
        s_axi_BUS_A_AWREADY,
        s_axi_BUS_A_AWADDR,
        s_axi_BUS_A_WVALID,
        s_axi_BUS_A_WREADY,
        s_axi_BUS_A_WDATA,
        s_axi_BUS_A_WSTRB,
        s_axi_BUS_A_ARVALID,
        s_axi_BUS_A_ARREADY,
        s_axi_BUS_A_ARADDR,
        s_axi_BUS_A_RVALID,
        s_axi_BUS_A_RREADY,
        s_axi_BUS_A_RDATA,
        s_axi_BUS_A_RRESP,
        s_axi_BUS_A_BVALID,
        s_axi_BUS_A_BREADY,
        s_axi_BUS_A_BRESP,
        ap_clk,
        ap_rst_n,
        interrupt
);

parameter    C_S_AXI_BUS_A_DATA_WIDTH = 32;
parameter    C_S_AXI_BUS_A_ADDR_WIDTH = 6;
parameter    C_S_AXI_DATA_WIDTH = 32;

parameter C_S_AXI_BUS_A_WSTRB_WIDTH = (32 / 8);
parameter C_S_AXI_WSTRB_WIDTH = (32 / 8);

input   s_axi_BUS_A_AWVALID;
output   s_axi_BUS_A_AWREADY;
input  [C_S_AXI_BUS_A_ADDR_WIDTH - 1:0] s_axi_BUS_A_AWADDR;
input   s_axi_BUS_A_WVALID;
output   s_axi_BUS_A_WREADY;
input  [C_S_AXI_BUS_A_DATA_WIDTH - 1:0] s_axi_BUS_A_WDATA;
input  [C_S_AXI_BUS_A_WSTRB_WIDTH - 1:0] s_axi_BUS_A_WSTRB;
input   s_axi_BUS_A_ARVALID;
output   s_axi_BUS_A_ARREADY;
input  [C_S_AXI_BUS_A_ADDR_WIDTH - 1:0] s_axi_BUS_A_ARADDR;
output   s_axi_BUS_A_RVALID;
input   s_axi_BUS_A_RREADY;
output  [C_S_AXI_BUS_A_DATA_WIDTH - 1:0] s_axi_BUS_A_RDATA;
output  [1:0] s_axi_BUS_A_RRESP;
output   s_axi_BUS_A_BVALID;
input   s_axi_BUS_A_BREADY;
output  [1:0] s_axi_BUS_A_BRESP;
input   ap_clk;
input   ap_rst_n;
output   interrupt;

  example #(
      .C_S_AXI_BUS_A_DATA_WIDTH(C_S_AXI_BUS_A_DATA_WIDTH),
      .C_S_AXI_BUS_A_ADDR_WIDTH(C_S_AXI_BUS_A_ADDR_WIDTH),
      .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
      .C_S_AXI_BUS_A_WSTRB_WIDTH(C_S_AXI_BUS_A_WSTRB_WIDTH),
      .C_S_AXI_WSTRB_WIDTH(C_S_AXI_WSTRB_WIDTH)
    ) inst_example (
      .s_axi_BUS_A_AWVALID (s_axi_BUS_A_AWVALID),
      .s_axi_BUS_A_AWREADY (s_axi_BUS_A_AWREADY),
      .s_axi_BUS_A_AWADDR  (s_axi_BUS_A_AWADDR),
      .s_axi_BUS_A_WVALID  (s_axi_BUS_A_WVALID),
      .s_axi_BUS_A_WREADY  (s_axi_BUS_A_WREADY),
      .s_axi_BUS_A_WDATA   (s_axi_BUS_A_WDATA),
      .s_axi_BUS_A_WSTRB   (s_axi_BUS_A_WSTRB),
      .s_axi_BUS_A_ARVALID (s_axi_BUS_A_ARVALID),
      .s_axi_BUS_A_ARREADY (s_axi_BUS_A_ARREADY),
      .s_axi_BUS_A_ARADDR  (s_axi_BUS_A_ARADDR),
      .s_axi_BUS_A_RVALID  (s_axi_BUS_A_RVALID),
      .s_axi_BUS_A_RREADY  (s_axi_BUS_A_RREADY),
      .s_axi_BUS_A_RDATA   (s_axi_BUS_A_RDATA),
      .s_axi_BUS_A_RRESP   (s_axi_BUS_A_RRESP),
      .s_axi_BUS_A_BVALID  (s_axi_BUS_A_BVALID),
      .s_axi_BUS_A_BREADY  (s_axi_BUS_A_BREADY),
      .s_axi_BUS_A_BRESP   (s_axi_BUS_A_BRESP),
      .ap_clk              (ap_clk),
      .ap_rst_n            (ap_rst_n),
      .interrupt           (interrupt)
    );

   reg [31:0] cntr = 0;
   always_ff@(posedge ap_clk)
   begin 
    cntr <= cntr + 1;
   end 

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
