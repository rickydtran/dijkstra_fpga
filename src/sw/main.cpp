/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  MAIN DRIVER
**/

#include <cassert>
#include <cmath>
#include <iomanip>
#include <iostream>
#include "Board.h"
#include "Graph.h"
#include "Timer.h"
#include "dijkstra.h"

#define PRINT_PATH
#define ADDR_WIDTH 4
#define WORD_WIDTH 16
#define MAX_SIZE   (1 << ADDR_WIDTH)
#define MAX_WEIGHT (1 << WORD_WIDTH)
#define MEM_IN_ADDR  0
#define MEM_OUT_ADDR 0
#define GO_ADDR    ((1 << MMAP_ADDR_WIDTH) - 5)
#define SIZE_ADDR  ((1 << MMAP_ADDR_WIDTH) - 4)
#define MEM_IN_SEL ((1 << MMAP_ADDR_WIDTH) - 3)
#define SRC_ADDR   ((1 << MMAP_ADDR_WIDTH) - 2)
#define DONE_ADDR  ((1 << MMAP_ADDR_WIDTH) - 1)

int main(int argc, char **argv) {
  if (argc != 5) {  // Update to 6 when hw done
    std::cerr << "Usage: " << argv[0]
              << " <runs> <vertices> <cfactor> <mweight> <bitfile>"
              << std::endl;
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

  unsigned runs = atoi(argv[1]);
  assert(runs > 0);
  unsigned size = atoi(argv[2]);
  assert(size <= MAX_SIZE);
  double p = atof(argv[3]);
  unsigned src = 0;
  assert(std::islessequal(p, 0.9) && !std::islessequal(p, 0.0));
  unsigned max_wt = atoi(argv[4]);
  assert(max_wt < MAX_WEIGHT);

  unsigned go, done;

  Graph g(size);
  unsigned seed = 194594329;

  std::cout << std::endl;

  std::cout << "    ____  ____    ____ _________________  ___ " << std::endl;
  std::cout << "   / __ \\/  _/   / / //_/ ___/_  __/ __ \\/   |" << std::endl;
  std::cout << "  / / / // /__  / / ,<  \\__ \\ / / / /_/ / /| |" << std::endl;
  std::cout << " / /_/ // // /_/ / /| |___/ // / / _, _/ ___ |" << std::endl;
  std::cout << "/_____/___/\\____/_/ |_/____//_/ /_/ |_/_/  |_|" << std::endl;
  std::cout << "                        __________  _________ " << std::endl;
  std::cout << "                       / ____/ __ \\/ ____/   |" << std::endl;
  std::cout << "                      / /_  / /_/ / / __/ /| |" << std::endl;
  std::cout << "                     / __/ / ____/ /_/ / ___ |" << std::endl;
  std::cout << "                    /_/   /_/    \\____/_/  |_|" << std::endl;

  std::cout << "Beginning Benchmarks..." << std::endl;
  std::cout << "Generating Data..." << std::endl;
  std::cout << size << " Vertices with connectivity factor of " << p
            << std::endl;

  g.create_random_graph(seed, p, max_wt);

  unsigned **input = g.get_matrix();

  unsigned *sw_dist_base, *sw_dist_bin, *sw_dist_fib, *hw_dist;
  unsigned *sw_prev_base, *sw_prev_bin, *sw_prev_fib, *hw_prev;
  unsigned *hw_output;
  Timer sw_base_time, sw_bin_time, sw_fib_time, hw_time, read_time, write_time,
      wait_time;

  sw_dist_base = (unsigned *)malloc(size * sizeof(unsigned));
  sw_dist_bin = (unsigned *)malloc(size * sizeof(unsigned));
  sw_dist_fib = (unsigned *)malloc(size * sizeof(unsigned));
  hw_dist = (unsigned *)malloc(size * sizeof(unsigned));

  hw_output = (unsigned *)malloc(size * sizeof(unsigned));

  sw_prev_base = (unsigned *)malloc(size * sizeof(unsigned));
  sw_prev_bin = (unsigned *)malloc(size * sizeof(unsigned));
  sw_prev_fib = (unsigned *)malloc(size * sizeof(unsigned));
  hw_prev = (unsigned *)malloc(size * sizeof(unsigned));

  std::cout << "Executing Each Benchmark For " << runs << " Runs" << std::endl;
  for (unsigned i = 0; i < runs; i++) {
    sw_base_time.start();
    dijkstra_sw_base(input, src, size, sw_dist_base, sw_prev_base);
    sw_base_time.stop();
#ifdef PRINT_PATH
    print_solution(sw_dist_base, sw_prev_base, src, size);
#endif

    sw_bin_time.start();
    dijkstra_sw_bin(&g, src, sw_dist_bin, sw_prev_bin);
    sw_bin_time.stop();
#ifdef PRINT_PATH
    print_solution(sw_dist_bin, sw_prev_bin, src, size);
#endif

    sw_fib_time.start();
    dijkstra_sw_fib(&g, src, sw_dist_fib, sw_prev_fib);
    sw_fib_time.stop();
#ifdef PRINT_PATH
    print_solution(sw_dist_fib, sw_prev_fib, src, size);
#endif
    /**
      BEGIN FPGA STUFF
    **/
    // transfer input array and size to FPGA
    hw_time.start();
    write_time.start();
    // board->write(input, MEM_IN_ADDR, size);
    for(unsigned j = 0; j < size; j++) {
      board->write(&j, MEM_IN_SEL, 1);
      board->write(input[j], MEM_IN_ADDR, size);
    }
    write_time.stop();

    unsigned src = 0;
    board->write(&size, SIZE_ADDR, 1);
    board->write(&src, SRC_ADDR, 1);

    // assert go. Note that the memory map automatically sets go back to 1 to
    // avoid an additional transfer.
    go = 1;
    board->write(&go, GO_ADDR, 1);

    // wait for the board to assert done
    wait_time.start();
    done = 0;
    while (!done) {
      board->read(&done, DONE_ADDR, 1);
    }
    wait_time.stop();

    // read the outputs back from the FPGA
    read_time.start();
    board->read(hw_output, MEM_OUT_ADDR, size);
    read_time.stop();
    hw_time.stop();
#ifdef PRINT_PATH
      print_solution(hw_dist, hw_prev, 0, size);
#endif
  }

  for(unsigned i = 0; i < size; i++) {
    hw_prev[i] = hw_output[i] & 0xF0;
    hw_dist[i] = hw_output[i] & 0x0F; 
  }

  double transfer_time = (write_time.elapsedTime() + read_time.elapsedTime());
  double hw_time_no_transfer = (hw_time.elapsedTime() - transfer_time) / runs;
  std::cout << "============AVERAGE EXECUTION TIME============" << std::endl;
  std::cout << "  Dijkstra Base Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << sw_base_time.elapsedTime() / runs
            << " ns" << std::endl;
  std::cout << "    Binary Heap Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << sw_bin_time.elapsedTime() / runs
            << " ns" << std::endl;
  std::cout << " Fibonacci Heap Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << sw_fib_time.elapsedTime() / runs
            << " ns" << std::endl;
  std::cout << "  Dijkstra FPGA Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << hw_time.elapsedTime() / runs
            << " ns" << std::endl;
  std::cout << "   No Transfers Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << hw_time_no_transfer << " ns"
            << std::endl;
  std::cout << "===============AVERAGE SPEEDUP================" << std::endl;
  std::cout << "        Speedup(BIN): " << std::setprecision(5)
            << (sw_base_time.elapsedTime() / runs) /
                   (sw_bin_time.elapsedTime() / runs)
            << std::endl;
  std::cout << "        Speedup(FIB): " << std::setprecision(5)
            << (sw_base_time.elapsedTime() / runs) /
                   (sw_fib_time.elapsedTime() / runs)
            << std::endl;
  std::cout << "        Speedup(F/B): " << std::setprecision(5)
            << (sw_bin_time.elapsedTime() / runs) /
                   (sw_fib_time.elapsedTime() / runs)
            << std::endl;
  std::cout << "     Speedup(HW/BAS): " << std::setprecision(5)
            << (sw_base_time.elapsedTime() / runs) /
                   (hw_time.elapsedTime() / runs)
            << std::endl;
  std::cout << "        No Transfers: " << std::setprecision(5)
            << (sw_base_time.elapsedTime() / runs) / hw_time_no_transfer
            << std::endl;
  std::cout << "     Speedup(HW/BIN): " << std::setprecision(5)
            << (sw_bin_time.elapsedTime() / runs) /
                   (hw_time.elapsedTime() / runs)
            << std::endl;
  std::cout << "        No Transfers: " << std::setprecision(5)
            << (sw_bin_time.elapsedTime() / runs) / hw_time_no_transfer
            << std::endl;
  std::cout << "     Speedup(HW/FIB): " << std::setprecision(5)
            << (sw_fib_time.elapsedTime() / runs) /
                   (hw_time.elapsedTime() / runs)
            << std::endl;
  std::cout << "        No Transfers: " << std::setprecision(5)
            << (sw_fib_time.elapsedTime() / runs) / hw_time_no_transfer
            << std::endl;

  unsigned derr_bin = 0;
  unsigned perr_bin = 0;
  unsigned derr_fib = 0;
  unsigned perr_fib = 0;
  unsigned derr_hw = 0;
  unsigned perr_hw = 0;

  for (unsigned i = 0; i < size; i++) {
    if (sw_dist_bin[i] != sw_dist_base[i]) {
      derr_bin++;
    }
    if (sw_prev_bin[i] != sw_prev_base[i]) {
      perr_bin++;
    }
  }
  for (unsigned i = 0; i < size; i++) {
    if (sw_dist_fib[i] != sw_dist_base[i]) {
      derr_fib++;
    }
    if (sw_prev_bin[i] != sw_prev_base[i]) {
      perr_fib++;
    }
  }
  for (unsigned i = 0; i < size; i++) {
    if (hw_dist[i] != sw_dist_base[i]) {
      derr_hw++;
    }
    if (hw_prev[i] != sw_prev_base[i]) {
      perr_hw++;
    }
  }

  // std::cout << "Error Count: " << derr_bin << std::endl;
  // std::cout << "Error Count: " << perr_bin << std::endl;
  // std::cout << "Error Count: " << derr_fib << std::endl;
  // std::cout << "Error Count: " << perr_fib << std::endl;
  // std::cout << "Error Count: " << derr_hw  << std::endl;
  // std::cout << "Error Count: " << perr_hw  << std::endl;

  const double err_margin = 0.2;  // Could be more than one path with same
                                  // distance. Allow 2% Error Margin
  std::cout << "=================CHECK WORK===================" << std::endl;
  std::cout << "BIN MINHEAP DIST CHECK: ";
  if (!derr_bin)
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << derr_bin << std::endl;
  std::cout << "BIN MINHEAP PREV CHECK: ";
  if (std::islessequal((double)perr_bin / size, err_margin))
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << perr_bin << std::endl;
  std::cout << "FIB MINHEAP DIST CHECK: ";
  if (!derr_fib)
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << derr_fib << std::endl;
  std::cout << "FIB MINHEAP PREV CHECK: ";
  if (std::islessequal((double)perr_fib / size, err_margin))
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << perr_fib << std::endl;
  std::cout << "DIJ HW FPGA DIST CHECK: ";
  if (!derr_hw)
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << derr_hw << std::endl;
  std::cout << "DIJ HW FPGA PREV CHECK: ";
  if (std::islessequal((double)perr_hw / size, err_margin))
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << perr_hw << std::endl;
  std::cout << std::endl;

  delete[] input;
  free(sw_dist_base);
  free(sw_dist_bin);
  free(sw_dist_fib);
  free(hw_dist);

  free(sw_prev_base);
  free(sw_prev_bin);
  free(sw_prev_fib);
  free(hw_prev);

  // delete board;

  return 0;
}
