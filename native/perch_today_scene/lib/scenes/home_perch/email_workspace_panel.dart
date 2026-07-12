import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/email/email_intelligence.dart';

Future<void> showEmailWorkspace(
  BuildContext context, {
  required List<EmailAssessment> assessments,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierLabel: 'Close email workspace',
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.44),
    transitionDuration: const Duration(milliseconds: 460),
    pageBuilder: (context, animation, secondaryAnimation) {
      return _EmailWorkspacePanel(assessments: assessments);
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.08, 0),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class _EmailWorkspacePanel extends StatelessWidget {
  const _EmailWorkspacePanel({required this.assessments});

  final List<EmailAssessment> assessments;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        minimum: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 680;
            final width = compact
                ? constraints.maxWidth
                : constraints.maxWidth.clamp(520.0, 760.0);

            return Align(
              alignment: compact ? Alignment.bottomCenter : Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: width,
                  maxHeight: compact
                      ? constraints.maxHeight * 0.88
                      : constraints.maxHeight,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(compact ? 24 : 18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0E4C8).withValues(alpha: 0.97),
                        border: Border.all(
                          color: const Color(0xFF5A3D27).withValues(alpha: 0.42),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x66000000),
                            blurRadius: 34,
                            offset: Offset(-12, 12),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          const Positioned.fill(child: _PaperTexture()),
                          Column(
                            children: [
                              _WorkspaceHeader(onClose: () => Navigator.pop(context)),
                              Expanded(
                                child: assessments.isEmpty
                                    ? const _EmptyInbox()
                                    : ListView.separated(
                                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                                        itemCount: assessments.length,
                                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                                        itemBuilder: (context, index) {
                                          return _LetterCard(
                                            assessment: assessments[index],
                                            index: index,
                                          );
                                        },
                                      ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _WorkspaceHeader extends StatelessWidget {
  const _WorkspaceHeader({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 14, 10),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              color: Color(0xFF8C2F2F),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x44000000),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.mail_outline, color: Color(0xFFFFE9C9)),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Email Intelligence',
                  style: TextStyle(
                    color: Color(0xFF36261B),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'The letters that deserve your attention first',
                  style: TextStyle(
                    color: Color(0xFF75614E),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Return letters to envelope',
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Color(0xFF4B382A)),
          ),
        ],
      ),
    );
  }
}

class _LetterCard extends StatelessWidget {
  const _LetterCard({required this.assessment, required this.index});

  final EmailAssessment assessment;
  final int index;

  @override
  Widget build(BuildContext context) {
    final urgent = assessment.level == EmailAttentionLevel.urgent;
    final important = assessment.level == EmailAttentionLevel.important;

    return Transform.rotate(
      angle: index.isEven ? -0.006 : 0.005,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFAEC),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFBFAF91)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 72,
              decoration: BoxDecoration(
                color: urgent
                    ? const Color(0xFF9E2C2C)
                    : important
                        ? const Color(0xFFC3832E)
                        : const Color(0xFF71806A),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          assessment.suggestedAction,
                          style: const TextStyle(
                            color: Color(0xFF35271E),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      _ScoreSeal(score: assessment.score),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    assessment.reason,
                    style: const TextStyle(
                      color: Color(0xFF715D4B),
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _PaperAction(label: 'Open letter', icon: Icons.drafts_outlined),
                      _PaperAction(label: 'Draft reply', icon: Icons.edit_note),
                      _PaperAction(label: 'Later', icon: Icons.schedule),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreSeal extends StatelessWidget {
  const _ScoreSeal({required this.score});

  final double score;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF7E2929),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0x33000000), blurRadius: 5, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        '${(score * 100).round()}',
        style: const TextStyle(
          color: Color(0xFFFFE7C0),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _PaperAction extends StatelessWidget {
  const _PaperAction({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {},
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE8DBC0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFC4B28F)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: const Color(0xFF584333)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF584333),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'No letters need your attention.',
          style: TextStyle(color: Color(0xFF6D5948), fontSize: 16),
        ),
      ),
    );
  }
}

class _PaperTexture extends StatelessWidget {
  const _PaperTexture();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _PaperTexturePainter());
  }
}

class _PaperTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF8F795F).withValues(alpha: 0.055)
      ..strokeWidth = 1;
    for (double y = 72; y < size.height; y += 26) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final marginPaint = Paint()
      ..color = const Color(0xFF9E4F43).withValues(alpha: 0.08)
      ..strokeWidth = 1.2;
    canvas.drawLine(const Offset(68, 0), Offset(68, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
