import 'package:flutter/material.dart';

import '../../data/perch_today_models.dart';
import 'journal_workspace_sheet.dart';
import 'live_journal_content.dart';

class JournalEngine extends StatefulWidget {
  const JournalEngine({
    super.key,
    required this.data,
    required this.focused,
  });

  final PerchTodayData data;
  final bool focused;

  @override
  State<JournalEngine> createState() => _JournalEngineState();
}

class _JournalEngineState extends State<JournalEngine> {
  final PageController _controller = PageController();
  int _pageIndex = 0;

  static const _labels = ['Today', 'Week', 'Brain', 'Notes'];

  void _goTo(int index) {
    if (index < 0 || index >= _labels.length) return;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.focused) {
      return Semantics(
        button: true,
        label: 'Open journal',
        child: GestureDetector(
          key: const ValueKey('open-journal-workspace'),
          behavior: HitTestBehavior.opaque,
          onTap: () => showJournalWorkspace(context, data: widget.data),
          child: LiveJournalContent(data: widget.data, focused: false),
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned.fill(
          child: PageView(
            controller: _controller,
            onPageChanged: (index) => setState(() => _pageIndex = index),
            children: [
              LiveJournalContent(data: widget.data, focused: true),
              _JournalModulePage(
                title: 'Week',
                subtitle: 'Your next few steps',
                lines: [
                  ...widget.data.shifts.map(
                    (shift) => '${shift.day}  ${shift.unit} · ${shift.time}',
                  ),
                  widget.data.money.safeThroughText,
                ],
              ),
              _JournalModulePage(
                title: 'Brain',
                subtitle: 'What you captured',
                lines: [
                  widget.data.brainNote,
                  widget.data.resetLine,
                  widget.data.nextDue.title,
                ],
              ),
              const _JournalModulePage(
                title: 'Notes',
                subtitle: 'A quiet place to think',
                lines: [
                  'One thing at a time.',
                  'Write what matters next.',
                  'The rest can wait.',
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 18,
          right: 18,
          top: 8,
          child: _JournalTabs(
            labels: _labels,
            selectedIndex: _pageIndex,
            onSelected: _goTo,
          ),
        ),
        Positioned(
          right: 8,
          top: 72,
          child: _PaperclipControl(
            enabled: _pageIndex < _labels.length - 1,
            onTap: () => _goTo(_pageIndex + 1),
          ),
        ),
      ],
    );
  }
}

class _JournalTabs extends StatelessWidget {
  const _JournalTabs({
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(labels.length, (index) {
        final selected = index == selectedIndex;
        return Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: selected
                    ? const Color(0xFF8B5E3C)
                    : const Color(0xFFD8BE91).withValues(alpha: 0.88),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(9),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: selected
                      ? const Color(0xFFFFF4DD)
                      : const Color(0xFF4A3425),
                  fontWeight: FontWeight.w700,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _PaperclipControl extends StatelessWidget {
  const _PaperclipControl({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: enabled ? 1 : 0.35,
        child: Container(
          width: 34,
          height: 66,
          decoration: BoxDecoration(
            color: const Color(0xFFD6C7A7).withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF88765E), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(
            Icons.attach_file,
            color: Color(0xFF5B4A39),
            size: 22,
          ),
        ),
      ),
    );
  }
}

class _JournalModulePage extends StatelessWidget {
  const _JournalModulePage({
    required this.title,
    required this.subtitle,
    required this.lines,
  });

  final String title;
  final String subtitle;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(64, 56, 64, 34),
      child: Row(
        children: [
          Expanded(
            child: _PaperColumn(
              title: title,
              subtitle: subtitle,
              lines: lines.take((lines.length + 1) ~/ 2).toList(),
            ),
          ),
          const SizedBox(width: 42),
          Expanded(
            child: _PaperColumn(
              title: 'Details',
              subtitle: 'Keep moving gently',
              lines: lines.skip((lines.length + 1) ~/ 2).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaperColumn extends StatelessWidget {
  const _PaperColumn({
    required this.title,
    required this.subtitle,
    required this.lines,
  });

  final String title;
  final String subtitle;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8EFD8), Color(0xFFE9D5AE)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Color(0xFF302219),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontFamily: 'Georgia',
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Color(0xFF8A4934),
            ),
          ),
          const SizedBox(height: 18),
          ...lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 11,
                    height: 11,
                    margin: const EdgeInsets.only(top: 4, right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF57402F)),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      line,
                      style: const TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 13,
                        height: 1.25,
                        color: Color(0xFF35271D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
