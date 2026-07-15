import 'package:flutter/material.dart';

class DeskRollupSpec {
  const DeskRollupSpec({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.entries,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final List<String> entries;
}

class DeskRollupPanel extends StatelessWidget {
  const DeskRollupPanel({
    super.key,
    required this.spec,
    required this.onClose,
  });

  final DeskRollupSpec spec;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF3E4C4),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border(top: BorderSide(color: spec.accent.withValues(alpha: 0.45), width: 2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x88000000),
              blurRadius: 42,
              spreadRadius: 8,
              offset: Offset(0, -10),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6B5844).withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: spec.accent.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(spec.icon, color: spec.accent, size: 27),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            spec.title,
                            style: const TextStyle(
                              color: Color(0xFF2D2016),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            spec.subtitle,
                            style: TextStyle(
                              color: const Color(0xFF5F4C3B).withValues(alpha: 0.82),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Close',
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded, color: Color(0xFF493727)),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: spec.entries.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final entry = spec.entries[index];
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFF6C523B).withValues(alpha: 0.14)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(color: spec.accent, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                entry,
                                style: const TextStyle(
                                  color: Color(0xFF332419),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, color: Color(0xFF6C523B)),
                          ],
                        ),
                      );
                    },
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
