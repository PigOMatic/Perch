import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/brain/perch_brain_scope.dart';
import '../../core/brief/daily_brief_engine.dart';
import '../../core/context/perch_context_snapshot.dart';
import '../../core/email/email_intelligence.dart';
import '../../core/events/perch_event.dart';
import '../../core/recommendations/perch_recommendation.dart';
import '../../data/perch_today_models.dart';
import 'email_workspace_panel.dart';

/// Invisible interaction map laid over the photorealistic desk.
///
/// The visual objects live in [RealisticDeskOverlay]. This layer deliberately
/// contains no duplicate placeholder icons or colored cards; it only provides
/// generous, accessible hit targets and opens the physical workspaces behind
/// each desk object.
class DeskFunctionalityLayer extends StatefulWidget {
  const DeskFunctionalityLayer({
    super.key,
    required this.data,
    required this.journalFocused,
  });

  final PerchTodayData data;
  final bool journalFocused;

  @override
  State<DeskFunctionalityLayer> createState() =>
      _DeskFunctionalityLayerState();
}

class _DeskFunctionalityLayerState extends State<DeskFunctionalityLayer> {
  bool _loaded = false;
  bool _taskDone = false;
  bool _lanternOn = false;
  bool _steamOn = true;
  int _plantStage = 1;
  String _priority = '';
  List<String> _captures = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _publish(
    String type,
    String source, [
    Map<String, Object?> payload = const {},
  ]) {
    PerchBrainScope.read(context).publish(
      PerchEvent(type: type, source: source, payload: payload),
    );
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;

    final priority =
        prefs.getString('perch.sticky.priority') ?? widget.data.nextDue.title;
    final captures =
        prefs.getStringList('perch.brain.captures') ?? <String>[];
    final lanternOn = prefs.getBool('perch.lantern.on') ?? false;
    final steamOn = prefs.getBool('perch.coffee.steam') ?? true;
    final plantStage =
        (prefs.getInt('perch.plant.stage') ?? 1).clamp(0, 3).toInt();

    setState(() {
      _taskDone = prefs.getBool('perch.task.done') ?? false;
      _lanternOn = lanternOn;
      _steamOn = steamOn;
      _plantStage = plantStage;
      _priority = priority;
      _captures = captures;
      _loaded = true;
    });

    _publish(
      PerchEventTypes.priorityChanged,
      'desk.persistence',
      {'text': priority},
    );
    _publish(
      PerchEventTypes.deskAmbienceChanged,
      'desk.persistence',
      {'lanternOn': lanternOn, 'steamOn': steamOn},
    );
    _publish(
      PerchEventTypes.plantStageChanged,
      'desk.persistence',
      {'stage': plantStage},
    );
    for (final capture in captures.reversed) {
      _publish(
        PerchEventTypes.quickCaptureAdded,
        'desk.persistence',
        {'text': capture},
      );
    }
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  void _activate(String id) {
    _publish(
      PerchEventTypes.deskObjectActivated,
      'desk.$id',
      {'id': id},
    );
  }

  Future<void> _capture() async {
    _activate('pen');
    final value = await _textDialog(
      title: 'Quick Capture',
      initial: '',
      hint: 'What do you need to remember?',
    );
    if (value == null || value.isEmpty) return;

    final updated = <String>[value, ..._captures.where((item) => item != value)];
    setState(() => _captures = updated);
    _publish(
      PerchEventTypes.quickCaptureAdded,
      'desk.pen',
      {'text': value},
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('perch.brain.captures', updated);
  }

  Future<void> _editPriority() async {
    _activate('sticky_note');
    final value = await _textDialog(
      title: 'Desk Priority',
      initial: _priority,
      hint: 'One thing that matters most',
    );
    if (value == null || value.isEmpty) return;

    setState(() => _priority = value);
    _publish(
      PerchEventTypes.priorityChanged,
      'desk.sticky_note',
      {'text': value},
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perch.sticky.priority', value);
  }

  Future<String?> _textDialog({
    required String title,
    required String initial,
    required String hint,
  }) async {
    final controller = TextEditingController(text: initial);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: hint,
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  Future<void> _emailIntelligence() async {
    _activate('envelope');
    final now = DateTime.now();
    final ranked = const EmailIntelligence().rank(
      [
        EmailSignal(
          id: 'shift',
          sender: 'Work',
          subject: 'Response needed before your next shift',
          preview: 'Please confirm the updated assignment.',
          receivedAt: now.subtract(const Duration(hours: 2)),
          senderImportance: 0.95,
          hasDeadlineLanguage: true,
          hasQuestion: true,
        ),
        EmailSignal(
          id: 'perch',
          sender: 'Perch Project',
          subject: 'Development notes ready to review',
          preview: 'The next Perch changes are ready.',
          receivedAt: now.subtract(const Duration(hours: 8)),
          senderImportance: 0.7,
          hasAttachment: true,
        ),
      ],
      now: now,
    );

    if (!mounted) return;
    await showEmailWorkspace(context, assessments: ranked);
  }

  void _today() {
    _activate('today');
    final contextSnapshot = PerchContextSnapshot(
      capturedAt: DateTime.now(),
      lifeMode: 'home',
      energy: 0.65,
      availableMinutes: 45,
      unreadImportantEmailCount: 1,
      activeProjectIds: const ['perch'],
      calendarPressure: 0.35,
      financialPressure: 0.45,
    );

    final recommendations = <PerchRecommendation>[
      PerchRecommendation(
        id: 'priority',
        title: _priority,
        reason: 'This is the priority currently placed on your desk.',
        actionLabel: _taskDone ? 'Choose the next priority' : 'Start here',
        priority: _taskDone ? 0.35 : 0.9,
        source: 'sticky_note',
      ),
      if (_captures.isNotEmpty)
        PerchRecommendation(
          id: 'capture',
          title: _captures.first,
          reason: 'This was your most recent quick capture.',
          actionLabel: 'Review capture',
          priority: 0.6,
          source: 'memory',
        ),
    ];

    final brief = const DailyBriefEngine().build(
      context: contextSnapshot,
      facts: [
        widget.data.dayStatus,
        '${_captures.length} recent capture${_captures.length == 1 ? '' : 's'}',
        _taskDone ? 'Primary task completed' : 'Primary task still open',
      ],
      recommendations: recommendations,
    );

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(brief.opening),
              const SizedBox(height: 12),
              ...brief.facts.map(
                (fact) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text('• $fact'),
                ),
              ),
              if (brief.recommendation != null) ...[
                const Divider(height: 24),
                Text(
                  brief.recommendation!.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(brief.recommendation!.reason),
                const SizedBox(height: 6),
                Text(
                  brief.recommendation!.actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
              const Divider(height: 28),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _taskDone,
                title: Text(widget.data.nextDue.title),
                subtitle: Text(widget.data.nextDue.actionLabel),
                onChanged: (_) async {
                  Navigator.pop(context);
                  final next = !_taskDone;
                  setState(() => _taskDone = next);
                  _publish(
                    PerchEventTypes.taskCompletionChanged,
                    'desk.today',
                    {'completed': next, 'taskId': 'next_due'},
                  );
                  await _setBool('perch.task.done', next);
                },
              ),
              if (_captures.isNotEmpty) ...[
                const Divider(),
                Text(
                  'Recent captures',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                ..._captures.take(4).map((item) => Text('• $item')),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _toggleSteam() async {
    _activate('coffee');
    final next = !_steamOn;
    setState(() => _steamOn = next);
    _publish(
      PerchEventTypes.deskAmbienceChanged,
      'desk.coffee',
      {'lanternOn': _lanternOn, 'steamOn': next},
    );
    await _setBool('perch.coffee.steam', next);
  }

  Future<void> _toggleLantern() async {
    _activate('lantern');
    final next = !_lanternOn;
    setState(() => _lanternOn = next);
    _publish(
      PerchEventTypes.deskAmbienceChanged,
      'desk.lantern',
      {'lanternOn': next, 'steamOn': _steamOn},
    );
    await _setBool('perch.lantern.on', next);
  }

  Future<void> _advancePlant() async {
    _activate('plant');
    final next = (_plantStage + 1) % 4;
    setState(() => _plantStage = next);
    _publish(
      PerchEventTypes.plantStageChanged,
      'desk.plant',
      {'stage': next},
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('perch.plant.stage', next);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    return IgnorePointer(
      ignoring: widget.journalFocused,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: widget.journalFocused ? 0 : 1,
        child: LayoutBuilder(
          builder: (context, box) {
            final portrait = box.maxHeight >= box.maxWidth;
            return Stack(
              fit: StackFit.expand,
              children: [
                _hitTarget(
                  box,
                  id: 'coffee',
                  label: 'Toggle coffee steam',
                  x: portrait ? .03 : .03,
                  y: portrait ? .60 : .57,
                  width: portrait ? .26 : .17,
                  height: portrait ? .18 : .25,
                  onTap: _toggleSteam,
                ),
                _hitTarget(
                  box,
                  id: 'pen',
                  label: 'Quick capture',
                  x: portrait ? .73 : .80,
                  y: portrait ? .63 : .60,
                  width: portrait ? .24 : .16,
                  height: portrait ? .18 : .24,
                  onTap: _capture,
                ),
                _hitTarget(
                  box,
                  id: 'envelope',
                  label: 'Open Email Intelligence',
                  x: portrait ? .67 : .73,
                  y: portrait ? .43 : .42,
                  width: portrait ? .31 : .22,
                  height: portrait ? .20 : .22,
                  onTap: _emailIntelligence,
                ),
                _hitTarget(
                  box,
                  id: 'sticky_note',
                  label: 'Edit desk priority',
                  x: portrait ? .02 : .035,
                  y: portrait ? .42 : .40,
                  width: portrait ? .34 : .22,
                  height: portrait ? .24 : .27,
                  onTap: _editPriority,
                ),
                _hitTarget(
                  box,
                  id: 'plant',
                  label: 'Grow plant',
                  x: portrait ? .03 : .06,
                  y: portrait ? .18 : .12,
                  width: portrait ? .25 : .15,
                  height: portrait ? .19 : .23,
                  onTap: _advancePlant,
                ),
                _hitTarget(
                  box,
                  id: 'lantern',
                  label: 'Toggle lantern',
                  x: portrait ? .72 : .80,
                  y: portrait ? .14 : .11,
                  width: portrait ? .26 : .17,
                  height: portrait ? .25 : .29,
                  onTap: _toggleLantern,
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: SafeArea(
                    child: _TodayButton(
                      done: _taskDone,
                      captures: _captures.length,
                      onTap: _today,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _hitTarget(
    BoxConstraints box, {
    required String id,
    required String label,
    required double x,
    required double y,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    return Positioned(
      left: box.maxWidth * x,
      top: box.maxHeight * y,
      width: box.maxWidth * width,
      height: box.maxHeight * height,
      child: Semantics(
        button: true,
        label: label,
        child: Tooltip(
          message: label,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              key: ValueKey('desk-hit-$id'),
              behavior: HitTestBehavior.translucent,
              onTap: onTap,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ),
    );
  }
}

class _TodayButton extends StatelessWidget {
  const _TodayButton({
    required this.done,
    required this.captures,
    required this.onTap,
  });

  final bool done;
  final int captures;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Open Today brief',
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
            decoration: BoxDecoration(
              color: const Color(0xFF17110D).withValues(alpha: .82),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  done ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 17,
                  color: done
                      ? Colors.lightGreenAccent
                      : const Color(0xFFF5E5C7),
                ),
                const SizedBox(width: 6),
                Text(
                  captures == 0 ? 'Today' : 'Today · $captures',
                  style: const TextStyle(
                    color: Color(0xFFF5E5C7),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
