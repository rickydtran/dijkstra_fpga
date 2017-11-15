#ifndef _GRAPH_H_
#define _GRAPH_H_

#include <set>
#include <vector>

class Graph {
 public:
  Graph(unsigned V);
  ~Graph();
  unsigned size() const;
  unsigned num_of_edges();
  void add_edge(unsigned u, unsigned v, unsigned wt);
  void create_random_graph(unsigned seed, double p);
  void create_spanning_tree(std::set<std::pair<int, int>> &c, unsigned seed);
  int get_weight(unsigned i, unsigned j) const;
  void print_graph();
  unsigned **get_matrix();
  std::vector<std::pair<int, int>> get_adj_list(int i) const;

 private:
  unsigned V;
  std::vector<std::pair<int, int>> *adj;
};

#endif
