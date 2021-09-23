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

using namespace vtb;

// Current simulation time (64-bit unsigned)
vluint64_t main_time = 0;
#define CLOCK_CYCLE (main_time>>1)
// Called by $time in Verilog
double sc_time_stamp() {
    return main_time;  // Note does conversion to real, to match SystemC
}

using AxiMem32     = AxiMemory<uint32_t, uint32_t>;
using Axi32M2S     = AxiBusM2S<uint32_t, uint32_t>;
using Axi32S2M     = AxiBusS2M<uint32_t, uint32_t>;


void example(volatile int* a);

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

    AxiMem32*  axi_memory = new AxiMem32( (4<<10) , 0x0, "Mem 4kB");
    srand(1);
    axi_memory->randomizeData();
    Axi32M2S   axi_dut_to_mem;
    Axi32S2M   axi_mem_to_dut;

    void* ref_buffer = malloc(axi_memory->getMemSize(0));
    memcpy(ref_buffer, axi_memory->getMemPtr(0), axi_memory->getMemSize(0));
    example((volatile int*)ref_buffer);

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
          
          top->m_axi_a_AWREADY = axi_mem_to_dut.awready; 
          top->m_axi_a_WREADY  = axi_mem_to_dut.wready ;
          top->m_axi_a_ARREADY = axi_mem_to_dut.arready;
          top->m_axi_a_RVALID  = axi_mem_to_dut.rvalid ;
          top->m_axi_a_RDATA   = axi_mem_to_dut.rdata  ;
          top->m_axi_a_RLAST   = axi_mem_to_dut.rlast  ;
          top->m_axi_a_RID     = axi_mem_to_dut.rid    ;
          top->m_axi_a_RRESP   = axi_mem_to_dut.rresp  ;
          top->m_axi_a_BVALID  = axi_mem_to_dut.bvalid ;
          top->m_axi_a_BRESP   = axi_mem_to_dut.bresp  ;
          top->m_axi_a_BID     = axi_mem_to_dut.bid    ;     
          top->m_axi_a_RUSER   = axi_mem_to_dut.ruser  ;          
          top->m_axi_a_BUSER   = axi_mem_to_dut.buser  ;

          axi_dut_to_mem.awvalid   = top->m_axi_a_AWVALID ;
          axi_dut_to_mem.awaddr    = top->m_axi_a_AWADDR  ;
          axi_dut_to_mem.awid      = top->m_axi_a_AWID    ;
          axi_dut_to_mem.awlen     = top->m_axi_a_AWLEN   ;
          axi_dut_to_mem.awsize    = top->m_axi_a_AWSIZE  ;
          axi_dut_to_mem.awburst   = top->m_axi_a_AWBURST ;
          axi_dut_to_mem.awlock    = top->m_axi_a_AWLOCK  ;
          axi_dut_to_mem.awcache   = top->m_axi_a_AWCACHE ;
          axi_dut_to_mem.awprot    = top->m_axi_a_AWPROT  ;
          axi_dut_to_mem.awqos     = top->m_axi_a_AWQOS   ;
          axi_dut_to_mem.awregion  = top->m_axi_a_AWREGION;
          axi_dut_to_mem.awuser    = top->m_axi_a_AWUSER  ;
          axi_dut_to_mem.wvalid    = top->m_axi_a_WVALID  ;
          axi_dut_to_mem.wdata     = top->m_axi_a_WDATA   ;
          axi_dut_to_mem.wstrb     = top->m_axi_a_WSTRB   ;
          axi_dut_to_mem.wlast     = top->m_axi_a_WLAST   ;
          axi_dut_to_mem.wid       = top->m_axi_a_WID     ;
          axi_dut_to_mem.wuser     = top->m_axi_a_WUSER   ;

          axi_dut_to_mem.arvalid   = top->m_axi_a_ARVALID ;
          axi_dut_to_mem.araddr    = top->m_axi_a_ARADDR  ;
          axi_dut_to_mem.arid      = top->m_axi_a_ARID    ;
          axi_dut_to_mem.arlen     = top->m_axi_a_ARLEN   ;
          axi_dut_to_mem.arsize    = top->m_axi_a_ARSIZE  ;
          axi_dut_to_mem.arburst   = top->m_axi_a_ARBURST ;
          axi_dut_to_mem.arlock    = top->m_axi_a_ARLOCK  ;
          axi_dut_to_mem.arcache   = top->m_axi_a_ARCACHE ;
          axi_dut_to_mem.arprot    = top->m_axi_a_ARPROT  ;
          axi_dut_to_mem.arqos     = top->m_axi_a_ARQOS   ;
          axi_dut_to_mem.arregion  = top->m_axi_a_ARREGION;
          axi_dut_to_mem.aruser    = top->m_axi_a_ARUSER  ;

          axi_dut_to_mem.rready    = top->m_axi_a_RREADY  ;
          axi_dut_to_mem.bready    = top->m_axi_a_BREADY  ;

          top->ap_start = (CLOCK_CYCLE == 105);
        }

        top->eval();
        axi_memory->eval(main_time, top->ap_clk, (main_time < 100), axi_dut_to_mem, axi_mem_to_dut);


        if (main_time >= 1000) break;

    }
    // Final model cleanup
    top->final();
    
    VL_PRINTF("Comparing data: %s\r\n", memcmp(ref_buffer, axi_memory->getMemPtr(0), axi_memory->getMemSize(0))==0?"PASSED":"FAILED");
    
    //Check    
    VL_PRINTF("Test done\r\n");


    //  Coverage analysis (since test passed)
#if VM_COVERAGE
    Verilated::mkdir("logs");
    VerilatedCov::write("logs/coverage.dat");
#endif

    // Destroy model
    delete axi_memory; axi_memory = NULL;
    delete top; top = NULL;    

    // Fin
    exit(0);    
}

