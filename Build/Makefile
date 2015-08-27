# ================================================================
# Please modify the following for your installation and setup

# Directory for the specific example you are building
EG ?= Eg02a_HelloWorld

# Directory containing the Bluespec Training distribution directory
DISTRO ?= $(HOME)/BsInc/Training/Bluespec_Training_2015-08

# Set this to the command that invokes your Verilog simulator
# VSIM ?= modelsim
# VSIM ?= cvc
VSIM ?= iverilog

# ================================================================
# You should not have to change anything below this line

TOPFILE   ?= $(DISTRO)/Example_Programs/$(EG)/src_BSV/Testbench.bsv
TOPMODULE ?= mkTestbench

BSC_COMP_FLAGS = -elab -keep-fires -aggressive-conditions -no-warn-action-shadowing
BSC_LINK_FLAGS = -keep-fires
BSC_PATHS = -p $(DISTRO)/Example_Programs/$(EG)/src_BSV:$(DISTRO)/Example_Programs/Common:%/Prelude:%/Libraries

.PHONY: default
default: compile link

# ----------------------------------------------------------------
# Bluesim compile/link/simulate

BSIM_DIRS = -simdir build_bsim -bdir build_bsim -info-dir build_bsim
BSIM_EXE = $(TOPMODULE)_bsim

.PHONY: all_bsim
all_bsim: full_clean  compile  link    simulate

build_bsim:
	mkdir  build_bsim

.PHONY: compile
compile: build_bsim
	@echo Compiling for Bluesim ...
	bsc -u -sim $(BSIM_DIRS) $(BSC_COMP_FLAGS) $(BSC_PATHS) -g $(TOPMODULE)  $(TOPFILE) 
	@echo Compiling for Bluesim finished

.PHONY: link
link:
	@echo Linking for Bluesim ...
	bsc -e $(TOPMODULE) -sim -o $(BSIM_EXE) $(BSIM_DIRS) $(BSC_LINK_FLAGS) $(BSC_PATHS) \
		$(DISTRO)/Example_Programs/Common/C_imports.c
	@echo Linking for Bluesim finished

.PHONY: simulate
simulate:
	@echo Bluesim simulation ...
	ln -s -f  $(DISTRO)/Example_Programs/$(EG)/objdump  objdump
	./$(BSIM_EXE)  -V
	@echo Bluesim simulation finished

# ----------------------------------------------------------------
# Verilog compile/link/sim

V_DIRS = -vdir verilog_dir -bdir build_v -info-dir build_v
VSIM_EXE = $(TOPMODULE)_vsim

.PHONY: all_vsim
all_vsim: full_clean  verilog  v_link  v_simulate

build_v:
	mkdir  build_v
verilog_dir:
	mkdir  verilog_dir

.PHONY: verilog
verilog: build_v  verilog_dir
	@echo Compiling for Verilog ...
	bsc -u -verilog $(V_DIRS) $(BSC_COMP_FLAGS) $(BSC_PATHS) -g $(TOPMODULE)  $(TOPFILE)
	@echo Compiling for Verilog finished

.PHONY: v_link
v_link:  build_v  verilog_dir
	@echo Linking for Verilog sim ...
	bsc -e $(TOPMODULE) -verilog -o ./$(VSIM_EXE) $(V_DIRS) -vsim $(VSIM)  verilog_dir/$(TOPMODULE).v \
		$(DISTRO)/Example_Programs/Common/C_imports.c
	@echo Linking for Verilog sim finished

.PHONY: v_simulate
v_simulate:
	@echo Verilog simulation...
	./$(VSIM_EXE)  +bscvcd
	@echo Verilog simulation finished

# ----------------------------------------------------------------

.PHONY: clean
clean:
	rm -f  build_bsim/*  build_v/*

.PHONY: full_clean
full_clean:
	rm -r -f  build_bsim  build_v  verilog_dir
	rm -f  $(BSIM_EXE)  $(BSIM_EXE).so  $(VSIM_EXE)  *.vcd  objdump
