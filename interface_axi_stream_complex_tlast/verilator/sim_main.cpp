// DESCRIPTION: Verilator: Verilog example module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2017 by Wilson Snyder.
//======================================================================

// Include common routines
#include <verilated.h>
#include <cstdlib>
// Include model header, generated from Verilating "top.v"
#include "Vverilator_dut.h"
#include "AllVtbHeaders.h"

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
#define CLOCK_CYCLE (main_time>>1)
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

using AxiSDriver      = vtb::AxiStreamDriver<uint32_t>;
using AxiSource32     = vtb::AxiStreamSource<uint32_t>;
using AxiSink32       = vtb::AxiStreamSink;
using AxiSXfer        = vtb::AxiStreamTransaction;



int main(int argc, char** argv, char** env) {
    // This is a more complicated example, please also see the simpler examples/make_hello_c.

    // Prevent unused variable warnings
    if (0 && argc && argv && env) {}

    // Set debug level, 0 is off, 9 is highest presently used
    // May be overridden by commandArgs
    Verilated::debug(9);

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
    Vverilator_dut* top = new Vverilator_dut();  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

    AxiSDriver*   driver = new AxiSDriver("AXI stream driver");
    AxiSource32   driver_to_dut;
    AxiSink32     dut_to_driver;

    AxiSource32   dut_out_to_driver;
    AxiSink32     driver_sink_to_dut;

    uint8_t* byte_stream = new uint8_t[1024];
    for(uint32_t i = 0; i < 1024; i++) byte_stream[i] = i;

    AxiSXfer t(AxiSXfer::FROM_BUFFER, byte_stream, 128, 2);
    driver->pushTransaction(t);

    while (true)  {
        main_time++;  // Time passes...

        // Toggle a fast (time/2 period) clock        
        top->ap_clk = main_time & 0x1;
        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each.)
        
        if (!top->ap_clk) {
          //Pass signals going into blocks on negative edge
          top->ap_rst_n = (CLOCK_CYCLE > 100);
          top->ap_start = (CLOCK_CYCLE == 105);

          top->A_TDATA  = driver_to_dut.tdata;
          top->A_TVALID = driver_to_dut.tvalid;
          top->A_TKEEP  = driver_to_dut.tkeep;
          top->A_TSTRB  = driver_to_dut.tstrb;
          top->A_TLAST  = driver_to_dut.tlast;          
          dut_to_driver.tready = top->A_TREADY;
          top->B_TREADY = 1;
        }

        top->eval();
        driver->eval(main_time, top->ap_clk, (main_time < 100) , driver_to_dut, dut_to_driver);
        if (main_time >= 1000) break;

    }
    // Final model cleanup
    top->final();
    
    //VL_PRINTF("Comparing data: %s\r\n", memcmp(ref_buffer, axi_memory->getMemPtr(0), axi_memory->getMemSize(0))==0?"PASSED":"FAILED");
    
    //Check    
    VL_PRINTF("Test done\r\n");


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

