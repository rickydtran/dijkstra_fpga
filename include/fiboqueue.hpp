/**
  RICKY TRAN
  UNIVERSITY OF FLORIDA
  FIBOQUEUE INHERITANCE
**/

#ifndef FIBOQUEUE_HPP_
#define FIBOQUEUE_HPP_

#include <algorithm>
#include <unordered_map>
#include <utility>
#include "fibonacci.hpp"

template <typename K, typename T, typename Compare = std::less<K>>
class FibQueue : public fibonacci_heap<K, T, Compare> {
 public:
  FibQueue() : fibonacci_heap<K, T, Compare>(){};
  ~FibQueue() {}
  void decrease_key(typename fibonacci_heap<K, T, Compare>::node n, K new_key) {
    typename std::unordered_map<
        T, typename fibonacci_heap<K, T, Compare>::node>::iterator it =
        fstore.find(n.data());
    fibonacci_heap<K, T, Compare>::decrease_key(it->second, new_key);
  }
  typename fibonacci_heap<K, T, Compare>::node push(K key, const T &data) {
    typename fibonacci_heap<K, T, Compare>::node temp =
        fibonacci_heap<K, T, Compare>::insert(key, data);
    fstore.insert(
        std::pair<T, typename fibonacci_heap<K, T, Compare>::node>(data, temp));
    return temp;
  }
  typename fibonacci_heap<K, T, Compare>::node findNode(T v) {
    typename std::unordered_map<
        T, typename fibonacci_heap<K, T, Compare>::node>::iterator it =
        fstore.find(v);
    return it->second;
  }
  typename fibonacci_heap<K, T, Compare>::node pop() {
    if (fibonacci_heap<K, T, Compare>::isEmpty())
      throw "this Fibonacci heap is empty";
    typename fibonacci_heap<K, T, Compare>::node temp =
        fibonacci_heap<K, T, Compare>::remove();
    typename std::unordered_map<
        T, typename fibonacci_heap<K, T, Compare>::node>::iterator it =
        fstore.find(temp.data());
    fstore.erase(it);
    return temp;
  }
  std::unordered_multimap<T, typename fibonacci_heap<K, T, Compare>::node>
      fstore;
};

#endif