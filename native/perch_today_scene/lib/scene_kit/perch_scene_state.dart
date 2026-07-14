class PerchSceneState {
  const PerchSceneState({
    this.activeSetId = 'cabin_v1',
    this.cameraId = 'home',
    this.lightingId = 'morning',
    this.weatherId = 'clear',
    this.identityChoices = const {
      'drink': 'coffee_mug',
      'journal': 'leather',
      'writing_tool': 'gel_pen',
      'plant': 'pothos',
      'lamp': 'oil_lantern',
    },
    this.objectStates = const {
      'drink': 'hot',
      'journal': 'closed',
      'plant': 'small',
      'lamp': 'off',
      'sticky_note': 'active',
      'photo': 'family',
    },
    this.memoryPlacements = const [],
    this.collectiblePlacements = const [],
    this.stickyNoteText = '',
    this.featuredPhotoId,
  });

  final String activeSetId;
  final String cameraId;
  final String lightingId;
  final String weatherId;
  final Map<String, String> identityChoices;
  final Map<String, String> objectStates;
  final List<PerchScenePlacement> memoryPlacements;
  final List<PerchScenePlacement> collectiblePlacements;
  final String stickyNoteText;
  final String? featuredPhotoId;

  String identityChoice(String objectId, {String fallback = ''}) =>
      identityChoices[objectId] ?? fallback;

  String objectState(String objectId, {String fallback = ''}) =>
      objectStates[objectId] ?? fallback;

  PerchSceneState copyWith({
    String? activeSetId,
    String? cameraId,
    String? lightingId,
    String? weatherId,
    Map<String, String>? identityChoices,
    Map<String, String>? objectStates,
    List<PerchScenePlacement>? memoryPlacements,
    List<PerchScenePlacement>? collectiblePlacements,
    String? stickyNoteText,
    String? featuredPhotoId,
    bool clearFeaturedPhoto = false,
  }) {
    return PerchSceneState(
      activeSetId: activeSetId ?? this.activeSetId,
      cameraId: cameraId ?? this.cameraId,
      lightingId: lightingId ?? this.lightingId,
      weatherId: weatherId ?? this.weatherId,
      identityChoices: identityChoices ?? this.identityChoices,
      objectStates: objectStates ?? this.objectStates,
      memoryPlacements: memoryPlacements ?? this.memoryPlacements,
      collectiblePlacements:
          collectiblePlacements ?? this.collectiblePlacements,
      stickyNoteText: stickyNoteText ?? this.stickyNoteText,
      featuredPhotoId:
          clearFeaturedPhoto ? null : featuredPhotoId ?? this.featuredPhotoId,
    );
  }

  PerchSceneState chooseIdentity(String objectId, String choiceId) {
    return copyWith(
      identityChoices: {
        ...identityChoices,
        objectId: choiceId,
      },
    );
  }

  PerchSceneState setObjectState(String objectId, String stateId) {
    return copyWith(
      objectStates: {
        ...objectStates,
        objectId: stateId,
      },
    );
  }

  PerchSceneState placeMemory(PerchScenePlacement placement) {
    return copyWith(memoryPlacements: [...memoryPlacements, placement]);
  }

  PerchSceneState placeCollectible(PerchScenePlacement placement) {
    return copyWith(
      collectiblePlacements: [...collectiblePlacements, placement],
    );
  }
}

class PerchScenePlacement {
  const PerchScenePlacement({
    required this.id,
    required this.assetId,
    required this.slotId,
    required this.createdAt,
    this.sourceEventId,
    this.title,
  });

  final String id;
  final String assetId;
  final String slotId;
  final DateTime createdAt;
  final String? sourceEventId;
  final String? title;
}

class PerchSceneEvolutionEvent {
  const PerchSceneEvolutionEvent({
    required this.id,
    required this.type,
    required this.occurredAt,
    this.region,
    this.assetId,
    this.title,
    this.metadata = const {},
  });

  final String id;
  final String type;
  final DateTime occurredAt;
  final String? region;
  final String? assetId;
  final String? title;
  final Map<String, String> metadata;
}

class PerchSceneEvolutionEngine {
  const PerchSceneEvolutionEngine();

  PerchSceneState apply(
    PerchSceneState state,
    PerchSceneEvolutionEvent event,
  ) {
    switch (event.type) {
      case 'growth.progressed':
        return _advancePlant(state);
      case 'trip.completed':
        return _placeMemory(state, event, defaultAssetId: 'trip_map');
      case 'collectible.earned':
        return _placeCollectible(state, event);
      case 'memory.featured':
        return state.copyWith(featuredPhotoId: event.assetId);
      case 'season.changed':
        return state.copyWith(
          lightingId: event.metadata['lighting'] ?? state.lightingId,
        );
      default:
        return state;
    }
  }

  PerchSceneState _advancePlant(PerchSceneState state) {
    const stages = ['seed', 'sprout', 'small', 'healthy', 'mature', 'flowering'];
    final current = state.objectState('plant', fallback: 'seed');
    final index = stages.indexOf(current);
    final nextIndex = index < 0 ? 1 : (index + 1).clamp(0, stages.length - 1);
    return state.setObjectState('plant', stages[nextIndex]);
  }

  PerchSceneState _placeMemory(
    PerchSceneState state,
    PerchSceneEvolutionEvent event, {
    required String defaultAssetId,
  }) {
    final slot = _firstFreeSlot(
      const ['memory.desk.left', 'memory.desk.right', 'memory.shelf.one'],
      state.memoryPlacements,
    );
    if (slot == null) return state;
    return state.placeMemory(
      PerchScenePlacement(
        id: 'memory:${event.id}',
        assetId: event.assetId ?? defaultAssetId,
        slotId: slot,
        createdAt: event.occurredAt,
        sourceEventId: event.id,
        title: event.title,
      ),
    );
  }

  PerchSceneState _placeCollectible(
    PerchSceneState state,
    PerchSceneEvolutionEvent event,
  ) {
    final assetId = event.assetId;
    if (assetId == null || assetId.isEmpty) return state;
    final slot = _firstFreeSlot(
      const [
        'collectible.journal.cover',
        'collectible.desk.center',
        'collectible.shelf.two',
      ],
      state.collectiblePlacements,
    );
    if (slot == null) return state;
    return state.placeCollectible(
      PerchScenePlacement(
        id: 'collectible:${event.id}',
        assetId: assetId,
        slotId: slot,
        createdAt: event.occurredAt,
        sourceEventId: event.id,
        title: event.title,
      ),
    );
  }

  String? _firstFreeSlot(
    List<String> slots,
    List<PerchScenePlacement> placements,
  ) {
    final used = placements.map((placement) => placement.slotId).toSet();
    for (final slot in slots) {
      if (!used.contains(slot)) return slot;
    }
    return null;
  }
}
