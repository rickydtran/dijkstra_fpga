// A C++ program to demonstrate common Binary Heap Operations
#include <iostream>
#include <limits.h>
// #include "fiboqueue.h"
// #include "fibonacci.hpp"
#include "fiboqueue.hpp"

// Driver program to test above functions
int main() {

    int val[6] = { 45, 3, 2, 15, 5, 4 };
    int test[6] = { 0, 1, 2, 3, 4, 5 };

    FibQueue<int, int> fq;
    // fq.push(2, x);
    // fq.push(7, x);
    for(int i = 0; i < 6; i++) {
        fq.push(val[i], test[i]);
    }
    // fq.push(45, 0);

    auto node0 = fq.findNode(0);
    auto node3 = fq.findNode(3);

    fq.decrease_key(node0, 0);
    fq.decrease_key(node3, 1);

    // FibHeap<int>::FibNode *x = fq.findNode(0);
    // FibHeap<int>::FibNode *y = fq.findNode(3);    
    // std::cout << z->key << std::endl;
    // fq.decrease_key(x, 0);
    // fq.decrease_key(y, 1);

    while(!fq.isEmpty()) {
      auto node_t = fq.pop();  
      std::cout <<  node_t.data() << ' ' << node_t.key() << std::endl;    
    }
  // fibonacci_heap<int, int> fh;
  // auto node0 = fh.insert(45, 0);
  // fh.insert(3, 1);
  // fh.insert(2, 2);
  // auto node3 = fh.insert(15, 3);
  // fh.insert(5, 4);
  // fh.insert(4, 5);
  // fh.decrease_key(node0, 0);
  // fh.decrease_key(node3, 1);
  // while(fh.size()) {
  //   auto node_t = fh.remove();  
  //   std::cout <<  node_t.data() << ' ' << node_t.key() << std::endl;    
  // }
  return 0;
}

  // h.insertKey(0, 45);
  // h.insertKey(1, 3);
  // h.insertKey(2, 2);
  // h.insertKey(3, 15);
  // h.insertKey(4, 5);
  // h.insertKey(5, 4);
  // h.decreaseKey(0, 0);
  // h.decreaseKey(3, 1);
