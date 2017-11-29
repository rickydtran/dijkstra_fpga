#include <cassert>
#include <cmath>
#include <iomanip>
#include <iostream>
#include <vector>
#include "Graph.h"
#include "dijkstra.h"

#define ADDR_WIDTH 10
#define WORD_WIDTH 8
#define MAX_SIZE (1 << ADDR_WIDTH)
#define MAX_WEIGHT (1 << WORD_WIDTH)

int main(int argc, char **argv) {

  unsigned size = atoi(argv[1]);
  assert(size <= MAX_SIZE);
  unsigned src = atoi(argv[2]);
  assert((src >= 0) && (src < MAX_SIZE));
  double p = atof(argv[3]);
  assert(std::islessequal(p, 0.9) && !std::islessequal(p, 0.0));
  unsigned max_wt = atoi(argv[4]);
  assert(max_wt < MAX_WEIGHT);

  unsigned seed = 194594329;
  Graph g(size);
  g.create_random_graph(seed, p, max_wt);

  unsigned *sw_dist_base = (unsigned *)malloc(size * sizeof(unsigned));
  unsigned *sw_prev_base = (unsigned *)malloc(size * sizeof(unsigned));

  unsigned **input = g.get_matrix();

  std::cout << "  type t_2d_a is array(0 to 15, 0 to 15) of integer range 0 to 255;" << std::endl;
  std::cout << "  constant input_key : t_2d_a :="  << std::endl;

  // INPUT SET
  std::cout << "  (";
  for (unsigned i = 0; i < size; i++) {
    std::cout << '(';
    for (unsigned j = 0; j < size; j++) {
      if (i == size - 1 && j == size - 1) {
        std::cout << std::setw(5) << input[i][j] << "));";
      } else if (j == size - 1) {
        std::cout << std::setw(5) << input[i][j] << "),";
      } else {
        std::cout << std::setw(5) << input[i][j] << ", ";
      }
    }
    std::cout << std::endl;
    std::cout << "   ";
  }
  std::cout << std::endl;

  dijkstra_sw_base(input, src, size, sw_dist_base, sw_prev_base);

  std::cout << "  type key is array(0 to 15) of integer;" << std::endl;
  std::cout << "  constant answer_key : key :=" << std::endl;

  //OUTPUT SET
  std::cout << "  ( ";
  for(unsigned i = 0; i < size; i++) {
    unsigned val = (sw_prev_base[i] & 0xF) << 16 | (sw_dist_base[i] & 0xFFFF);
    if(i == size - 1) {
      std::cout << val << " );";
    }
    else {
      std::cout << val << ", ";
    }
  }
  std::cout << std::endl;

  return 0;
}
