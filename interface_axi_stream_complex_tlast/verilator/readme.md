
- This testbench tests the generated Verilog file produced by vitis HLS
- This testbench example requires some code from https://www.github.com/jefflieu/verilator_tb.git
- Download the above repository and set environment VERILATOR_TB to point to that repository
- Then : 

+ under `interface_axi_stream_complex_tlast` run 
    vitis_hls -f run_hls.tcl
+ then under `verilator` run 
    mkdir sim
    cd sim && cmake ../
    make
    ./sim +trace

Output VCD file is put under sim/logs/dut.vcd
