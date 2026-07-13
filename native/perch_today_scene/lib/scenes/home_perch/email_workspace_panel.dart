import 'package:flutter/material.dart';

import '../../core/email/email_intelligence.dart';
import 'desk_object_sheet.dart';

Future<void> showEmailWorkspace(
  BuildContext context, {
  required List<EmailAssessment> assessments,
}) {
  return showDeskObjectSheet<void>(
    context: context,
    semanticsLabel: 'Email Intelligence',
    initialChildSize: .72,
    minChildSize: .32,
    maxChildSize: .94,
    builder: (context) => DeskObjectSheetBody(
      eyebrow: 'Envelope',
      title: 'Email Intelligence',
      trailing: IconButton(
        tooltip: 'Return to desk',
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.keyboard_arrow_down),
      ),
      child: assessments.isEmpty
          ? const _EmptyInbox()
          : Column(
              children: [
                for (var index = 0; index < assessments.length; index++) ...[
                  _LetterCard(
                    assessment: assessments[index],
                    index: index,
                  ),
                  if (index != assessments.length - 1)
                    const SizedBox(height: 12),
                ],
              ],
            ),
    ),
  );
}

class _LetterCard extends StatelessWidget {
  const _LetterCard({required this.assessment, required this.index});

  final EmailAssessment assessment;
  final int index;

  @override
  Widget build(BuildContext context) {
    final urgent = assessment.level == EmailAttentionLevel.urgent;
    final important = assessment.level == EmailAttentionLevel.important;
    final accent = urgent
        ? const Color(0xFF9E2C2C)
        : important
            ? const Color(0xFFC3832E)
            : const Color(0xFF71806A);

    return Semantics(
      container: true,
      label: '${assessment.subject}, from ${assessment.sender}',
      child: Transform.rotate(
        angle: index.isEven ? -0.004 : 0.004,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFAEC),
            borderRadius: BorderRadius.circular(12),
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
                width: 7,
                height: 94,
                decoration: BoxDecoration(
                  color: accent,
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
                            assessment.subject,
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
                    const SizedBox(height: 3),
                    Text(
                      assessment.sender,
                      style: const TextStyle(
                        color: Color(0xFF6A5544),
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    if (assessment.preview.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        assessment.preview,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF715D4B),
                          height: 1.35,
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Text(
                      assessment.reason,
                      style: TextStyle(
                        color: accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _PaperAction(
                          label: assessment.suggestedAction,
                          icon: Icons.arrow_forward,
                        ),
                        if (assessment.hasAttachment)
                          const _PaperAction(
                            label: 'Attachment',
                            icon: Icons.attach_file,
                          ),
                        if (assessment.isUnread)
                          const _PaperAction(
                            label: 'Unread',
                            icon: Icons.mark_email_unread_outlined,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE8DBC0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFC4B28F)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF584333)),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF584333),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyInbox extends StatelessWidget {
  const _EmptyInbox();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.mark_email_read_outlined, size: 42),
          SizedBox(height: 12),
          Text(
            'No messages need your attention.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
