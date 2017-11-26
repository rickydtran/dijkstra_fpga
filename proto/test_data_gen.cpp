#include <iostream>
#include <iomanip>
#include <vector>
#include <cassert>
#include <cmath>
#include "Graph.h"

#define ADDR_WIDTH 10
#define WORD_WIDTH 8
#define MAX_SIZE (1 << ADDR_WIDTH)
#define MAX_WEIGHT (1 << WORD_WIDTH)

int main(int argc, char **argv) {
 int size = atoi(argv[1]);
 assert(size <= MAX_SIZE);
 double p = atof(argv[2]);
 assert(std::islessequal(p, 0.9) && !std::islessequal(p, 0.0));
 int max_wt = atoi(argv[3]);
 assert(max_wt < MAX_WEIGHT);
 unsigned seed = 194594329;
 Graph g(size);
 g.create_random_graph(seed, p, max_wt);
 int **input = g.get_matrix();
 std::cout << '(';
 for(int i = 0; i < size; i++) {
  std::cout << '(';
  for(int j = 0; j < size; j++) {
    if(j == (size - 1)) {
      std::cout << std::setw(5) << input[i][j] << "),";
    }
    else {
      std::cout << std::setw(5) << input[i][j] << ", ";
    }
  }
  std::cout << std::endl;
 }
 std::cout << ");" << std::endl;
 return 0;
}

