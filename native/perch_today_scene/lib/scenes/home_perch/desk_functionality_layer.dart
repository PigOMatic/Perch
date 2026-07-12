import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/brain/perch_brain_scope.dart';
import '../../core/brief/daily_brief_engine.dart';
import '../../core/context/perch_context_snapshot.dart';
import '../../core/desk/desk_object.dart';
import '../../core/email/email_intelligence.dart';
import '../../core/events/perch_event.dart';
import '../../core/recommendations/perch_recommendation.dart';
import '../../data/perch_today_models.dart';

class DeskFunctionalityLayer extends StatefulWidget {
  const DeskFunctionalityLayer({
    super.key,
    required this.data,
    required this.journalFocused,
  });

  final PerchTodayData data;
  final bool journalFocused;

  @override
  State<DeskFunctionalityLayer> createState() => _DeskFunctionalityLayerState();
}

class _DeskFunctionalityLayerState extends State<DeskFunctionalityLayer>
    with SingleTickerProviderStateMixin {
  bool _loaded = false;
  bool _taskDone = false;
  bool _lanternOn = false;
  bool _steamOn = true;
  int _plantStage = 1;
  String _priority = '';
  List<String> _captures = const [];
  late final AnimationController _steam;

  @override
  void initState() {
    super.initState();
    _steam = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300),
    )..repeat();
    _load();
  }

  @override
  void dispose() {
    _steam.dispose();
    super.dispose();
  }

  void _publish(String type, String source, [Map<String, Object?> payload = const {}]) {
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

    setState(() {
      _taskDone = prefs.getBool('perch.task.done') ?? false;
      _lanternOn = prefs.getBool('perch.lantern.on') ?? false;
      _steamOn = prefs.getBool('perch.coffee.steam') ?? true;
      _plantStage =
          (prefs.getInt('perch.plant.stage') ?? 1).clamp(0, 3).toInt();
      _priority = priority;
      _captures = captures;
      _loaded = true;
    });

    _publish(
      PerchEventTypes.priorityChanged,
      'desk.persistence',
      {'text': priority},
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

    final updated = <String>[value, ..._captures];
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
    final intelligence = const EmailIntelligence();
    final ranked = intelligence.rank(
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
          receivedAt: now.subtract(const Duration(hours: 8)),
          senderImportance: 0.7,
          hasAttachment: true,
        ),
      ],
      now: now,
    );

    if (!mounted) return;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Email Intelligence',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              const Text('Prototype ranking until a real inbox is connected.'),
              const SizedBox(height: 14),
              ...ranked.map(
                (item) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    item.level == EmailAttentionLevel.urgent
                        ? Icons.priority_high
                        : Icons.mail_outline,
                  ),
                  title: Text(item.suggestedAction),
                  subtitle: Text(item.reason),
                  trailing: Text('${(item.score * 100).round()}'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Today', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(brief.opening),
              const SizedBox(height: 12),
              ...brief.facts.map((fact) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text('• $fact'),
                  )),
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

  Future<void> _advancePlant() async {
    _activate('plant');
    final next = (_plantStage + 1) % 4;
    setState(() => _plantStage = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('perch.plant.stage', next);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    final brain = PerchBrainScope.of(context);
    return LayoutBuilder(
      builder: (context, box) {
        final portrait = box.maxHeight >= box.maxWidth;
        return IgnorePointer(
          ignoring: widget.journalFocused,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: widget.journalFocused ? 0 : 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _place(
                  box,
                  portrait ? .06 : .05,
                  portrait ? .66 : .63,
                  portrait ? .19 : .11,
                  _deskObject(
                    id: 'coffee',
                    label: 'Coffee',
                    activeId: brain.state.activeDeskObjectId,
                    onTap: () async {
                      _activate('coffee');
                      setState(() => _steamOn = !_steamOn);
                      await _setBool('perch.coffee.steam', _steamOn);
                    },
                    child: _Coffee(steam: _steamOn, animation: _steam),
                  ),
                ),
                _place(
                  box,
                  portrait ? .77 : .84,
                  portrait ? .70 : .67,
                  portrait ? .15 : .09,
                  _deskObject(
                    id: 'pen',
                    label: 'Quick Capture',
                    activeId: brain.state.activeDeskObjectId,
                    onTap: _capture,
                    child: const _IconObject(icon: Icons.edit, label: 'Pen'),
                  ),
                ),
                _place(
                  box,
                  portrait ? .72 : .78,
                  portrait ? .50 : .47,
                  portrait ? .22 : .13,
                  _deskObject(
                    id: 'envelope',
                    label: 'Email Intelligence',
                    activeId: brain.state.activeDeskObjectId,
                    hasNotification: true,
                    onTap: _emailIntelligence,
                    child: const _IconObject(
                      icon: Icons.mail_outline,
                      label: 'Envelope',
                    ),
                  ),
                ),
                _place(
                  box,
                  portrait ? .05 : .06,
                  portrait ? .49 : .45,
                  portrait ? .27 : .16,
                  _deskObject(
                    id: 'sticky_note',
                    label: 'Priority',
                    activeId: brain.state.activeDeskObjectId,
                    rotation: -.035,
                    onTap: _editPriority,
                    child: _Sticky(text: brain.state.priority.isEmpty
                        ? _priority
                        : brain.state.priority),
                  ),
                ),
                _place(
                  box,
                  portrait ? .08 : .10,
                  portrait ? .24 : .17,
                  portrait ? .18 : .10,
                  _deskObject(
                    id: 'plant',
                    label: 'Plant',
                    activeId: brain.state.activeDeskObjectId,
                    onTap: _advancePlant,
                    child: _Plant(stage: _plantStage),
                  ),
                ),
                _place(
                  box,
                  portrait ? .79 : .85,
                  portrait ? .23 : .17,
                  portrait ? .15 : .09,
                  _deskObject(
                    id: 'lantern',
                    label: 'Lantern',
                    activeId: brain.state.activeDeskObjectId,
                    onTap: () async {
                      _activate('lantern');
                      setState(() => _lanternOn = !_lanternOn);
                      await _setBool('perch.lantern.on', _lanternOn);
                    },
                    child: _Lantern(on: _lanternOn),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: SafeArea(
                    child: _TodayButton(
                      done: _taskDone,
                      captures: brain.state.captures.length,
                      onTap: _today,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _deskObject({
    required String id,
    required String label,
    required String? activeId,
    required VoidCallback onTap,
    required Widget child,
    bool hasNotification = false,
    double rotation = 0,
  }) {
    return DeskObject(
      spec: DeskObjectSpec(
        id: id,
        label: label,
        position: Offset.zero,
        widthFactor: 1,
        rotation: rotation,
        hasNotification: hasNotification,
      ),
      focused: activeId == id,
      onTap: onTap,
      child: child,
    );
  }

  Widget _place(
    BoxConstraints box,
    double x,
    double y,
    double w,
    Widget child,
  ) {
    return Positioned(
      left: box.maxWidth * x,
      top: box.maxHeight * y,
      width: box.maxWidth * w,
      child: child,
    );
  }
}

class _IconObject extends StatelessWidget {
  const _IconObject({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1.3,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF6C4B35).withOpacity(.92),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: const Color(0xFFF5E5C7), size: 28),
                Text(
                  label,
                  style: const TextStyle(color: Color(0xFFF5E5C7)),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Coffee extends StatelessWidget {
  const _Coffee({required this.steam, required this.animation});
  final bool steam;
  final AnimationController animation;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: .9,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            const Icon(Icons.coffee, size: 52, color: Color(0xFFF3E7D0)),
            if (steam)
              Positioned(
                top: 0,
                child: AnimatedBuilder(
                  animation: animation,
                  builder: (_, __) => Opacity(
                    opacity: (1 - animation.value).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(
                        5 * (animation.value - .5),
                        -20 * animation.value,
                      ),
                      child: const Icon(
                        Icons.air,
                        color: Colors.white70,
                        size: 29,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}

class _Sticky extends StatelessWidget {
  const _Sticky({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 1.15,
        child: Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFFF2D77D),
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 9,
                offset: Offset(2, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF4A3A23),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
}

class _Plant extends StatelessWidget {
  const _Plant({required this.stage});
  final int stage;

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.grass, Icons.eco, Icons.local_florist, Icons.park];
    const labels = ['Seed', 'Sprout', 'Small', 'Mature'];
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icons[stage], color: const Color(0xFFB8D48B), size: 42),
          Text(
            labels[stage],
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _Lantern extends StatelessWidget {
  const _Lantern({required this.on});
  final bool on;

  @override
  Widget build(BuildContext context) => AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: on ? const Color(0xFFFFC85B).withOpacity(.35) : Colors.black26,
          boxShadow: on
              ? const [
                  BoxShadow(
                    color: Color(0xAAFFB44A),
                    blurRadius: 26,
                    spreadRadius: 7,
                  ),
                ]
              : null,
        ),
        child: Icon(
          on ? Icons.lightbulb : Icons.lightbulb_outline,
          color: on ? const Color(0xFFFFE29A) : const Color(0xFFBBAE99),
          size: 38,
        ),
      );
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
  Widget build(BuildContext context) => MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF17110D).withOpacity(.82),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white24),
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
      );
}
