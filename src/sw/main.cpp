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

#define DO_ARM
// #define PRINT_PATH
#define ADDR_WIDTH 9
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

int main(int argc, char **argv) {
#ifdef DO_ARM
  if (argc != 7) {
    std::cerr << "Usage: " << argv[0]
              << " <runs> <vertices> <src> <cfactor> <mweight> <bitfile>"
              << std::endl;
    return -1;
  }
#endif

  unsigned runs = atoi(argv[1]);
  assert(runs > 0);
  unsigned size = atoi(argv[2]);
  assert(size <= MAX_SIZE);
  unsigned src = atoi(argv[3]);
  assert((src >= 0) && (src < MAX_SIZE));
  double p = atof(argv[4]);
  assert(std::islessequal(p, 0.9) && !std::islessequal(p, 0.0));
  unsigned max_wt = atoi(argv[5]);
  assert(max_wt < MAX_WEIGHT);

#ifdef DO_ARM
  std::vector<float> clocks(Board::NUM_FPGA_CLOCKS);
  clocks[0] = 100.0;
  clocks[1] = 0.0;
  clocks[2] = 0.0;
  clocks[3] = 0.0;

  Board *board;
  try {
    board = new Board(argv[6], clocks);
  } catch (...) {
    exit(-1);
  }
  unsigned go, done;
#endif

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

  std::cout << "Number of Edges: " << g.num_of_edges() / 2 << std::endl;

  unsigned **input = g.get_matrix();
  unsigned **hw_input = g.create_hw_matrix(input);

  unsigned *sw_dist_base, *sw_dist_bin, *sw_dist_fib;
  unsigned *sw_prev_base, *sw_prev_bin, *sw_prev_fib;
#ifdef DO_ARM
  unsigned *hw_output, *hw_dist, *hw_prev;
#endif
  Timer sw_base_time, sw_bin_time, sw_fib_time, hw_time, read_time, write_time,
      wait_time;

  sw_dist_base = (unsigned *)malloc(size * sizeof(unsigned));
  sw_dist_bin = (unsigned *)malloc(size * sizeof(unsigned));
  sw_dist_fib = (unsigned *)malloc(size * sizeof(unsigned));

  sw_prev_base = (unsigned *)malloc(size * sizeof(unsigned));
  sw_prev_bin = (unsigned *)malloc(size * sizeof(unsigned));
  sw_prev_fib = (unsigned *)malloc(size * sizeof(unsigned));

#ifdef DO_ARM
  hw_output = (unsigned *)malloc(size * sizeof(unsigned));
  hw_dist = (unsigned *)malloc(size * sizeof(unsigned));
  hw_prev = (unsigned *)malloc(size * sizeof(unsigned));
#endif

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

#ifdef DO_ARM
    /**
      BEGIN FPGA STUFF
    **/
    // transfer input array and size to FPGA
    hw_time.start();
    write_time.start();
    // board->write(input, MEM_IN_ADDR, size);
    for (unsigned j = 0; j < size / 4; j++) {
      board->write(&j, MEM_IN_SEL, 1);
      board->write(hw_input[j], MEM_IN_ADDR, size);
    }
    write_time.stop();

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

    for (unsigned j = 0; j < size; j++) {
      hw_prev[j] = (hw_output[j] >> WORD_WIDTH_OUT) & (MAX_SIZE - 1);
      hw_dist[j] = hw_output[j] & (MAX_DIST - 1);
    }

#ifdef PRINT_PATH
    print_solution(hw_dist, hw_prev, src, size);
#endif

#endif
  }

    // for(unsigned i = 0; i < size; i++) {
    //   std::cout << sw_dist_base[i] << ' ';
    // }
    // std::cout << std::endl;
    // for(unsigned i = 0; i < size; i++) {
    //   std::cout << sw_prev_base[i] << ' ';
    // }
    // std::cout << std::endl;
    // for(unsigned i = 0; i < size; i++) {
    //   std::cout << hw_dist[i] << ' ';
    // }
    // std::cout << std::endl;
    // for(unsigned i = 0; i < size; i++) {
    //   std::cout << hw_prev[i] << ' ';
    // }
    // std::cout << std::endl;
#ifdef DO_ARM
  double transfer_time = (write_time.elapsedTime() + read_time.elapsedTime());
  double hw_time_no_transfer = (hw_time.elapsedTime() - transfer_time) / runs;
#endif
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
#ifdef DO_ARM
  std::cout << "  Dijkstra FPGA Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << hw_time.elapsedTime() / runs
            << " ns" << std::endl;
  std::cout << "   No Transfers Time: " << std::fixed << std::setprecision(1)
            << std::setw(9) << std::right << hw_time_no_transfer << " ns"
            << std::endl;
#endif
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
#ifdef DO_ARM
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
#endif

  unsigned derr_bin = 0;
  unsigned perr_bin = 0;
  unsigned derr_fib = 0;
  unsigned perr_fib = 0;

#ifdef DO_ARM
  unsigned derr_hw = 0;
  unsigned perr_hw = 0;
#endif

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
#ifdef DO_ARM
  for (unsigned i = 0; i < size; i++) {
    if (hw_dist[i] != sw_dist_base[i]) {
      derr_hw++;
    }
    if (hw_prev[i] != sw_prev_base[i]) {
      perr_hw++;
    }
  }
#endif

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

#ifdef DO_ARM
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
#endif
  std::cout << std::endl;

  /**
    TEST MATRIX POINTER
    MANIPULATION
  **/
  // for(unsigned i = 0; i < size; i++) {
  //   for(unsigned j = 0; j < size; j++) {
  //     std::cout << std::setw(5) << input[i][j] << ' ';
  //   }
  //   std::cout << std::endl;
  // }
  // std::cout << std::endl;

  // for(unsigned i = 0; i < size; i++) {
  //   for(unsigned j = 0; j < size; j+=4) {
  //     // std::cout << std::setw(5) << *(input[i]+j) << ' ';
  //     auto k = (input[i]+j);
  //     for(int count = 0; count < 4; count++) {
  //       std::cout << std::setw(5) << *k++ << ' ';
  //     }
  //   }
  //   std::cout << std::endl;
  // }
  // std::cout << std::endl;

  delete[] input;
  delete[] hw_input;
  free(sw_dist_base);
  free(sw_dist_bin);
  free(sw_dist_fib);

  free(sw_prev_base);
  free(sw_prev_bin);
  free(sw_prev_fib);

#ifdef DO_ARM
  free(hw_dist);
  free(hw_prev);
  delete board;
#endif

  return 0;
}
