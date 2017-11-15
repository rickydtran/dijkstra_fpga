#include <iostream>
#include "Board.h"
#include "Graph.h"
#include "Timer.h"
#include "dijkstra.h"

#define ADDR_WIDTH 3
#define MAX_SIZE (1 << ADDR_WIDTH)

int main(int argc, char **argv) {
  // if (argc != 2) {
  //   return -1;
  // }

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

  unsigned size = 500;
  // unsigned go, done;

  Graph g(size);
  unsigned seed = 123;
  double p;

  p = 0.1;
  g.create_random_graph(seed, p);

  unsigned **input = g.get_matrix();

  int *sw_dist_matrix, *sw_dist_list, *sw_par_matrix, *sw_par_list;
  Timer sw_matrix_time, sw_list_time;

  sw_dist_matrix = new int[size];
  sw_dist_list = new int[size];
  sw_par_matrix = new int[size];
  sw_par_list = new int[size];

  sw_list_time.start();
  dijkstra_sw_adj_list(&g, 0, sw_dist_list, sw_par_list);
  sw_list_time.stop();

  sw_matrix_time.start();
  dijkstra_sw_matrix(input, 0, size, sw_dist_matrix, sw_par_matrix);
  sw_matrix_time.stop();

  std::cout << "Matrix Time: " << sw_matrix_time.elapsedTime() << std::endl;
  std::cout << "List Time: " << sw_list_time.elapsedTime() << std::endl;
  std::cout << "Speedup: "
            << sw_matrix_time.elapsedTime() / sw_list_time.elapsedTime()
            << std::endl;

  delete[] input;
  delete[] sw_dist_matrix;
  delete[] sw_dist_list;
  delete[] sw_par_matrix;
  delete[] sw_par_list;
  // delete board;

  return 0;
}
