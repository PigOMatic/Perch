import 'package:flutter/foundation.dart';

@immutable
class MemoryRecord {
  const MemoryRecord({
    required this.id,
    required this.kind,
    required this.summary,
    required this.createdAt,
    this.tags = const <String>[],
    this.importance = 0.5,
    this.source,
  });

  final String id;
  final String kind;
  final String summary;
  final DateTime createdAt;
  final List<String> tags;
  final double importance;
  final String? source;
}

class MemoryEngine {
  MemoryEngine({Iterable<MemoryRecord> seed = const <MemoryRecord>[]})
      : _records = List<MemoryRecord>.from(seed);

  final List<MemoryRecord> _records;

  List<MemoryRecord> get records => List.unmodifiable(_records);

  void remember(MemoryRecord record) {
    _records.removeWhere((item) => item.id == record.id);
    _records.add(record);
    _records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<MemoryRecord> recall({
    String? kind,
    Iterable<String> tags = const <String>[],
    int limit = 20,
  }) {
    final requiredTags = tags.toSet();
    final matches = _records.where((record) {
      final kindMatches = kind == null || record.kind == kind;
      final tagsMatch = requiredTags.isEmpty ||
          requiredTags.every(record.tags.toSet().contains);
      return kindMatches && tagsMatch;
    }).toList()
      ..sort((a, b) {
        final importance = b.importance.compareTo(a.importance);
        return importance != 0
            ? importance
            : b.createdAt.compareTo(a.createdAt);
      });

    return matches.take(limit).toList(growable: false);
  }

  bool forget(String id) {
    final before = _records.length;
    _records.removeWhere((record) => record.id == id);
    return _records.length != before;
  }
}
