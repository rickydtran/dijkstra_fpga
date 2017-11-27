/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  DIJKSTRA TESTCASES FOR CATCHV2
**/

#include <iostream>
#include "Graph.h"
#include "catch.hpp"
#include "dijkstra.h"

TEST_CASE("dijkstra base test", "[base]") {
  unsigned size = 9;

  unsigned dist_key[9] = {0, 4, 12, 19, 21, 11, 9, 8, 14};

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
  unsigned *dist = new unsigned[size];
  unsigned *prev = new unsigned[size];

  dijkstra_sw_base(input, 0, size, dist, prev);

  for (unsigned i = 0; i < size; i++) {
    REQUIRE(dist[i] == dist_key[i]);
  }
}

TEST_CASE("dijkstra bin minheap test", "[bin_heap]") {
  unsigned size = 9;

  unsigned dist_key[9] = {0, 4, 12, 19, 21, 11, 9, 8, 14};

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

  unsigned *dist = new unsigned[size];
  unsigned *prev = new unsigned[size];

  dijkstra_sw_bin(&g, 0, dist, prev);

  for (unsigned i = 0; i < size; i++) {
    REQUIRE(dist[i] == dist_key[i]);
  }
}

TEST_CASE("dijkstra fib minheap test", "[fib_heap]") {
  unsigned size = 9;

  unsigned dist_key[9] = {0, 4, 12, 19, 21, 11, 9, 8, 14};

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

  unsigned *dist = new unsigned[size];
  unsigned *prev = new unsigned[size];

  dijkstra_sw_fib(&g, 0, dist, prev);

  for (unsigned i = 0; i < size; i++) {
    REQUIRE(dist[i] == dist_key[i]);
  }
}

TEST_CASE("data gen w/ dijk", "[data_dijk]") {
  for (unsigned i = 10; i < 256; i++) {
    unsigned size = i;
    Graph g(size);
    unsigned seed = 194594329;
    double p;

    p = 0.45;
    g.create_random_graph(seed, p, 255);

    unsigned **input = g.get_matrix();
    unsigned *dist_base = new unsigned[size];
    unsigned *dist_bin = new unsigned[size];

    unsigned *prev_base = new unsigned[size];
    unsigned *prev_bin = new unsigned[size];

    dijkstra_sw_base(input, 0, size, dist_base, prev_base);
    dijkstra_sw_bin(&g, 0, dist_bin, prev_bin);

    for (unsigned i = 0; i < size; i++) {
      REQUIRE(dist_base[i] == dist_bin[i]);
      // REQUIRE(prev_base[i] == prev_bin[i]);
    }
  }
}
