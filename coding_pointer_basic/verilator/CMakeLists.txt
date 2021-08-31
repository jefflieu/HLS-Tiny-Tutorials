######################################################################
#
# DESCRIPTION: Verilator CMake Example: Small CMakeLists.txt with tracing
#
# This is an example cmake script to build a verilog to systemc project
# using cmake and verilator.
#
# Copyright 2003-2020 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# Lesser General Public License Version 3 or the Perl Artistic License
# Version 2.0.
#
######################################################################

# This example builds the make_tracing_c example using CMake
# To use it, run the following:

# cd /path/to/verilator/examples/cmake_tracing_c
# rm -rf build && mkdir build && cd build
# cmake ..
# cmake --build .

cmake_minimum_required(VERSION 3.8)
project(coding_pointer_basic)

find_package(verilator HINTS $ENV{VERILATOR_ROOT} ${VERILATOR_ROOT})
if (NOT verilator_FOUND)
  message(FATAL_ERROR "Verilator was not found. Either install it, or set the VERILATOR_ROOT environment variable")
endif()

# Create a new executable target that will contain all your sources
add_executable(sim sim_main.cpp ../pointer_basic.c)
include_directories(../)

# Add the Verilated circuit to the target
verilate(sim COVERAGE TRACE
  INCLUDE_DIRS "../"  
  SOURCES "./pointer_basic_wrap.v"
  SOURCES "../proj_pointer_basic/solution2/impl/verilog/pointer_basic.v"
  SOURCES "../proj_pointer_basic/solution2/impl/verilog/pointer_basic_regslice_forward.v" 
  TOP_MODULE "pointer_basic_wrap"
  VERILATOR_ARGS "-Wno-STMTDLY" "-Wno-WIDTH")
