#ifndef SHARED_JQUEUE_H_
#define SHARED_JQUEUE_H_

#include "dcheck.h"

namespace stdj {

template <typename T>
class Queue {
 public:
  Queue() {}
  ~Queue() {}

  void Add(T value) {
    QueueEntry* new_entry = new QueueEntry();
    new_entry->value = value;
    new_entry->next = 0;
    
    if (!head_) {
      head_ = new_entry;
      return;
    }

    QueueEntry* last_entry = head_;
    while (last_entry->next) {
      last_entry = last_entry->next;
    }
    last_entry->next = new_entry;
  }

  T Remove() {
    // TODO DCHECK_MESSAGE doesn't work
    // DCHECK_MESSAGE(head_, "Queue::Remove called on empty queue\n");
    DCHECK(head_);
    QueueEntry* remove_entry = head_;
    T remove_value = remove_entry->value;
    head_ = head_->next;
    delete remove_entry;
    return remove_value;
  }

  T Peek() {
    DCHECK(head_);
    return head_->value;
  }

  T GetAtIndex(int index) {
    QueueEntry* entry = head_;
    int current_entry_index = 0;
    while (entry) {
      if (current_entry_index == index) {
        return entry->value;
      }
      entry = entry->next;
      current_entry_index++;
    }

    DCHECK(false);
    return head_->value;
  }

  uint64_t Size() const {
    uint64_t size = 0;
    QueueEntry* next = head_;
    while (next) {
      next = next->next;
      size++;
    }
    return size;
  }

  bool IsEmpty() const {
    return Size() == 0;
  }

 private:
  struct QueueEntry {
    T value;
    QueueEntry* next;
  };

  QueueEntry* head_ = 0;
};

}  // namespace stdj

#endif  // SHARED_JQUEUE_H_
