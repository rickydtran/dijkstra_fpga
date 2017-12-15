/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  SPECS FOR BOARD ADDR AND WIDTH CONSTANTS
**/

#ifndef _SPECS_H_
#define _SPECS_H_

// #define DO_ARM
#define PRINT_PATH
#define ADDR_WIDTH 6
#define WORD_WIDTH_IN 8
#define WORD_WIDTH_OUT 16
#define MAX_SIZE (1 << ADDR_WIDTH)
#define MAX_WEIGHT (1 << WORD_WIDTH_IN)
#define MAX_DIST (1 << WORD_WIDTH_OUT)
#define MEM_IN_ADDR 0
#define MEM_OUT_ADDR 0
#define GO_ADDR ((1 << MMAP_ADDR_WIDTH) - 5)
#define SIZE_ADDR ((1 << MMAP_ADDR_WIDTH) - 4)
#define MEM_IN_SEL ((1 << MMAP_ADDR_WIDTH) - 3)
#define SRC_ADDR ((1 << MMAP_ADDR_WIDTH) - 2)
#define DONE_ADDR ((1 << MMAP_ADDR_WIDTH) - 1)

#endif
