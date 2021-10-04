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
if (NOT EXISTS $ENV{VERILATOR_TB})
  message(FATAL_ERROR "Verilator testbench environment not found. Please download from https://www.github.com/jefflieu/verilator_tb.git and set environment variable VERILATOR_TB to point to it")
endif()

if (NOT EXISTS $ENV{VITIS_HLS})
  message (FATAL_ERROR "VITIS_HLS variable doesn't exist")
else()
  add_definitions(-DVITIS_HLS)
endif()

add_executable(sim sim_main.cpp ../example.cpp)
include_directories(../ $ENV{VERILATOR_TB}/inc)
include_directories(../ $ENV{VITIS_HLS}/include)


# Add the Verilated circuit to the target
verilate(sim COVERAGE TRACE
  INCLUDE_DIRS "../"  
  SOURCES "./verilator_dut.v"
  SOURCES "../proj_axi_stream_complex_tlast/solution1/impl/verilog/example.v"
  SOURCES "../proj_axi_stream_complex_tlast/solution1/impl/verilog/example_regslice_both.v"   
  TOP_MODULE "verilator_dut"
  VERILATOR_ARGS "-Wno-STMTDLY" "-Wno-WIDTH" "-Wno-CASEINCOMPLETE" "-Wno-SYMRSVDWORD" "-Wno-UNSIGNED")
