import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    with TickerProviderStateMixin {
  static const _taskDoneKey = 'perch.task.done';
  static const _stickyKey = 'perch.sticky.priority';
  static const _capturesKey = 'perch.brain.captures';
  static const _plantStageKey = 'perch.plant.stage';
  static const _lanternOnKey = 'perch.lantern.on';
  static const _coffeeSteamKey = 'perch.coffee.steam';

  bool _loaded = false;
  bool _taskDone = false;
  bool _lanternOn = false;
  bool _coffeeSteam = true;
  int _plantStage = 1;
  String _stickyText = '';
  List<String> _captures = const [];

  late final AnimationController _steamController;

  @override
  void initState() {
    super.initState();
    _steamController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _load();
  }

  @override
  void dispose() {
    _steamController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _taskDone = prefs.getBool(_taskDoneKey) ?? false;
      _stickyText = prefs.getString(_stickyKey) ?? widget.data.nextDue.title;
      _captures = prefs.getStringList(_capturesKey) ?? <String>[];
      _plantStage = (prefs.getInt(_plantStageKey) ?? 1).clamp(0, 3);
      _lanternOn = prefs.getBool(_lanternOnKey) ?? false;
      _coffeeSteam = prefs.getBool(_coffeeSteamKey) ?? true;
      _loaded = true;
    });
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _toggleTask() async {
    setState(() => _taskDone = !_taskDone);
    await _saveBool(_taskDoneKey, _taskDone);
  }

  Future<void> _toggleLantern() async {
    setState(() => _lanternOn = !_lanternOn);
    await _saveBool(_lanternOnKey, _lanternOn);
  }

  Future<void> _toggleCoffee() async {
    setState(() => _coffeeSteam = !_coffeeSteam);
    await _saveBool(_coffeeSteamKey, _coffeeSteam);
  }

  Future<void> _advancePlant() async {
    final next = (_plantStage + 1) % 4;
    setState(() => _plantStage = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_plantStageKey, next);
  }

  Future<void> _showQuickCapture() async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Capture'),
        content: TextField(
          controller: controller,
          autofocus: true,
          minLines: 2,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'What do you need to remember?',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.isEmpty) return;
    final updated = <String>[result, ..._captures];
    setState(() => _captures = updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_capturesKey, updated);
  }

  Future<void> _editSticky() async {
    final controller = TextEditingController(text: _stickyText);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Desk Priority'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'One thing that matters most',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Update'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || result.isEmpty) return;
    setState(() => _stickyText = result);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_stickyKey, result);
  }

  Future<void> _showMoney() async {
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
            const SizedBox(height: 18),
            Text(
              'Next due',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(widget.data.nextDue.title),
            Text(widget.data.nextDue.actionLabel),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showTodayStatus() {
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
              const SizedBox(height: 6),
              Text(widget.data.dayStatus),
              const SizedBox(height: 14),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _taskDone,
                onChanged: (_) {
                  Navigator.of(context).pop();
                  _toggleTask();
                },
                title: Text(widget.data.nextDue.title),
                subtitle: Text(widget.data.nextDue.actionLabel),
              ),
              if (_captures.isNotEmpty) ...[
                const Divider(),
                Text('Recent captures', style: Theme.of(context).textTheme.titleSmall),
                const SizedBox(height: 6),
                ..._captures.take(3).map((capture) => Text('• $capture')),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (context, constraints) {
        final portrait = constraints.maxHeight >= constraints.maxWidth;
        return IgnorePointer(
          ignoring: widget.journalFocused,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: widget.journalFocused ? 0 : 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _positioned(
                  constraints,
                  x: portrait ? .07 : .05,
                  y: portrait ? .66 : .64,
                  width: portrait ? .20 : .13,
                  child: _DeskObjectButton(
                    label: 'Coffee',
                    onTap: _toggleCoffee,
                    child: _CoffeeObject(
                      steam: _coffeeSteam,
                      controller: _steamController,
                    ),
                  ),
                ),
                _positioned(
                  constraints,
                  x: portrait ? .76 : .83,
                  y: portrait ? .70 : .68,
                  width: portrait ? .16 : .10,
                  child: _DeskObjectButton(
                    label: 'Capture',
                    onTap: _showQuickCapture,
                    child: const _ObjectCard(icon: Icons.edit, text: 'Pen'),
                  ),
                ),
                _positioned(
                  constraints,
                  x: portrait ? .72 : .77,
                  y: portrait ? .50 : .48,
                  width: portrait ? .22 : .14,
                  child: _DeskObjectButton(
                    label: 'Money',
                    onTap: _showMoney,
                    child: const _ObjectCard(icon: Icons.mail_outline, text: 'Envelope'),
                  ),
                ),
                _positioned(
                  constraints,
                  x: portrait ? .05 : .06,
                  y: portrait ? .49 : .46,
                  width: portrait ? .27 : .17,
                  child: _DeskObjectButton(
                    label: 'Priority',
                    onTap: _editSticky,
                    child: _StickyNote(text: _stickyText),
                  ),
                ),
                _positioned(
                  constraints,
                  x: portrait ? .08 : .10,
                  y: portrait ? .24 : .18,
                  width: portrait ? .18 : .11,
                  child: _DeskObjectButton(
                    label: 'Plant',
                    onTap: _advancePlant,
                    child: _PlantObject(stage: _plantStage),
                  ),
                ),
                _positioned(
                  constraints,
                  x: portrait ? .78 : .84,
                  y: portrait ? .23 : .18,
                  width: portrait ? .16 : .10,
                  child: _DeskObjectButton(
                    label: 'Lantern',
                    onTap: _toggleLantern,
                    child: _LanternObject(on: _lanternOn),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: SafeArea(
                    child: _StatusButton(
                      taskDone: _taskDone,
                      captureCount: _captures.length,
                      onTap: _showTodayStatus,
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

  Widget _positioned(
    BoxConstraints constraints, {
    required double x,
    required double y,
    required double width,
    required Widget child,
  }) {
    return Positioned(
      left: constraints.maxWidth * x,
      top: constraints.maxHeight * y,
      width: constraints.maxWidth * width,
      child: child,
    );
  }
}

class _DeskObjectButton extends StatelessWidget {
  const _DeskObjectButton({
    required this.label,
    required this.onTap,
    required this.child,
  });

  final String label;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: Tooltip(
        message: label,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _ObjectCard extends StatelessWidget {
  const _ObjectCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.35,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF6C4B35).withOpacity(.92),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(.18)),
          boxShadow: const [
            BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 6)),
          ],
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFFF5E5C7), size: 28),
              const SizedBox(height: 3),
              Text(text, style: const TextStyle(color: Color(0xFFF5E5C7))),
            ],
          ),
        ),
      ),
    );
  }
}

