import 'dart:ui';

import 'package:flutter/material.dart';

enum DeskWorkspaceTone { journal, paper, sticky, email }

class DeskWorkspaceTheme {
  const DeskWorkspaceTheme({
    required this.background,
    required this.foreground,
    required this.muted,
    required this.accent,
  });

  final Color background;
  final Color foreground;
  final Color muted;
  final Color accent;

  static DeskWorkspaceTheme forTone(DeskWorkspaceTone tone) {
    return switch (tone) {
      DeskWorkspaceTone.journal => const DeskWorkspaceTheme(
          background: Color(0xFFF4E8CE),
          foreground: Color(0xFF35261D),
          muted: Color(0xFF786451),
          accent: Color(0xFF6A3F28),
        ),
      DeskWorkspaceTone.paper => const DeskWorkspaceTheme(
          background: Color(0xFFF4EAD6),
          foreground: Color(0xFF33261F),
          muted: Color(0xFF756455),
          accent: Color(0xFF4F6650),
        ),
      DeskWorkspaceTone.sticky => const DeskWorkspaceTheme(
          background: Color(0xFFF3DE8A),
          foreground: Color(0xFF463719),
          muted: Color(0xFF745F2E),
          accent: Color(0xFF755A20),
        ),
      DeskWorkspaceTone.email => const DeskWorkspaceTheme(
          background: Color(0xFFF0E4C8),
          foreground: Color(0xFF36261B),
          muted: Color(0xFF75614E),
          accent: Color(0xFF8C2F2F),
        ),
    };
  }
}

Future<T?> showDeskWorkspace<T>(
  BuildContext context, {
  required String title,
  required String subtitle,
  required Widget child,
  DeskWorkspaceTone tone = DeskWorkspaceTone.paper,
  IconData? icon,
  bool expandOnDesktop = false,
}) {
  final theme = DeskWorkspaceTheme.forTone(tone);
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: .42),
    builder: (context) => _DeskWorkspaceSheet(
      title: title,
      subtitle: subtitle,
      icon: icon,
      theme: theme,
      expandOnDesktop: expandOnDesktop,
      child: child,
    ),
  );
}

class _DeskWorkspaceSheet extends StatelessWidget {
  const _DeskWorkspaceSheet({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.theme,
    required this.expandOnDesktop,
    this.icon,
  });

  final String title;
  final String subtitle;
  final Widget child;
  final DeskWorkspaceTheme theme;
  final bool expandOnDesktop;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final phone = constraints.maxWidth < 680;
        final maxHeight = phone
            ? constraints.maxHeight * .90
            : constraints.maxHeight * (expandOnDesktop ? .88 : .76);
        final maxWidth = phone ? constraints.maxWidth : 760.0;

        return Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth, maxHeight: maxHeight),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                child: Material(
                  color: theme.background.withValues(alpha: .985),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      Container(
                        width: 46,
                        height: 5,
                        decoration: BoxDecoration(
                          color: theme.foreground.withValues(alpha: .24),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 10, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (icon != null) ...[
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: theme.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(icon, color: theme.background),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: TextStyle(
                                      color: theme.foreground,
                                      fontSize: phone ? 22 : 26,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -.35,
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      color: theme.muted,
                                      fontSize: 13,
                                      height: 1.25,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              tooltip: 'Return to desk',
                              onPressed: () => Navigator.pop(context),
                              icon: Icon(Icons.keyboard_arrow_down, color: theme.foreground),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: theme.foreground.withValues(alpha: .12)),
                      Flexible(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                            phone ? 16 : 22,
                            16,
                            phone ? 16 : 22,
                            28 + MediaQuery.viewInsetsOf(context).bottom,
                          ),
                          child: DefaultTextStyle.merge(
                            style: TextStyle(color: theme.foreground),
                            child: child,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
