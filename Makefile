# RICKY TRAN
# DIJKSTRA MAKEFILE

CC := g++
# CC := arm-linux-g++
SRC_DIR := src/sw
BUILD_DIR := build
TARGET := bin/dijkstra

TEST_DIR := test
TBUILD_DIR := test/build
TEST_TARGET := bin/dotest

SRC_EXT := cpp
SRCS := $(shell find $(SRC_DIR) -type f -name *.$(SRC_EXT))
OBJS := $(patsubst $(SRC_DIR)/%, $(BUILD_DIR)/%, $(SRCS:.$(SRC_EXT)=.o))

TESTS := $(shell find $(TEST_DIR) -type f -name *.$(SRC_EXT))
TEST_OBJS := $(filter-out build/main.o, $(OBJS)) $(patsubst $(TEST_DIR)/%, $(TBUILD_DIR)/%, $(TESTS:.$(SRC_EXT)=.o))

CFLAGS := -std=c++11 -O3 -Wall -g
LIB :=
INC := -I include

all: $(TARGET) $(TEST_TARGET)

build: $(TARGET)

test: $(TEST_TARGET)

$(TARGET): $(OBJS)
	@echo "Linking Binaries..."
	@mkdir -p bin	
	@echo "  $(CC) -o $(TARGET) $(OBJS) $(LIB)"; $(CC) -o $(TARGET) $(OBJS) $(LIB)

$(TEST_TARGET): $(TEST_OBJS)
	@echo "Linking Testcases Binaries..."
	@echo "  $(CC) -o $(TEST_TARGET) $(TEST_OBJS) $(LIB)"; $(CC) -o $(TEST_TARGET) $(TEST_OBJS) $(LIB)

$(BUILD_DIR)/%.o: $(SRC_DIR)/%.$(SRC_EXT)
	@echo "Building Object [$@]..."	
	@mkdir -p $(BUILD_DIR)
	@echo "  $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

$(TBUILD_DIR)/%.o: $(TEST_DIR)/%.$(SRC_EXT)
	@echo "Building Testcases [$@]..."	
	@mkdir -p $(TBUILD_DIR)
	@echo "  $(CC) $(CFLAGS) $(INC) -c -o $@ $<"; $(CC) $(CFLAGS) $(INC) -c -o $@ $<

.PHONY: clean
clean:
	@echo "Cleaning...";
	@echo "  $(RM) -r $(BUILD_DIR) $(TARGET)"; $(RM) -r $(BUILD_DIR) $(TARGET)
	@echo "  $(RM) -r $(TBUILD_DIR) $(TEST_TARGET)"; $(RM) -r $(TBUILD_DIR) $(TEST_TARGET)
