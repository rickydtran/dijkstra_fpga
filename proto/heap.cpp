// A C++ program to demonstrate common Binary Heap Operations
#include <iostream>
#include <limits.h>
#include "fiboqueue.h"

// Driver program to test above functions
int main() {

    int val[6] = { 45, 3, 2, 15, 5, 4 };
    int test[6] = { 0, 1, 2, 3, 4, 5 };

    FibQueue<int> fq;
    // fq.push(2, x);
    // fq.push(7, x);
    for(int i = 0; i < 6; i++) {
        fq.push(val[i], &test[i]);
    }

    FibHeap<int>::FibNode *x = fq.findNode(0);
    FibHeap<int>::FibNode *y = fq.findNode(3);    
    // std::cout << z->key << std::endl;
    fq.decrease_key(x, 0);
    fq.decrease_key(y, 1);

    while(!fq.empty()) {
        std::cout << *(int*)fq.topNode()->payload << ' ' <<  fq.topNode()->key << std::endl;
        fq.pop();
    }
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
