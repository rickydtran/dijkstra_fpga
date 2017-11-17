#include <iostream>
#include "Graph.h"
#include "MinHeap.h"
#include "catch.hpp"

TEST_CASE("MinHeap Test", "[MinHeap]") {
  MinHeap h(6);

  h.insertKey(0, 45);
  h.insertKey(1, 3);
  h.insertKey(2, 2);
  h.insertKey(3, 15);
  h.insertKey(4, 5);
  h.insertKey(5, 4);
  h.decreaseKey(0, 0);
  h.decreaseKey(3, 1);
  
  // h.printPos();

  while(!h.isEmpty()) {
    std::pair<int, int> p = h.extractMin();
    // std::cout << p.first << ' ' << p.second << std::endl;
  }
}