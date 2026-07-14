import 'dart:convert';

import 'package:flutter/services.dart';

class PerchSceneSet {
  const PerchSceneSet({
    required this.schemaVersion,
    required this.id,
    required this.name,
    required this.description,
    required this.designWidth,
    required this.designHeight,
    required this.baseScene,
    required this.preview,
    required this.capabilities,
    required this.layers,
    required this.cameras,
    required this.hitboxes,
    required this.objects,
    required this.memorySlots,
    required this.collectibleSlots,
    required this.ambientChannels,
    required this.lighting,
    required this.evolutionRules,
  });

  final int schemaVersion;
  final String id;
  final String name;
  final String description;
  final double designWidth;
  final double designHeight;
  final String baseScene;
  final String preview;
  final List<String> capabilities;
  final List<PerchSceneLayer> layers;
  final List<PerchSceneCamera> cameras;
  final List<PerchSceneHitbox> hitboxes;
  final List<PerchSceneObjectDefinition> objects;
  final List<PerchSceneSlot> memorySlots;
  final List<PerchSceneSlot> collectibleSlots;
  final List<PerchAmbientChannel> ambientChannels;
  final Map<String, PerchLightingState> lighting;
  final List<PerchEvolutionRule> evolutionRules;

  factory PerchSceneSet.fromJson(Map<String, dynamic> json) {
    final designSize = _map(json['designSize']);
    final slots = _map(json['slots']);
    final lightingJson = _map(json['lighting']);

    return PerchSceneSet(
      schemaVersion: _int(json['schemaVersion']),
      id: _string(json['id']),
      name: _string(json['name']),
      description: _string(json['description']),
      designWidth: _double(designSize['width']),
      designHeight: _double(designSize['height']),
      baseScene: _string(json['baseScene']),
      preview: _string(json['preview']),
      capabilities: _stringList(json['capabilities']),
      layers: _list(json['layers'])
          .map((entry) => PerchSceneLayer.fromJson(_map(entry)))
          .toList(growable: false),
      cameras: _list(json['cameras'])
          .map((entry) => PerchSceneCamera.fromJson(_map(entry)))
          .toList(growable: false),
      hitboxes: _list(json['hitboxes'])
          .map((entry) => PerchSceneHitbox.fromJson(_map(entry)))
          .toList(growable: false),
      objects: _list(json['objects'])
          .map((entry) => PerchSceneObjectDefinition.fromJson(_map(entry)))
          .toList(growable: false),
      memorySlots: _list(slots['memory'])
          .map((entry) => PerchSceneSlot.fromJson(_map(entry)))
          .toList(growable: false),
      collectibleSlots: _list(slots['collectible'])
          .map((entry) => PerchSceneSlot.fromJson(_map(entry)))
          .toList(growable: false),
      ambientChannels: _list(json['ambientChannels'])
          .map((entry) => PerchAmbientChannel.fromJson(_map(entry)))
          .toList(growable: false),
      lighting: lightingJson.map(
        (key, value) => MapEntry(
          key,
          PerchLightingState.fromJson(_map(value)),
        ),
      ),
      evolutionRules: _list(json['evolutionRules'])
          .map((entry) => PerchEvolutionRule.fromJson(_map(entry)))
          .toList(growable: false),
    );
  }

  PerchSceneCamera camera(String id) => cameras.firstWhere(
        (camera) => camera.id == id,
        orElse: () => cameras.first,
      );

  PerchSceneHitbox? hitbox(String id) {
    for (final hitbox in hitboxes) {
      if (hitbox.id == id) return hitbox;
    }
    return null;
  }

  PerchLightingState? lightingFor(String id) => lighting[id];
}

class PerchSceneLayer {
  const PerchSceneLayer({
    required this.id,
    required this.group,
    required this.z,
    required this.required,
  });

  final String id;
  final String group;
  final int z;
  final bool required;

  factory PerchSceneLayer.fromJson(Map<String, dynamic> json) =>
      PerchSceneLayer(
        id: _string(json['id']),
        group: _string(json['group']),
        z: _int(json['z']),
        required: json['required'] == true,
      );
}

