# ================================================
#             VeroMake Project Makefile
# ================================================
# This Makefile is for use with VeroMake.
# Project Repository: https://github.com/PebPeb/VeroMake
# ================================================

# Project Name - This name will show up on the build options
BUILD_NAME = mux2

# $(PROJECT_ROOT) is provided from the root Makefile of VeroMake
# Relative Path in relation to root Makefile ---> my/relative/path/to/source 
RELATIVE_PROJECT_PATH = general/mux2

# Short hand for making adding sources files easier
PDIR = $(PROJECT_ROOT)/$(RELATIVE_PROJECT_PATH)

# List of Testbench Source Files
# TB_SOURCE root directory is the default output of VeroMake
# Current Valid sources are .v & .cpp
TB_SOURCE = $(PDIR)/sims/mux2_tb.v $(PDIR)/sims/mux2_tb.cpp

# List of files that build up verilog module under test
TB_INCLUDE = $(PDIR)/mux2.v

