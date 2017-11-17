#include "MinHeap.h"
#include <limits.h>
#include <iostream>

MinHeap::MinHeap(unsigned V) {
  this->cap = V;
  this->size = 0;
  this->heap = new std::pair<int, int>[V];
  this->pos = new int[V];
}

MinHeap::~MinHeap() {
  delete[] this->heap;
  delete[] this->pos;
}

bool MinHeap::isInMinHeap(int v) {
  if (pos[v] < size) return true;
  return false;
}

int MinHeap::parent(int v) const { return (v - 1) / 2; }
int MinHeap::left(int v) const { return (2 * v + 1); }
int MinHeap::right(int v) const { return (2 * v + 2); }

bool MinHeap::isEmpty() {
  if (size == 0) return true;
  return false;
}

void MinHeap::insertKey(int v, int w) {
  std::pair<int, int> p = std::make_pair(v, w);
  if (size == cap) {
    return;
  }
  int i = size;
  heap[i] = p;
  pos[v] = i;
  size++;
  while (i && heap[parent(i)].second > heap[i].second) {
    pos[heap[i].first] = parent(i);
    pos[heap[parent(i)].first] = i;
    swap(heap[i], heap[parent(i)]);
    i = parent(i);
  }
}

void MinHeap::decreaseKey(int v, int new_val) {
  heap[pos[v]].second = new_val;
  int i = pos[v];
  while (i && heap[parent(i)].second > heap[i].second) {
    pos[heap[i].first] = parent(i);
    pos[heap[parent(i)].first] = i;
    swap(heap[i], heap[parent(i)]);
    i = parent(i);
  }
}

void MinHeap::MinHeapify(int v) {
  int l = left(v);
  int r = right(v);
  int min = v;
  if (l < size && heap[l].second < heap[min].second) {
    min = l;
  }
  if (r < size && heap[r].second < heap[min].second) {
    min = r;
  }
  if (min != v) {
    pos[heap[v].first] = min;
    pos[heap[min].first] = v;
    swap(heap[v], heap[min]);
    MinHeapify(min);
  }
}

std::pair<int, int> MinHeap::extractMin() {
  if (isEmpty()) {
    return std::make_pair(INT_MAX, INT_MAX);
  }
  if (size == 1) {
    size--;
    return heap[0];
  }
  std::pair<int, int> root = heap[0];
  heap[0] = heap[size - 1];
  pos[heap[0].first] = 0;
  size--;
  MinHeapify(0);
  return root;
}

void MinHeap::printPos() {
  for (int i = 0; i < size; i++) {
    std::cout << pos[i] << ' ' << std::endl;
  }
}

void swap(std::pair<int, int> &x, std::pair<int, int> &y) {
  std::pair<int, int> temp = x;
  x = y;
  y = temp;
}