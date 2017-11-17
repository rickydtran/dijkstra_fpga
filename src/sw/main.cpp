/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  MAIN DRIVER
**/

#include <iostream>
#include "Board.h"
#include "Graph.h"
#include "Timer.h"
#include "dijkstra.h"

#define ADDR_WIDTH 3
#define MAX_SIZE (1 << ADDR_WIDTH)

int main(int argc, char **argv) {
  if (argc != 3) {  // Update to 4 when hw done
    std::cerr << "Usage: " << argv[0] << " <vertices> <cfactor> <bitfile>"
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

  int size = atoi(argv[1]);
  double p = atof(argv[2]);
  // unsigned go, done;

  Graph g(size);
  unsigned seed = 194594329;

  g.create_random_graph(seed, p);

  int **input = g.get_matrix();

  int *sw_dist_base, *sw_dist_bin, *sw_dist_fib, *hw_dist;
  Timer sw_base_time, sw_bin_time, sw_fib_time, hw_time, read_time, write_time,
      wait_time;

  sw_dist_base = new int[size];
  sw_dist_bin = new int[size];
  sw_dist_fib = new int[size];
  hw_dist = new int[size];

  sw_base_time.start();
  dijkstra_sw_base(input, 0, size, sw_dist_base);
  sw_base_time.stop();

  sw_bin_time.start();
  dijkstra_sw_bin(&g, 0, sw_dist_bin);
  sw_bin_time.stop();

  sw_fib_time.start();
  dijkstra_sw_fib(&g, 0, sw_dist_fib);
  sw_fib_time.stop();

  // hw_time.start();
  // dijkstra_hw(input, 0, size, sw_dist_base);
  // hw_time.stop();

  double transfer_time = write_time.elapsedTime() + read_time.elapsedTime();
  double hw_time_no_transfer = hw_time.elapsedTime() - transfer_time;

  std::cout << " Dijkstra Base Time: " << sw_base_time.elapsedTime()
            << std::endl;
  std::cout << "   Binary Heap Time: " << sw_bin_time.elapsedTime()
            << std::endl;
  std::cout << "Fibonacci Heap Time: " << sw_fib_time.elapsedTime()
            << std::endl;
  std::cout << " Dijkstra FPGA Time: " << hw_time.elapsedTime() << std::endl;
  std::cout << "  No Transfers Time: " << hw_time_no_transfer << std::endl;
  std::cout << std::endl;
  std::cout << "       Speedup(BIN): "
            << sw_base_time.elapsedTime() / sw_bin_time.elapsedTime()
            << std::endl;
  std::cout << "       Speedup(FIB): "
            << sw_base_time.elapsedTime() / sw_fib_time.elapsedTime()
            << std::endl;
  std::cout << "       Speedup(F/B): "
            << sw_bin_time.elapsedTime() / sw_fib_time.elapsedTime()
            << std::endl;
  std::cout << "    Speedup(HW/BAS): "
            << sw_base_time.elapsedTime() / hw_time.elapsedTime() << std::endl;
  std::cout << "       No Transfers: "
            << sw_base_time.elapsedTime() / hw_time_no_transfer << std::endl;
  std::cout << "    Speedup(HW/BIN): "
            << sw_bin_time.elapsedTime() / hw_time.elapsedTime() << std::endl;
  std::cout << "       No Transfers: "
            << sw_bin_time.elapsedTime() / hw_time_no_transfer << std::endl;
  std::cout << "    Speedup(HW/FIB): "
            << sw_fib_time.elapsedTime() / hw_time.elapsedTime() << std::endl;
  std::cout << "       No Transfers: "
            << sw_fib_time.elapsedTime() / hw_time_no_transfer << std::endl;

  int derr_bin = 0;
  int derr_fib = 0;
  int derr_hw = 0;

  for (int i = 0; i < size; i++) {
    if (sw_dist_bin[i] != sw_dist_base[i]) {
      derr_bin++;
    }
  }
  for (int i = 0; i < size; i++) {
    if (sw_dist_fib[i] != sw_dist_base[i]) {
      derr_fib++;
    }
  }
  for (int i = 0; i < size; i++) {
    if (hw_dist[i] != sw_dist_base[i]) {
      derr_hw++;
    }
  }

  std::cout << "\nBIN MINHEAP DIST CHECK: ";
  if (!derr_bin)
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << derr_bin << std::endl;
  std::cout << "FIB MINHEAP DIST CHECK: ";
  if (!derr_fib)
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << derr_fib << std::endl;
  std::cout << "DIJ HW FPGA DIST CHECK: ";
  if (!derr_hw)
    std::cout << "PASS!\n";
  else
    std::cout << "FAIL!\nError count: " << derr_hw << std::endl;

  delete[] input;
  delete[] sw_dist_base;
  delete[] sw_dist_bin;
  delete[] sw_dist_fib;
  delete[] hw_dist;
  // delete board;

  return 0;
}
