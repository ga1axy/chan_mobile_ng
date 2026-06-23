# Compiler settings
CC = gcc

# Compiler flags
# -O2: Enable code optimization
# -fPIC & --shared: Required for building an Asterisk shared object module (.so)
CFLAGS = -O2 --shared -fPIC -D_GNU_SOURCE -D AST_MODULE_SELF_SYM=__internal_chan_mobile_so -DAST_MODULE=\"chan_mobile\"

# Header file include paths
INCLUDES = -I../include -I/usr/include

# External libraries to link (BlueZ bluetooth and SBC audio codec)
LIBS = -lbluetooth -lsbc

# Target output module and source files
TARGET = chan_mobile.so
SRCS = chan_mobile.c

# Default installation directory for Asterisk modules
# (Can be overridden from the command line if needed, e.g., MODULES_DIR=/usr/lib64/asterisk/modules)
MODULES_DIR ?= /usr/lib/asterisk/modules

# Declare phony targets to prevent conflicts with actual files named 'all', 'clean', or 'install'
.PHONY: all clean install

# Default target to build the module
all: $(TARGET)

# Compilation rule (Note: the command line must start with a Tab character)
$(TARGET): $(SRCS)
	$(CC) $(CFLAGS) $(INCLUDES) -o $(TARGET) $(SRCS) $(LIBS)

# Installation rule: creates the target directory if it doesn't exist and copies the module
install: $(TARGET)
	mkdir -p $(MODULES_DIR)
	install -m 755 $(TARGET) $(MODULES_DIR)
	@echo "=========================================================="
	@echo " Module successfully installed to: $(MODULES_DIR)/$(TARGET)"
	@echo " Please run 'module reload chan_mobile.so' in Asterisk CLI."
	@echo "=========================================================="

# Cleanup rule to remove the compiled binary
clean:
	rm -f $(TARGET)