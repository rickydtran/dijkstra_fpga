/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  MAIN DRIVER
**/

#include <cmath>
#include <iomanip>
#include <iostream>
#include "Board.h"
#include "Graph.h"
#include "Timer.h"
#include "dijkstra.h"

#define ADDR_WIDTH 3
#define MAX_SIZE (1 << ADDR_WIDTH)

int main(int argc, char **argv) {
  if (argc != 5) {  // Update to 6 when hw done
    std::cerr << "Usage: " << argv[0]
              << " <runs> <vertices> <cfactor> <mweight> <bitfile>"
              << std::endl;
    return -1;
  }

  // std::vector<float> clocks(Board::NUM_FPGA_CLOCKS);
  // clocks[0] = 100.0;
  // clocks[1] = 0.0;
  // clocks[2] = 0.0;
  // clocks[3] = 0.0;

  // Board *board;
  // try {
  //   board = new Board(argv[1], clocks);
  // } catch (...) {
  //   exit(-1);
  // }

  int runs = atoi(argv[1]);
  int size = atoi(argv[2]);
  double p = atof(argv[3]);
  int max_wt = atoi(argv[4]);

  // unsigned go, done;

  Graph g(size);
  unsigned seed = 194594329;

  g.create_random_graph(seed, p, max_wt);

  int **input = g.get_matrix();

  int *sw_dist_base, *sw_dist_bin, *sw_dist_fib, *hw_dist;
  int *sw_prev_base, *sw_prev_bin, *sw_prev_fib, *hw_prev;
  Timer sw_base_time, sw_bin_time, sw_fib_time, hw_time, read_time, write_time,
      wait_time;

  sw_dist_base = (int *)malloc(size * sizeof(int));
  sw_dist_bin = (int *)malloc(size * sizeof(int));
  sw_dist_fib = (int *)malloc(size * sizeof(int));
  hw_dist = (int *)malloc(size * sizeof(int));

  sw_prev_base = (int *)malloc(size * sizeof(int));
  sw_prev_bin = (int *)malloc(size * sizeof(int));
  sw_prev_fib = (int *)malloc(size * sizeof(int));
  hw_prev = (int *)malloc(size * sizeof(int));

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
  std::cout << "Executing Each Benchmark For " << runs << " Runs" << std::endl;
  for (int i = 0; i < runs; i++) {
    sw_base_time.start();
    dijkstra_sw_base(input, 0, size, sw_dist_base, sw_prev_base);
    sw_base_time.stop();

    sw_bin_time.start();
    dijkstra_sw_bin(&g, 0, sw_dist_bin, sw_prev_bin);
    sw_bin_time.stop();

    sw_fib_time.start();
    dijkstra_sw_fib(&g, 0, sw_dist_fib, sw_prev_fib);
    sw_fib_time.stop();

    // hw_time.start();
    // dijkstra_hw(input, 0, size, sw_dist_base);
    // hw_time.stop();
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

  int derr_bin = 0;
  int perr_bin = 0;
  int derr_fib = 0;
  int perr_fib = 0;
  int derr_hw = 0;
  int perr_hw = 0;

  for (int i = 0; i < size; i++) {
    if (sw_dist_bin[i] != sw_dist_base[i]) {
      derr_bin++;
    }
    if (sw_prev_bin[i] != sw_prev_base[i]) {
      perr_bin++;
    }
  }
  for (int i = 0; i < size; i++) {
    if (sw_dist_fib[i] != sw_dist_base[i]) {
      derr_fib++;
    }
    if (sw_prev_bin[i] != sw_prev_base[i]) {
      perr_fib++;
    }
  }
  for (int i = 0; i < size; i++) {
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