class PerchNormalizedRect {
  const PerchNormalizedRect({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  factory PerchNormalizedRect.fromJson(Map<String, dynamic> json) =>
      PerchNormalizedRect(
        x: _double(json['x']),
        y: _double(json['y']),
        width: _double(json['width']),
        height: _double(json['height']),
      );

  bool get isNormalized =>
      x >= 0 &&
      y >= 0 &&
      width > 0 &&
      height > 0 &&
      x + width <= 1.0001 &&
      y + height <= 1.0001;
}

class PerchSceneCamera {
  const PerchSceneCamera({
    required this.id,
    required this.frame,
    required this.durationMs,
  });

  final String id;
  final PerchNormalizedRect frame;
  final int durationMs;

  factory PerchSceneCamera.fromJson(Map<String, dynamic> json) =>
      PerchSceneCamera(
        id: _string(json['id']),
        frame: PerchNormalizedRect.fromJson(_map(json['frame'])),
        durationMs: _int(json['durationMs']),
      );
}

class PerchSceneHitbox {
  const PerchSceneHitbox({
    required this.id,
    required this.label,
    required this.rect,
    required this.minTouch,
    required this.action,
    this.camera,
  });

  final String id;
  final String label;
  final PerchNormalizedRect rect;
  final double minTouch;
  final String action;
  final String? camera;

  factory PerchSceneHitbox.fromJson(Map<String, dynamic> json) =>
      PerchSceneHitbox(
        id: _string(json['id']),
        label: _string(json['label']),
        rect: PerchNormalizedRect.fromJson(_map(json['rect'])),
        minTouch: _double(json['minTouch']),
        action: _string(json['action']),
        camera: json['camera'] == null ? null : _string(json['camera']),
      );
}

class PerchSceneObjectDefinition {
  const PerchSceneObjectDefinition({
    required this.id,
    required this.category,
    required this.slot,
    required this.choices,
    required this.states,
  });

  final String id;
  final String category;
  final String slot;
  final List<String> choices;
  final List<String> states;

  factory PerchSceneObjectDefinition.fromJson(Map<String, dynamic> json) =>
      PerchSceneObjectDefinition(
        id: _string(json['id']),
        category: _string(json['category']),
        slot: _string(json['slot']),
        choices: _stringList(json['choices']),
        states: _stringList(json['states']),
      );
}

class PerchSceneSlot {
  const PerchSceneSlot({required this.id, required this.rect});

  final String id;
  final PerchNormalizedRect rect;

  factory PerchSceneSlot.fromJson(Map<String, dynamic> json) => PerchSceneSlot(
        id: _string(json['id']),
        rect: PerchNormalizedRect.fromJson(_map(json['rect'])),
      );
}

class PerchAmbientChannel {
  const PerchAmbientChannel({
    required this.id,
    required this.source,
    required this.enabledWhen,
    required this.motion,
  });

  final String id;
  final String source;
  final String enabledWhen;
  final String motion;

  factory PerchAmbientChannel.fromJson(Map<String, dynamic> json) =>
      PerchAmbientChannel(
        id: _string(json['id']),
        source: _string(json['source']),
        enabledWhen: _string(json['enabledWhen']),
        motion: _string(json['motion']),
      );
}

class PerchLightingState {
  const PerchLightingState({
    required this.background,
    required this.lampPolicy,
  });

  final String background;
  final String lampPolicy;

  factory PerchLightingState.fromJson(Map<String, dynamic> json) =>
      PerchLightingState(
        background: _string(json['background']),
        lampPolicy: _string(json['lampPolicy']),
      );
}

class PerchEvolutionRule {
  const PerchEvolutionRule({
    required this.id,
    required this.event,
    required this.target,
    required this.effect,
  });

  final String id;
  final String event;
  final String target;
  final String effect;

  factory PerchEvolutionRule.fromJson(Map<String, dynamic> json) =>
      PerchEvolutionRule(
        id: _string(json['id']),
        event: _string(json['event']),
        target: _string(json['target']),
        effect: _string(json['effect']),
      );
}

class PerchSceneSetLoader {
  const PerchSceneSetLoader();

  static const cabinManifest =
      'assets/sets/cabin_v1/manifest.json';

  Future<PerchSceneSet> load(String assetPath) async {
    final source = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, dynamic>) {
      throw const FormatException('Scene manifest must be a JSON object.');
    }
    final set = PerchSceneSet.fromJson(decoded);
    final errors = PerchSceneSetValidator.validate(set);
    if (errors.isNotEmpty) {
      throw FormatException(
        'Invalid Perch scene set: ${errors.join('; ')}',
      );
    }
    return set;
  }

  Future<PerchSceneSet> loadCabin() => load(cabinManifest);
}

class PerchSceneSetValidator {
  const PerchSceneSetValidator._();

  static List<String> validate(PerchSceneSet set) {
    final errors = <String>[];
    if (set.schemaVersion != 1) {
      errors.add('Unsupported schema version ${set.schemaVersion}');
    }
    if (set.id.trim().isEmpty) errors.add('Set id is required');
    if (set.baseScene.trim().isEmpty) errors.add('Base scene is required');

    final cameraIds = <String>{};
    for (final camera in set.cameras) {
      if (!cameraIds.add(camera.id)) {
        errors.add('Duplicate camera ${camera.id}');
      }
      if (!camera.frame.isNormalized) {
        errors.add('Camera ${camera.id} is outside normalized bounds');
      }
    }

    final hitboxIds = <String>{};
    const knownActions = {
      'openJournal',
      'customizeDrink',
      'openQuickCapture',
      'openEmailIntelligence',
      'editPriority',
      'inspectGrowth',
      'toggleLamp',
      'openMemories',
      'enterWorld',
    };
    for (final hitbox in set.hitboxes) {
      if (!hitboxIds.add(hitbox.id)) {
        errors.add('Duplicate hitbox ${hitbox.id}');
      }
      if (!hitbox.rect.isNormalized) {
        errors.add('Hitbox ${hitbox.id} is outside normalized bounds');
      }
      if (hitbox.minTouch < 44) {
        errors.add('Hitbox ${hitbox.id} has an undersized touch target');
      }
      if (!knownActions.contains(hitbox.action)) {
        errors.add('Unknown action ${hitbox.action}');
      }
      if (hitbox.camera != null && !cameraIds.contains(hitbox.camera)) {
        errors.add('Hitbox ${hitbox.id} references missing camera');
      }
      if (hitbox.label.trim().isEmpty) {
        errors.add('Hitbox ${hitbox.id} needs an accessibility label');
      }
    }

    return errors;
  }
}

Map<String, dynamic> _map(Object? value) =>
    value is Map<String, dynamic> ? value : const {};

List<dynamic> _list(Object? value) => value is List ? value : const [];

String _string(Object? value) => value?.toString() ?? '';

int _int(Object? value) => value is num ? value.toInt() : 0;

double _double(Object? value) => value is num ? value.toDouble() : 0;

List<String> _stringList(Object? value) =>
    _list(value).map(_string).toList(growable: false);
