import 'package:flutter_test/flutter_test.dart';
import 'package:perch_today_scene/core/memory/memory_engine.dart';

void main() {
  test('recall filters by kind and tags then ranks importance', () {
    final engine = MemoryEngine(seed: [
      MemoryRecord(
        id: '1',
        kind: 'project',
        summary: 'Low importance',
        createdAt: DateTime(2026, 7, 1),
        tags: const ['perch'],
        importance: 0.2,
      ),
      MemoryRecord(
        id: '2',
        kind: 'project',
        summary: 'High importance',
        createdAt: DateTime(2026, 7, 2),
        tags: const ['perch', 'flutter'],
        importance: 0.9,
      ),
    ]);

    final results = engine.recall(kind: 'project', tags: const ['perch']);

    expect(results.first.id, '2');
    expect(results.length, 2);
  });

  test('remember replaces duplicate IDs and forget removes them', () {
    final engine = MemoryEngine();
    final first = MemoryRecord(
      id: 'same',
      kind: 'capture',
      summary: 'First',
      createdAt: DateTime(2026, 7, 1),
    );
    final replacement = MemoryRecord(
      id: 'same',
      kind: 'capture',
      summary: 'Replacement',
      createdAt: DateTime(2026, 7, 2),
    );

    engine.remember(first);
    engine.remember(replacement);

    expect(engine.records.single.summary, 'Replacement');
    expect(engine.forget('same'), isTrue);
    expect(engine.records, isEmpty);
  });
}
