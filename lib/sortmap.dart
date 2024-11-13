import 'dart:collection';

class Node {
  double data;
  Node? next;

  Node(this.data);
}

class MapSorter {
  static Node? _head;

  static Node? _findMiddle(Node? head) {
    Node? slow = head;
    Node? fast = head;
    while (fast != null && fast.next != null && fast.next!.next != null) {
      slow = slow!.next;
      fast = fast.next!.next;
    }
    return slow;
  }

  static Node? _merge(Node? list1, Node? list2) {
    if (list1 == null) return list2;
    if (list2 == null) return list1;

    Node? mergedHead;

    if (list1.data < list2.data) {
      mergedHead = list1;
      mergedHead.next = _merge(list1.next, list2);
    } else {
      mergedHead = list2;
      mergedHead.next = _merge(list1, list2.next);
    }
    return mergedHead;
  }

  static Node? _mergeSort(Node? head) {
    if (head == null || head.next == null) {
      return head;
    }

    Node? middle = _findMiddle(head);
    Node? left = head;
    Node? right = middle!.next;
    middle.next = null;

    left = _mergeSort(left);
    right = _mergeSort(right);

    return _merge(left, right);
  }

  static Node? _insert(Node? head, double x) {
    Node temp1 = Node(x);
    if (head == null) {
      head = temp1;
    } else {
      Node? newNode = head;
      while (newNode!.next != null) {
        newNode = newNode.next;
      }
      newNode.next = temp1;
    }
    return head;
  }

  static SplayTreeMap<double, dynamic> sort(Map<double, dynamic> hashmap) {
    _head = null; // Reset head for each call

    // Insert keys from hashmap into the linked list
    for (var key in hashmap.keys) {
      _head = _insert(_head, key);
    }

    // Perform merge sort on the linked list
    _head = _mergeSort(_head);

    // Transfer sorted data from linked list to a SplayTreeMap
    SplayTreeMap<double, dynamic> sortedMap = SplayTreeMap();
    Node? current = _head;
    while (current != null) {
      sortedMap[current.data] = hashmap[current.data]!;
      current = current.next;
    }

    return sortedMap;
  }
}
