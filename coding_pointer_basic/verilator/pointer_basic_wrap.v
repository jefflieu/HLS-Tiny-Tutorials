`timescale 1ns/10ps

module pointer_basic_wrap (
        ap_clk,
        ap_rst,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        d_i,
        d_i_ap_vld,
        d_i_ap_ack,
        d_o,
        d_o_ap_vld,
        d_o_ap_ack
);

parameter    ap_ST_fsm_state1 = 3'd1;
parameter    ap_ST_fsm_state2 = 3'd2;
parameter    ap_ST_fsm_state3 = 3'd4;

input   ap_clk;
input   ap_rst;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] d_i;
input   d_i_ap_vld;
output   d_i_ap_ack;
output  [31:0] d_o;
output   d_o_ap_vld;
input   d_o_ap_ack;


  pointer_basic pointer_basic_i (
        .ap_clk   (ap_clk),
        .ap_rst   (ap_rst),
        .ap_start (ap_start),
        .ap_done  (ap_done),
        .ap_idle  (ap_idle),
        .ap_ready (ap_ready),
        .d_i      (d_i),
        .d_i_ap_vld (d_i_ap_vld),
        .d_i_ap_ack (d_i_ap_ack),
        .d_o        (d_o),
        .d_o_ap_vld (d_o_ap_vld),
        .d_o_ap_ack (d_o_ap_ack)
    );


//synthesis translate_off
initial begin 
  if ($test$plusargs("trace") != 0) begin 
    $display("[%0t] Tracing to logs/pointer_basic.vcd...", $time); 
    $dumpfile("logs/pointer_basic.vcd"); 
    $dumpvars(); 
  end 
  $display("[%0t] Model running...", $time);
end
//synthesis translate_on

endmodule 
