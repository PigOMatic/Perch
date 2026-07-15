import 'package:flutter/material.dart';

import 'perch_scene_set.dart';

class SceneRollupWorkspace extends StatelessWidget {
  const SceneRollupWorkspace({
    super.key,
    required this.hitbox,
    required this.onClose,
  });

  final PerchSceneHitbox hitbox;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final theme = _themeFor(hitbox.action);

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: theme.colors,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.58),
              blurRadius: 42,
              offset: const Offset(0, -12),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 54,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.28),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 14, 14),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: theme.accent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(theme.icon, color: theme.accent, size: 27),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            theme.title,
                            style: const TextStyle(
                              color: Color(0xFFFFF4DC),
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            theme.subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.66),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Return to desk',
                      onPressed: onClose,
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, color: Colors.white.withValues(alpha: 0.09)),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: _PlaceholderBody(theme: theme),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceholderBody extends StatelessWidget {
  const _PlaceholderBody({required this.theme});

  final _WorkspaceTheme theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: theme.accent.withValues(alpha: 0.20)),
          ),
          child: Row(
            children: [
              Icon(theme.icon, color: theme.accent, size: 34),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  theme.placeholder,
                  style: const TextStyle(
                    color: Color(0xFFFFF4DC),
                    fontSize: 17,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            itemCount: 3,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) => Container(
              height: 68,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.055),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              child: Text(
                '${theme.sampleLabels[index]}  ·  placeholder',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.70),
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

_WorkspaceTheme _themeFor(String action) {
  switch (action) {
    case 'openJournal':
      return const _WorkspaceTheme(
        title: 'Journal',
        subtitle: 'Reflect, plan, and move forward.',
        placeholder: 'The live journal workspace will live here.',
        icon: Icons.menu_book_rounded,
        accent: Color(0xFFD9B36C),
        colors: [Color(0xFF2C1B12), Color(0xFF17100C)],
        sampleLabels: ['Today', 'Week', 'Brain'],
      );
    case 'customizeDrink':
      return const _WorkspaceTheme(
        title: 'Your Drink',
        subtitle: 'Coffee, tea, water, or whatever belongs on your desk.',
        placeholder: 'Choose the vessel and drink that feels like you.',
        icon: Icons.local_cafe_rounded,
        accent: Color(0xFFC98D5B),
        colors: [Color(0xFF3A2419), Color(0xFF1A1210)],
        sampleLabels: ['Coffee mug', 'Water bottle', 'Tea cup'],
      );
    case 'openEmailIntelligence':
      return const _WorkspaceTheme(
        title: 'Correspondence',
        subtitle: 'Only the messages that matter.',
        placeholder: 'Perch email signals and relevant correspondence will surface here.',
        icon: Icons.mark_email_unread_rounded,
        accent: Color(0xFFD7A96E),
        colors: [Color(0xFF352116), Color(0xFF16100C)],
        sampleLabels: ['Needs review', 'Trip update', 'Bill notice'],
      );
    case 'editPriority':
      return const _WorkspaceTheme(
        title: 'Desk Note',
        subtitle: 'One quiet reminder in plain sight.',
        placeholder: 'Write or replace the note that should stay visible on your desk.',
        icon: Icons.sticky_note_2_rounded,
        accent: Color(0xFFF0D370),
        colors: [Color(0xFF4A3B16), Color(0xFF211B0F)],
        sampleLabels: ['Focus note', 'Reminder', 'Tomorrow'],
      );
    case 'inspectGrowth':
      return const _WorkspaceTheme(
        title: 'Growth',
        subtitle: 'A quiet reflection of progress.',
        placeholder: 'Plant type, current growth stage, and the life signals feeding it will appear here.',
        icon: Icons.eco_rounded,
        accent: Color(0xFF82C788),
        colors: [Color(0xFF173021), Color(0xFF0D1711)],
        sampleLabels: ['Plant choice', 'Growth stage', 'Recent progress'],
      );
    case 'toggleLamp':
      return const _WorkspaceTheme(
        title: 'Lantern',
        subtitle: 'Light and ambience.',
        placeholder: 'Manual lighting controls and automatic ambience rules will live here.',
        icon: Icons.light_mode_rounded,
        accent: Color(0xFFFFC766),
        colors: [Color(0xFF3D2813), Color(0xFF181006)],
        sampleLabels: ['Warm glow', 'Auto mode', 'Storm mode'],
      );
    case 'openMemories':
      return const _WorkspaceTheme(
        title: 'Memories',
        subtitle: 'The quiet things your desk remembers.',
        placeholder: 'Photos, drawings, trip memories, and featured moments will appear here.',
        icon: Icons.photo_library_rounded,
        accent: Color(0xFFB6A6D9),
        colors: [Color(0xFF292137), Color(0xFF14101B)],
        sampleLabels: ['Family', 'Travel', 'Recent memory'],
      );
    case 'enterWorld':
      return const _WorkspaceTheme(
        title: 'Your World',
        subtitle: 'Step away from the desk.',
        placeholder: 'This becomes the transition into the evolving master landscape.',
        icon: Icons.landscape_rounded,
        accent: Color(0xFF79B7C9),
        colors: [Color(0xFF17313A), Color(0xFF0B171B)],
        sampleLabels: ['Home', 'Trail', 'World view'],
      );
    default:
      return const _WorkspaceTheme(
        title: 'Quick Capture',
        subtitle: 'Get it out of your head.',
        placeholder: 'Fast capture for notes, tasks, ideas, and loose thoughts.',
        icon: Icons.edit_note_rounded,
        accent: Color(0xFF9DC4C7),
        colors: [Color(0xFF1D3031), Color(0xFF0E1718)],
        sampleLabels: ['Thought', 'Task', 'Idea'],
      );
  }
}

class _WorkspaceTheme {
  const _WorkspaceTheme({
    required this.title,
    required this.subtitle,
    required this.placeholder,
    required this.icon,
    required this.accent,
    required this.colors,
    required this.sampleLabels,
  });

  final String title;
  final String subtitle;
  final String placeholder;
  final IconData icon;
  final Color accent;
  final List<Color> colors;
  final List<String> sampleLabels;
}
