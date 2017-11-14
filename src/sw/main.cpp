#include <iostream>
#include "Board.h"
#include "Graph.h"
#include "Timer.h"

// #define MAX_SIZE (1<<ADDR_WIDTH)

int main(int argc, char **argv) {
  if (argc != 2) {
    return -1;
  }

  std::vector<float> clocks(Board::NUM_FPGA_CLOCKS);
  clocks[0] = 100.0;
  clocks[1] = 0.0;
  clocks[2] = 0.0;
  clocks[3] = 0.0;

  Board *board;
  try {
    board = new Board(argv[1], clocks);
  } catch (...) {
    exit(-1);
  }

  unsigned size = MAX_SIZE;

  unsigned go, done;
  unsigned *input, *sw_output, *hw_output;
  Timer sw_time, hw_time, read_time, write_time, wait_time;

  input = new unsigned[size];
  sw_output = new unsigned[size];
  hw_output = new unsigned[size];


  delete[] input;
  delete[] sw_output;
  delete[] hw_output;

  return 0;

}
