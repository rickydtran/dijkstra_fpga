#include <iostream>
#include "Graph.h"
#include "catch.hpp"
#include "dijkstra.h"

TEST_CASE("dijkstra matrix test", "[adj_matrix]") {
  unsigned size = 9;

  int dist_key[9] = {0, 4, 12, 19, 21, 11, 9, 8, 14};
  int path_key[9] = {-1, 0, 1, 2, 5, 6, 7, 0, 2};

  Graph g(size);
  g.add_edge(0, 1, 4);
  g.add_edge(0, 7, 8);
  g.add_edge(1, 2, 8);
  g.add_edge(1, 7, 11);
  g.add_edge(2, 3, 7);
  g.add_edge(2, 8, 2);
  g.add_edge(2, 5, 4);
  g.add_edge(3, 4, 9);
  g.add_edge(3, 5, 14);
  g.add_edge(4, 5, 10);
  g.add_edge(5, 6, 2);
  g.add_edge(6, 7, 1);
  g.add_edge(6, 8, 6);
  g.add_edge(7, 8, 7);

  unsigned **input = g.get_matrix();
  int *dist = new int[size];
  int *parent = new int[size];

  dijkstra_sw_matrix(input, 0, size, dist, parent);

  for (int i = 0; i < size; i++) {
    REQUIRE(dist[i] == dist_key[i]);
  }

  for (int i = 0; i < size; i++) {
    REQUIRE(parent[i] == path_key[i]);
  }
}

TEST_CASE("dijkstra adj list test", "[adj_list]") {
  unsigned size = 9;

  int dist_key[9] = {0, 4, 12, 19, 21, 11, 9, 8, 14};
  int path_key[9] = {-1, 0, 1, 2, 5, 6, 7, 0, 2};

  Graph g(9);

  g.add_edge(0, 1, 4);
  g.add_edge(0, 7, 8);
  g.add_edge(1, 2, 8);
  g.add_edge(1, 7, 11);
  g.add_edge(2, 3, 7);
  g.add_edge(2, 8, 2);
  g.add_edge(2, 5, 4);
  g.add_edge(3, 4, 9);
  g.add_edge(3, 5, 14);
  g.add_edge(4, 5, 10);
  g.add_edge(5, 6, 2);
  g.add_edge(6, 7, 1);
  g.add_edge(6, 8, 6);
  g.add_edge(7, 8, 7);

  int *dist = new int[size];
  int *parent = new int[size];

  dijkstra_sw_adj_list(&g, 0, dist, parent);
  // print_solution(dist, parent, 0, size);
  // print_solution(dist_key, path_key, 0, size);

  for (int i = 0; i < size; i++) {
    REQUIRE(dist[i] == dist_key[i]);
  }

  for (int i = 0; i < size; i++) {
    REQUIRE(parent[i] == path_key[i]);
  }
}

TEST_CASE("data gen w/ dijk", "[data_dijk]") {
  for (int i = 10; i < 32; i++) {
    unsigned size = i;

    Graph g(size);
    unsigned seed = 194594329;
    double p;

    p = 0.1;
    g.create_random_graph(seed, p);
    // REQUIRE(g.num_of_edges() == size * size * p);

    unsigned **input = g.get_matrix();
    int *dist_mat = new int[size];
    int *par_mat = new int[size];
    int *dist_list = new int[size];
    int *par_list = new int[size];

    dijkstra_sw_matrix(input, 0, size, dist_mat, par_mat);
    dijkstra_sw_adj_list(&g, 0, dist_list, par_list);
    // print_solution(dist_mat, par_mat, 0, size);
    // print_solution(dist_list, par_list, 0, size);
    // g.print_graph();

    for (int i = 0; i < size; i++) {
      REQUIRE(dist_mat[i] == dist_list[i]);
      REQUIRE(par_mat[i] == par_list[i]);
    }
  }
}