class _CoffeeObject extends StatelessWidget {
  const _CoffeeObject({required this.steam, required this.controller});

  final bool steam;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: .9,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          const Positioned(
            bottom: 0,
            child: Icon(Icons.coffee, size: 52, color: Color(0xFFF3E7D0)),
          ),
          if (steam)
            Positioned(
              top: 0,
              child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  final t = controller.value;
                  return Opacity(
                    opacity: (1 - t).clamp(0.0, 1.0),
                    child: Transform.translate(
                      offset: Offset(5 * (t - .5), -20 * t),
                      child: const Icon(
                        Icons.air,
                        color: Colors.white70,
                        size: 30,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _StickyNote extends StatelessWidget {
  const _StickyNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -.035,
      child: AspectRatio(
        aspectRatio: 1.15,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF2D77D),
            borderRadius: BorderRadius.circular(3),
            boxShadow: const [
              BoxShadow(color: Colors.black38, blurRadius: 9, offset: Offset(2, 6)),
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
      ),
    );
  }
}

class _PlantObject extends StatelessWidget {
  const _PlantObject({required this.stage});

  final int stage;

  @override
  Widget build(BuildContext context) {
    const icons = [Icons.grass, Icons.eco, Icons.local_florist, Icons.park];
    const labels = ['Seed', 'Sprout', 'Small', 'Mature'];
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.20),
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

class _LanternObject extends StatelessWidget {
  const _LanternObject({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: on ? const Color(0xFFFFC85B).withOpacity(.35) : Colors.black26,
        boxShadow: on
            ? const [BoxShadow(color: Color(0xAAFFB44A), blurRadius: 26, spreadRadius: 7)]
            : null,
      ),
      child: Icon(
        on ? Icons.lightbulb : Icons.lightbulb_outline,
        color: on ? const Color(0xFFFFE29A) : const Color(0xFFBBAE99),
        size: 38,
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  const _StatusButton({
    required this.taskDone,
    required this.captureCount,
    required this.onTap,
  });

  final bool taskDone;
  final int captureCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
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
                taskDone ? Icons.check_circle : Icons.radio_button_unchecked,
                size: 17,
                color: taskDone ? Colors.lightGreenAccent : const Color(0xFFF5E5C7),
              ),
              const SizedBox(width: 6),
              Text(
                captureCount == 0 ? 'Today' : 'Today · $captureCount',
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
