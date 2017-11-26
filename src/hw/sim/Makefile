# RICKY TRAN
# EEL4720
# MAKEFILE FOR NON-PROJ SIM

TARGET = user_app_tb
CC = xvhdl
ELAB = xelab
SIM = xsim

CFLAGS = -nolog
EFLAGS = -nolog -debug typical $(TARGET) -s top_sim
SFLAGS = top_sim -wdb simulate_xsim.wdb -t signal.tcl -stats -onfinish quit -nolog

WORK_DIR = xsim.dir/work
RTL_DIR := ../rtl
TB_DIR := ../tb
SRC_EXT := vhd
SRCS := $(shell find $(RTL_DIR) -type l -name *.$(SRC_EXT)) $(shell find $(RTL_DIR) -type f -name *.$(SRC_EXT))
TESTS := $(shell find $(TB_DIR) -type l -name *.$(SRC_EXT)) $(shell find $(TB_DIR) -type f -name *.$(SRC_EXT))
OBJS := $(patsubst $(RTL_DIR)/%, $(WORK_DIR)/%, $(SRCS:.$(SRC_EXT)=.vdb))
TB_OBJS := $(patsubst $(TB_DIR)/%, $(WORK_DIR)/%, $(TESTS:.$(SRC_EXT)=.vdb))

sim: elaborate
	$(SIM) $(SFLAGS)

elaborate: pkg $(OBJS) $(TB_OBJS)
	$(ELAB) $(EFLAGS)

pkg: $(WORK_DIR)/config_pkg.vdb $(WORK_DIR)/user_pkg.vdb

$(WORK_DIR)/config_pkg.vdb: $(RTL_DIR)/config_pkg.vhd
	$(CC) $(CFLAGS) $(RTL_DIR)/config_pkg.vhd

$(WORK_DIR)/user_pkg.vdb: $(RTL_DIR)/user_pkg.vhd
	$(CC) $(CFLAGS) $(RTL_DIR)/user_pkg.vhd

$(WORK_DIR)/%.vdb: $(RTL_DIR)/%.$(SRC_EXT)
	@echo "Building Object [$@]..."	
	@mkdir -p $(WORK_DIR)
	$(CC) $(CFLAGS) $<

$(WORK_DIR)/%.vdb: $(TB_DIR)/%.$(SRC_EXT)
	@echo "Building Test [$@]..."	
	@mkdir -p $(WORK_DIR)
	$(CC) $(CFLAGS) $<

sim_gui:
	$(SIM) -gui -nolog top_sim -wdb simulate_xsim.wdb -stats&

viewsim:
	vivado -source load_db.tcl&

.PHONY: clean
clean:
	rm -rf xsim.dir	
	rm -rf .Xil
	find . \( -name "*.log" -o -name "*.pb*" -o -name "*.btree*" -o -name "*.jou*" -o -name "*.wdb*" -o -name "*.str*" \) -delete
