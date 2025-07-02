# VIC-20 dead test Makefile
#
# Copyright (C) 2025 Piers Finlayson <piers@piers.rocks>
#
# Creates 3 version of the dead test program:
# - `build/dead-test.a0` (original cartridge version)
# - `build/dead-test.pal.e0` (PAL KERNAL version)
# - `build/dead-test.ntsc.e0` (NTSC KERNAL version)
#
# Example usage:
# XA65=/path/to/xa65 make all
#
# Dependencies:
# - `xa65` assembler must be downloaded and built
#
# To download and build xa65:
# ```bash
# git clone https://github.com/fachat/xa65
# cd xa65/xa
# make  # Produces `xa` binary in the current directory
# ```

# Path to xa65 - can be overridden with make XA65=/path/to/xa65
XA65 ?= xa

# Build directory
BUILD_DIR = build

# Output files
TARGETS = $(BUILD_DIR)/dead-test.a0 $(BUILD_DIR)/dead-test.pal.e0 $(BUILD_DIR)/dead-test.ntsc.e0 $(BUILD_DIR)/dead-test.crt

# Default target builds all versions
all: $(TARGETS)

# Create build directory
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Cartridge version as binary
$(BUILD_DIR)/dead-test.a0: dead-test.asm Makefile | $(BUILD_DIR)
	$(XA65) -o $@ dead-test.asm

# Cartridge version as CRT file
$(BUILD_DIR)/dead-test.crt: $(BUILD_DIR)/dead-test.a0 Makefile | $(BUILD_DIR)
	@printf 'VIC20 CARTRIDGE \000\000\000\100\002\000\000\000\000\000\000\000\000\000\000\000' > $@
	@printf 'VIC20 DEAD TEST\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000' >> $@
	@printf 'CHIP\000\000\020\020\000\000\000\000\240\000\020\000' >> $@
	@cat $< >> $@
	@echo "Cartridge file created: $@"

# PAL KERNAL version  
$(BUILD_DIR)/dead-test.pal.e0: dead-test.asm Makefile | $(BUILD_DIR)
	$(XA65) -DKERNAL_ROM=1 -DPAL_VER=1 -o $@ dead-test.asm

# NTSC KERNAL version
$(BUILD_DIR)/dead-test.ntsc.e0: dead-test.asm Makefile | $(BUILD_DIR)
	$(XA65) -DKERNAL_ROM=1 -DNTSC_VER=1 -o $@ dead-test.asm

# Clean up generated files
clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean