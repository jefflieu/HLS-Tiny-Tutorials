// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2017 by Wilson Snyder.
//======================================================================

// Include common routines
#include <verilated.h>
#include <cstdlib>
// Include model header, generated from Verilating "top.v"
#include "Vpointer_basic_wrap.h"
#include "pointer_basic.hpp"

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

extern "C" int counter(bool, int, int);

int main(int argc, char** argv, char** env) {
    // This is a more complicated example, please also see the simpler examples/make_hello_c.

    // Prevent unused variable warnings
    if (0 && argc && argv && env) {}

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs
    Verilated::debug(0);

    // Randomization reset policy
    // May be overridden by commandArgs
    Verilated::randReset(2);

    // Verilator must compute traced signals
    Verilated::traceEverOn(true);

    // Pass arguments so Verilated code can see them, e.g. $value$plusargs
    // This needs to be called before you create any model
    Verilated::commandArgs(argc, argv);

    // Create logs/ directory in case we have traces to put under it
    Verilated::mkdir("logs");

    // Construct the Verilated model, from Vtop.h generated from Verilating "top.v"
    Vpointer_basic_wrap* top = new Vpointer_basic_wrap();  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

    // Set some inputs
    
    top->ap_clk = 0;
    top->ap_rst = 1;
    top->ap_start = 0;
    top->d_i = 0x0010;
    top->d_i_ap_vld = 0;
    top->d_i_ap_ack = 0;
    top->d_o_ap_ack = 0;
    dio_t data_d = 0x1234;

    bool ap_done_to_tb = false;
    bool ap_idle_to_tb;
    bool ap_ready_to_tb;
    bool d_i_ap_ack_to_tb;
    unsigned d_o_to_tb;
    bool d_o_ap_vld_to_tb;



    while (true)  {
        main_time++;  // Time passes...

        // Toggle a fast (time/2 period) clock        
        top->ap_clk = main_time & 0x1;

        // Toggle control signals on an edge that doesn't correspond
        // to where the controls are sampled
        if (!top->ap_clk && main_time > 500) {
         break;
        }

        if (!top->ap_clk ) {
          if (main_time == 20 || ap_done_to_tb) {
              top->ap_rst     = 0;
              top->ap_start   = 1;
              top->d_i_ap_vld = 1;
              top->d_i = data_d;
              VL_PRINTF("Din: %x \r\n", data_d);
              pointer_basic(&data_d);
              VL_PRINTF("Dout: %x \r\n", data_d);
          } else if (top->d_i_ap_vld && d_i_ap_ack_to_tb) {              
              top->d_i_ap_vld = 0;          
              top->ap_start   = 0;
          }             
        }
        

        if (!top->ap_clk) {
          top->d_o_ap_ack = (((main_time >> 1) % 10) == 0);
        }

        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each.)
        top->eval();

        //Checking on rising edge
        if (top->ap_clk )
          if (d_o_ap_vld_to_tb && top->d_o_ap_ack) {                                                
            VL_PRINTF("Checking against C function output %s (%x vs %x) \r\n", (d_o_to_tb == data_d)?"OK":"ERROR", d_o_to_tb, data_d);
          }


        //Sampling on falling edge after eval
        if (!top->ap_clk) {
          ap_done_to_tb  = top->ap_done;
          ap_ready_to_tb = top->ap_ready;
          ap_idle_to_tb  = top->ap_idle;
          d_i_ap_ack_to_tb  = top->d_i_ap_ack;
          d_o_ap_vld_to_tb  = top->d_o_ap_vld;
          d_o_to_tb         = top->d_o;
        }


    }
    // Final model cleanup
    top->final();

    //Check    
    VL_PRINTF("Test done");


    //  Coverage analysis (since test passed)
#if VM_COVERAGE
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage.dat");
#endif

    // Destroy model
    delete top; top = NULL;

    // Fin
    exit(0);
}
