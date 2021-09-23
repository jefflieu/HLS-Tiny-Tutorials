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
#include "AllDrivers.h"

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
#define CLOCK_CYCLE (main_time>>1)
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}


using AxiLite32    = vtb::AxiLiteDriver<uint32_t, uint32_t>;
using AxiLite32M2S = vtb::AxiLiteM2S<uint32_t, uint32_t>;
using AxiLite32S2M = vtb::AxiLiteS2M<uint32_t, uint32_t>;
using AxiLiteTransaction = vtb::AxiLiteTransaction<uint32_t, uint32_t>;

void example(char *a, char *b, char *c);
void generateTransaction(AxiLite32* axiliteDriver);

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
    Vverilator_dut* top = new Vverilator_dut();  // Or use a const unique_ptr, or the VL_UNIQUE_PTR wrapper

    AxiLite32* axiliteDriver = new AxiLite32();
    AxiLite32M2S axi_driver_to_dut;
    AxiLite32S2M axi_dut_to_driver;


    while (true)  {
        main_time++;  // Time passes...

        if (axiliteDriver->getTransactionCount() < 2) generateTransaction(axiliteDriver); 

        // Toggle a fast (time/2 period) clock        
        top->ap_clk = main_time & 0x1;
        // Evaluate model
        // (If you have multiple models being simulated in the same
        // timestep then instead of eval(), call eval_step() on each, then
        // eval_end_step() on each.)

        if (!top->ap_clk) {
          //Pass signals going into blocks on negative edge
          top->ap_rst_n = (CLOCK_CYCLE > 100);
          top->s_axi_BUS_A_AWVALID = axi_driver_to_dut.awvalid;
          top->s_axi_BUS_A_AWADDR  = axi_driver_to_dut.awaddr;
          top->s_axi_BUS_A_WVALID  = axi_driver_to_dut.wvalid;
          top->s_axi_BUS_A_WDATA   = axi_driver_to_dut.wdata;
          top->s_axi_BUS_A_WSTRB   = axi_driver_to_dut.wstrb;
          top->s_axi_BUS_A_ARVALID = axi_driver_to_dut.arvalid;
          top->s_axi_BUS_A_ARADDR  = axi_driver_to_dut.araddr;
          top->s_axi_BUS_A_RREADY  = axi_driver_to_dut.rready;
          top->s_axi_BUS_A_BREADY  = axi_driver_to_dut.bready;


          axi_dut_to_driver.awready = top->s_axi_BUS_A_AWREADY;
          axi_dut_to_driver.arready = top->s_axi_BUS_A_ARREADY;
          axi_dut_to_driver.wready  = top->s_axi_BUS_A_WREADY;
          axi_dut_to_driver.rvalid  = top->s_axi_BUS_A_RVALID ;
          axi_dut_to_driver.rdata   = top->s_axi_BUS_A_RDATA  ;
          axi_dut_to_driver.bvalid  = top->s_axi_BUS_A_BVALID;
          axi_dut_to_driver.bresp   = top->s_axi_BUS_A_BRESP;
          axi_dut_to_driver.rresp   = top->s_axi_BUS_A_RRESP;          
        }

        top->eval();
        axiliteDriver->eval(main_time, top->ap_clk, (main_time < 100), axi_driver_to_dut, axi_dut_to_driver);


        if (main_time >= 5000) break;

    }
    // Final model cleanup
    top->final();

    //Check    
    VL_PRINTF("Test done\r\n");


    //  Coverage analysis (since test passed)
#if VM_COVERAGE
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage.dat");
#endif

    // Destroy model
    delete top; top = NULL;
    delete axiliteDriver; axiliteDriver = NULL;

    // Fin
    exit(0);
}


void generateTransaction(AxiLite32* axiliteDriver)
{
    static char a = 0, b = 0, c = 0;
    a = rand();
    b = rand();
    c = rand();
    
    AxiLiteTransaction* t;    
    t = new AxiLiteTransaction(AxiLiteTransaction::WRITE, 0x10, a);
    axiliteDriver->pushTransaction(*t);
    t = new AxiLiteTransaction(AxiLiteTransaction::WRITE, 0x18, b);
    axiliteDriver->pushTransaction(*t);
    t = new AxiLiteTransaction(AxiLiteTransaction::WRITE, 0x20, c);
    axiliteDriver->pushTransaction(*t);

    t = new AxiLiteTransaction(AxiLiteTransaction::WRITE, 0x0, 0x1);
    axiliteDriver->pushTransaction(*t);

    //Calling the C function to compare the output
    example(&a, &b, &c);

    t = new AxiLiteTransaction(AxiLiteTransaction::READ_POLL , 0x0, 0x2, 0x2);
    axiliteDriver->pushTransaction(*t);

    t = new AxiLiteTransaction(AxiLiteTransaction::READ_POLL , 0x2c, 0x1, 0x1);
    axiliteDriver->pushTransaction(*t);
    
    t = new AxiLiteTransaction(AxiLiteTransaction::READ_CHECK, 0x28, c, 0xFF);
    axiliteDriver->pushTransaction(*t);
    delete t;
}
