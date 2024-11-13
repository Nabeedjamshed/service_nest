// Custom Customhashmap Entry class
class CustomhashmapEntry<K, V> {
  K key;
  V value;
  CustomhashmapEntry(this.key, this.value);
}

// Custom Customhashmap implementation
class Customhashmap<K, V> {
  // Initial capacity of the hash table
  static const int initialCapacity = 16;
  // Load factor threshold before resizing
  static const double loadFactorThreshold = 0.75;
  // Array of lists to store key-value pairs (separate chaining for collision handling)
  List<List<CustomhashmapEntry<K, V>>> _buckets;
  int _size = 0;

  // Constructor
  Customhashmap() : _buckets = List<List<CustomhashmapEntry<K, V>>>.generate(initialCapacity, (index) => []);

  // Hash function to compute bucket index
  int _hash(K key) {
    return key.hashCode % _buckets.length;
  }

  // Get the value associated with a key
  V? get(K key) {
    int index = _hash(key);
    for (var entry in _buckets[index]) {
      if (entry.key == key) {
        return entry.value;
      }
    }
    return null; // Key not found
  }

  // Add or update a key-value pair
  void put(K key, V value) {
    int index = _hash(key);
    for (var entry in _buckets[index]) {
      if (entry.key == key) {
        entry.value = value; // Update existing key
        return;
      }
    }

    // Key does not exist; add new entry
    _buckets[index].add(CustomhashmapEntry(key, value));
    _size++;

    // Resize if load factor threshold is exceeded
    if (_size / _buckets.length > loadFactorThreshold) {
      _resize();
    }
  }

  // Remove a key-value pair by key
  bool remove(K key) {
    int index = _hash(key);
    var bucket = _buckets[index];
    for (int i = 0; i < bucket.length; i++) {
      if (bucket[i].key == key) {
        bucket.removeAt(i);
        _size--;
        return true;
      }
    }
    return false; // Key not found
  }

  // Resize the buckets array when load factor is too high
  void _resize() {
    var oldBuckets = _buckets;
    _buckets = List<List<CustomhashmapEntry<K, V>>>.generate(oldBuckets.length * 2, (index) => []);
    _size = 0;

    for (var bucket in oldBuckets) {
      for (var entry in bucket) {
        put(entry.key, entry.value); // Rehash entries into the new bucket array
      }
    }
  }

  // Check if the map contains a key
  bool containsKey(K key) {
    return get(key) != null;
  }

  // Get the number of entries in the map
  int get size => _size;

  // Return all entries as a list
  List<CustomhashmapEntry<K, V>> get entries {
    List<CustomhashmapEntry<K, V>> allEntries = [];
    for (var bucket in _buckets) {
      for (var entry in bucket) {
        allEntries.add(entry);
      }
    }
    return allEntries;
  }
}
