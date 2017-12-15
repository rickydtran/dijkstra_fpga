#include <iostream>
#include <vector>
#include "Graph.h"

void create_dot_script(unsigned v, unsigned seed, double p, unsigned max_wt) {
 Graph g(v);
 g.create_random_graph(seed, p, max_wt);
 std::cout << "digraph graphname { concentrate=true ";
 for(unsigned i = 0; i < v; i++) {
  std::vector<std::pair<unsigned, unsigned>> adj = g.get_adj_list(i);
  for(auto it = adj.begin(); it != adj.end(); ++it) {
    std::cout <<' ' << i << "->" << it->first << " [dir=\"both\"]; ";
  }
 }
 std::cout << "}" << std::endl;

}

int main(int argc, char **argv) {
 unsigned seed = 194594329;
 create_dot_script(10, seed, 0.1, 255);
 create_dot_script(10, seed, 0.3, 255);
 create_dot_script(10, seed, 0.5, 255);
 create_dot_script(10, seed, 0.7, 255);
 create_dot_script(10, seed, 0.9, 255);
 return 0;
}

