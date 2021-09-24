`timescale 1ns/10ps

module verilator_dut (
        ap_clk,
        ap_rst_n,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        A_TDATA,
        A_TVALID,
        A_TREADY,
        A_TKEEP,
        A_TSTRB,
        A_TLAST,
        B_TDATA,
        B_TVALID,
        B_TREADY,
        B_TKEEP,
        B_TSTRB,
        B_TLAST
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_pp0_stage0 = 3'd2;
parameter    ap_ST_fsm_state4 = 3'd4;

input   ap_clk;
input   ap_rst_n;
input   ap_start;
output  ap_done;
output  ap_idle;
output  ap_ready;
input   [31:0] A_TDATA;
input   A_TVALID;
output  A_TREADY;
input   [3:0] A_TKEEP;
input   [3:0] A_TSTRB;
input   [0:0] A_TLAST;
output  [31:0] B_TDATA;
output  B_TVALID;
input   B_TREADY;
output  [3:0] B_TKEEP;
output  [3:0] B_TSTRB;
output  [0:0] B_TLAST;



example #(
    .ap_ST_fsm_state1(ap_ST_fsm_state1),
    .ap_ST_fsm_pp0_stage0(ap_ST_fsm_pp0_stage0),
    .ap_ST_fsm_state4(ap_ST_fsm_state4)
  ) inst_example (
    .ap_clk   (ap_clk),
    .ap_rst_n (ap_rst_n),
    .ap_start (ap_start),
    .ap_done  (ap_done),
    .ap_idle  (ap_idle),
    .ap_ready (ap_ready),
    .A_TDATA  (A_TDATA),
    .A_TVALID (A_TVALID),
    .A_TREADY (A_TREADY),
    .A_TKEEP  (A_TKEEP),
    .A_TSTRB  (A_TSTRB),
    .A_TLAST  (A_TLAST),
    .B_TDATA  (B_TDATA),
    .B_TVALID (B_TVALID),
    .B_TREADY (B_TREADY),
    .B_TKEEP  (B_TKEEP),
    .B_TSTRB  (B_TSTRB),
    .B_TLAST  (B_TLAST)
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
