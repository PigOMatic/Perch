import 'package:flutter/foundation.dart';

@immutable
class PerchBrainState {
  const PerchBrainState({
    this.journalFocused = false,
    this.priority = '',
    this.captures = const <String>[],
    this.completedTaskIds = const <String>{},
    this.activeDeskObjectId,
    this.lanternOn = false,
    this.steamOn = true,
    this.plantStage = 1,
    this.revision = 0,
  });

  final bool journalFocused;
  final String priority;
  final List<String> captures;
  final Set<String> completedTaskIds;
  final String? activeDeskObjectId;
  final bool lanternOn;
  final bool steamOn;
  final int plantStage;
  final int revision;

  PerchBrainState copyWith({
    bool? journalFocused,
    String? priority,
    List<String>? captures,
    Set<String>? completedTaskIds,
    String? activeDeskObjectId,
    bool clearActiveDeskObject = false,
    bool? lanternOn,
    bool? steamOn,
    int? plantStage,
  }) {
    return PerchBrainState(
      journalFocused: journalFocused ?? this.journalFocused,
      priority: priority ?? this.priority,
      captures: captures ?? this.captures,
      completedTaskIds: completedTaskIds ?? this.completedTaskIds,
      activeDeskObjectId: clearActiveDeskObject
          ? null
          : activeDeskObjectId ?? this.activeDeskObjectId,
      lanternOn: lanternOn ?? this.lanternOn,
      steamOn: steamOn ?? this.steamOn,
      plantStage: plantStage ?? this.plantStage,
      revision: revision + 1,
    );
  }
}
