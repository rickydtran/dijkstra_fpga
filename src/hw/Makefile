# RICKY TRAN
# VIVADO MAKEFILE

all: clean
	@echo "Creating Full System..."
	vivado -nolog -nojournal -mode batch -source scripts/build.tcl

build: clean
	@echo "Creating Base System..."
	vivado -nolog -nojournal -mode batch -source scripts/base_system.tcl

vivado:
	vivado -nolog -nojournal&

link:
	@echo "Linking IP to Base System..."
	vivado -nolog -nojournal -mode batch -source scripts/link_ip.tcl

update:
	@echo "Updating IP..."
	vivado -nolog -nojournal -mode batch -source scripts/update_ip.tcl

bit:
	@echo "Starting Syn, Impl, and Creating Bitstream..."
	vivado -nolog -nojournal -mode batch -source scripts/bitstream.tcl

.PHONY: clean
clean:
	@echo "Cleaning..."
	rm -rf dijkstra_fpga