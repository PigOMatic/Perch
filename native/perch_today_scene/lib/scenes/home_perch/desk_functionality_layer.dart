import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/perch_today_models.dart';
import 'desk_visual_objects.dart';

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

class _DeskFunctionalityLayerState extends State<DeskFunctionalityLayer> {
  bool _loaded = false;
  bool _taskDone = false;
  bool _lanternOn = false;
  int _plantStage = 1;
  String _priority = '';
  List<String> _captures = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _taskDone = prefs.getBool('perch.task.done') ?? false;
      _lanternOn = prefs.getBool('perch.lantern.on') ?? false;
      _plantStage = (prefs.getInt('perch.plant.stage') ?? 1).clamp(0, 3).toInt();
      _priority = prefs.getString('perch.sticky.priority') ?? widget.data.nextDue.title;
      _captures = prefs.getStringList('perch.brain.captures') ?? <String>[];
      _loaded = true;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _capture() async {
    final value = await _textDialog(
      title: 'Quick Capture',
      initial: '',
      hint: 'What do you need to remember?',
    );
    if (value == null || value.isEmpty) return;
    final updated = <String>[value, ..._captures];
    setState(() => _captures = updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('perch.brain.captures', updated);
  }

  Future<void> _editPriority() async {
    final value = await _textDialog(
      title: 'Desk Priority',
      initial: _priority,
      hint: 'One thing that matters most',
    );
    if (value == null || value.isEmpty) return;
    setState(() => _priority = value);
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

  Future<void> _money() async {
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Money'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.money.availableText,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(widget.data.money.safeThroughText),
            const Divider(height: 28),
            Text('Next due', style: Theme.of(context).textTheme.labelLarge),
            Text(widget.data.nextDue.title),
            Text(widget.data.nextDue.actionLabel),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _today() {
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
              Text(widget.data.dayStatus),
              const SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _taskDone,
                title: Text(widget.data.nextDue.title),
                subtitle: Text(widget.data.nextDue.actionLabel),
                onChanged: (_) async {
                  Navigator.pop(context);
                  setState(() => _taskDone = !_taskDone);
                  await _setBool('perch.task.done', _taskDone);
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
    final next = (_plantStage + 1) % 4;
    setState(() => _plantStage = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('perch.plant.stage', next);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, box) {
        final portrait = box.maxHeight >= box.maxWidth;
        return IgnorePointer(
          ignoring: widget.journalFocused,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 240),
            opacity: widget.journalFocused ? 0 : 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _place(
                  box,
                  portrait ? .72 : .78,
                  portrait ? .50 : .47,
                  portrait ? .22 : .13,
                  DeskPropTapTarget(
                    label: 'Money',
                    onTap: _money,
                    rotation: -.035,
                    child: const DeskEnvelopeProp(),
                  ),
                ),
                _place(
                  box,
                  portrait ? .05 : .06,
                  portrait ? .49 : .45,
                  portrait ? .27 : .16,
                  DeskPropTapTarget(
                    label: 'Priority',
                    onTap: _editPriority,
                    rotation: -.045,
                    hitPadding: const EdgeInsets.all(16),
                    child: DeskStickyProp(text: _priority),
                  ),
                ),
                _place(
                  box,
                  portrait ? .08 : .10,
                  portrait ? .24 : .17,
                  portrait ? .18 : .10,
                  DeskPropTapTarget(
                    label: 'Plant',
                    onTap: _advancePlant,
                    rotation: .015,
                    child: DeskPlantProp(stage: _plantStage),
                  ),
                ),
                _place(
                  box,
                  portrait ? .79 : .85,
                  portrait ? .23 : .17,
                  portrait ? .15 : .09,
                  DeskPropTapTarget(
                    label: 'Lantern',
                    onTap: () async {
                      setState(() => _lanternOn = !_lanternOn);
                      await _setBool('perch.lantern.on', _lanternOn);
                    },
                    child: DeskLanternProp(on: _lanternOn),
                  ),
                ),
                _place(
                  box,
                  portrait ? .64 : .69,
                  portrait ? .78 : .79,
                  portrait ? .28 : .18,
                  DeskPropTapTarget(
                    label: 'Quick Capture',
                    onTap: _capture,
                    rotation: -.23,
                    hitPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: const DeskPenProp(),
                  ),
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
            ),
          ),
        );
      },
    );
  }

  Widget _place(
    BoxConstraints box,
    double x,
    double y,
    double width,
    Widget child,
  ) {
    return Positioned(
      left: box.maxWidth * x,
      top: box.maxHeight * y,
      width: box.maxWidth * width,
      child: child,
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF17110D).withOpacity(.82),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white24),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
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
    );
  }
}
