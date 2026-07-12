import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/brain/perch_brain_scope.dart';
import '../../core/brief/daily_brief_engine.dart';
import '../../core/context/perch_context_snapshot.dart';
import '../../core/email/email_intelligence.dart';
import '../../core/events/perch_event.dart';
import '../../core/recommendations/perch_recommendation.dart';
import '../../data/perch_today_models.dart';
import 'desk_object_sheet.dart';
import 'email_workspace_panel.dart';

/// Invisible, phone-first interaction map laid over the living desk.
///
/// Only tools that reveal or capture useful information are interactive here.
/// Coffee, plant, lantern, and weather remain ambient parts of the room.
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

  void _activate(String id) {
    _publish(
      PerchEventTypes.deskObjectActivated,
      'desk.$id',
      {'id': id},
    );
  }

  Future<void> _openCapture() async {
    _activate('pen');
    final controller = TextEditingController();
    final value = await showDeskObjectSheet<String>(
      context: context,
      semanticsLabel: 'Quick Capture',
      initialChildSize: .52,
      minChildSize: .34,
      maxChildSize: .82,
      builder: (sheetContext) => DeskObjectSheetBody(
        eyebrow: 'Pen',
        title: 'Quick Capture',
        trailing: IconButton(
          tooltip: 'Return to desk',
          onPressed: () => Navigator.pop(sheetContext),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Put the thought down now. Perch can organize it later.',
              style: TextStyle(color: Color(0xFF6F5A46), height: 1.35),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              minLines: 4,
              maxLines: 8,
              textInputAction: TextInputAction.newline,
              decoration: const InputDecoration(
                hintText: 'What do you need to remember?',
                filled: true,
                fillColor: Color(0xCCFFFFFF),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) Navigator.pop(sheetContext, text);
              },
              icon: const Icon(Icons.save_outlined),
              label: const Text('Save capture'),
            ),
            if (_captures.isNotEmpty) ...[
              const SizedBox(height: 22),
              const Text(
                'Recent captures',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              ..._captures.take(3).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Text('• $item'),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
    controller.dispose();

    if (value == null || value.isEmpty || !mounted) return;
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

  Future<void> _openPriority() async {
    _activate('sticky_note');
    final controller = TextEditingController(text: _priority);
    final value = await showDeskObjectSheet<String>(
      context: context,
      semanticsLabel: 'Desk Priority',
      style: DeskObjectSheetStyle.stickyNote,
      initialChildSize: .48,
      minChildSize: .30,
      maxChildSize: .76,
      builder: (sheetContext) => DeskObjectSheetBody(
        eyebrow: 'Sticky note',
        title: 'The one thing that matters most',
        trailing: IconButton(
          tooltip: 'Return to desk',
          onPressed: () => Navigator.pop(sheetContext),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: controller,
              autofocus: true,
              minLines: 3,
              maxLines: 5,
              style: const TextStyle(
                color: Color(0xFF463719),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
              ),
              decoration: const InputDecoration(
                hintText: 'One clear priority',
                filled: true,
                fillColor: Color(0x44FFFFFF),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF755A20),
                foregroundColor: const Color(0xFFFFF1B8),
              ),
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) Navigator.pop(sheetContext, text);
              },
              icon: const Icon(Icons.push_pin_outlined),
              label: const Text('Place on desk'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();

    if (value == null || value.isEmpty || !mounted) return;
    setState(() => _priority = value);
    _publish(
      PerchEventTypes.priorityChanged,
      'desk.sticky_note',
      {'text': value},
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('perch.sticky.priority', value);
  }

  Future<void> _openEmail() async {
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
          senderImportance: .95,
          hasDeadlineLanguage: true,
          hasQuestion: true,
        ),
        EmailSignal(
          id: 'perch',
          sender: 'Perch Project',
          subject: 'Development notes ready to review',
          preview: 'The next Perch changes are ready.',
          receivedAt: now.subtract(const Duration(hours: 8)),
          senderImportance: .7,
          hasAttachment: true,
        ),
      ],
      now: now,
    );
    if (!mounted) return;
    await showEmailWorkspace(context, assessments: ranked);
  }

  Future<void> _openToday() async {
    _activate('today');
    final contextSnapshot = PerchContextSnapshot(
      capturedAt: DateTime.now(),
      lifeMode: 'home',
      energy: .65,
      availableMinutes: 45,
      unreadImportantEmailCount: 1,
      activeProjectIds: const ['perch'],
      calendarPressure: .35,
      financialPressure: .45,
    );
    final recommendations = <PerchRecommendation>[
      PerchRecommendation(
        id: 'priority',
        title: _priority,
        reason: 'This is the priority currently placed on your desk.',
        actionLabel: _taskDone ? 'Choose the next priority' : 'Start here',
        priority: _taskDone ? .35 : .9,
        source: 'sticky_note',
      ),
      if (_captures.isNotEmpty)
        PerchRecommendation(
          id: 'capture',
          title: _captures.first,
          reason: 'This was your most recent quick capture.',
          actionLabel: 'Review capture',
          priority: .6,
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

    await showDeskObjectSheet<void>(
      context: context,
      semanticsLabel: 'Today brief',
      initialChildSize: .68,
      minChildSize: .34,
      maxChildSize: .94,
      builder: (sheetContext) => DeskObjectSheetBody(
        eyebrow: 'Journal',
        title: 'Today',
        trailing: IconButton(
          tooltip: 'Return to desk',
          onPressed: () => Navigator.pop(sheetContext),
          icon: const Icon(Icons.keyboard_arrow_down),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(brief.opening, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 16),
            ...brief.facts.map(
              (fact) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(fact)),
                  ],
                ),
              ),
            ),
            if (brief.recommendation != null) ...[
              const Divider(height: 28),
              Text(
                brief.recommendation!.title,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5),
              Text(brief.recommendation!.reason),
              const SizedBox(height: 8),
              Text(
                brief.recommendation!.actionLabel,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ],
            const Divider(height: 30),
            StatefulBuilder(
              builder: (context, setSheetState) => CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _taskDone,
                title: Text(widget.data.nextDue.title),
                subtitle: Text(widget.data.nextDue.actionLabel),
                onChanged: (value) async {
                  final next = value ?? false;
                  setSheetState(() {});
                  if (mounted) setState(() => _taskDone = next);
                  _publish(
                    PerchEventTypes.taskCompletionChanged,
                    'desk.today',
                    {'completed': next, 'taskId': 'next_due'},
                  );
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('perch.task.done', next);
                },
              ),
            ),
            if (_captures.isNotEmpty) ...[
              const Divider(height: 26),
              const Text('Recent captures', style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              ..._captures.take(4).map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('• $item'),
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
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
                  id: 'pen',
                  label: 'Open quick capture',
                  x: portrait ? .70 : .79,
                  y: portrait ? .61 : .59,
                  width: portrait ? .28 : .18,
                  height: portrait ? .21 : .27,
                  onTap: _openCapture,
                ),
                _hitTarget(
                  box,
                  id: 'envelope',
                  label: 'Open Email Intelligence',
                  x: portrait ? .64 : .71,
                  y: portrait ? .40 : .39,
                  width: portrait ? .35 : .25,
                  height: portrait ? .24 : .25,
                  onTap: _openEmail,
                ),
                _hitTarget(
                  box,
                  id: 'sticky_note',
                  label: 'Open desk priority',
                  x: portrait ? .01 : .025,
                  y: portrait ? .39 : .37,
                  width: portrait ? .38 : .25,
                  height: portrait ? .28 : .30,
                  onTap: _openPriority,
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: SafeArea(
                    child: _TodayButton(
                      done: _taskDone,
                      captures: _captures.length,
                      onTap: _openToday,
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
