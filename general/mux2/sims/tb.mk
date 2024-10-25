# Testbench Makefile

BUILD_NAME = mux2

RELATIVE_PROJECT_PATH = general/mux2
PDIR = $(PROJECT_ROOT)/$(RELATIVE_PROJECT_PATH)

TB_SOURCE = $(PDIR)/sims/mux2_tb.v $(PDIR)/sims/mux2_tb.cpp
TB_INCLUDE = $(PDIR)/mux2.v
