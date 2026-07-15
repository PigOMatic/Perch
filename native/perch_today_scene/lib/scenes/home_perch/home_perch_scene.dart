import 'dart:ui';

import 'package:flutter/material.dart';

import '../../assets/home_perch_assets.dart';
import '../../data/perch_today_models.dart';
import '../../widgets/perch_asset_layer.dart';
import '../../world/perch_world_state.dart';
import 'desk_rollup_panel.dart';

class HomePerchScene extends StatefulWidget {
  const HomePerchScene({
    super.key,
    required this.data,
    required this.worldState,
  });

  final PerchTodayData data;
  final PerchWorldState worldState;

  @override
  State<HomePerchScene> createState() => _HomePerchSceneState();
}

class _HomePerchSceneState extends State<HomePerchScene> {
  DeskRollupSpec? _activePanel;

  static const _journal = DeskRollupSpec(
    id: 'journal',
    title: 'Journal',
    subtitle: 'Your day, plans, and thoughts.',
    icon: Icons.menu_book_rounded,
    accent: Color(0xFF7B4D2B),
    entries: ['Today', 'This Week', 'Projects', 'Brain Inbox', 'Recent Notes'],
  );

  static const _drink = DeskRollupSpec(
    id: 'drink',
    title: 'Daily Energy',
    subtitle: 'A quiet check-in with what is fueling you.',
    icon: Icons.local_cafe_rounded,
    accent: Color(0xFF8A542F),
    entries: ['Water today', 'Coffee & caffeine', 'Tea', 'Energy check', 'Choose desk drink'],
  );

  static const _note = DeskRollupSpec(
    id: 'note',
    title: 'Quick Capture',
    subtitle: 'Get it out of your head before it disappears.',
    icon: Icons.sticky_note_2_rounded,
    accent: Color(0xFFB18324),
    entries: ['New thought', 'New task', 'Remember later', 'Ask Perch', 'Recent captures'],
  );

  static const _mail = DeskRollupSpec(
    id: 'mail',
    title: 'Correspondence',
    subtitle: 'Only the messages that may matter to your life.',
    icon: Icons.mark_email_unread_rounded,
    accent: Color(0xFF7B3F35),
    entries: ['Needs your attention', 'Bills & renewals', 'Travel', 'Project updates', 'Review email signals'],
  );

  static const _plant = DeskRollupSpec(
    id: 'plant',
    title: 'Growth',
    subtitle: 'A reflection of steady progress, never punishment.',
    icon: Icons.spa_rounded,
    accent: Color(0xFF477346),
    entries: ['Current growth', 'Habits', 'Health', 'Sleep & recovery', 'Plant story'],
  );

  static const _lantern = DeskRollupSpec(
    id: 'lantern',
    title: 'Ambience',
    subtitle: 'Shape the feeling of your Perch.',
    icon: Icons.light_mode_rounded,
    accent: Color(0xFFC2762A),
    entries: ['Lantern glow', 'Time of day', 'Weather ambience', 'Quiet mode', 'Soundscape'],
  );

  static const _photo = DeskRollupSpec(
    id: 'photo',
    title: 'Memories',
    subtitle: 'Small pieces of life that quietly stay with you.',
    icon: Icons.photo_library_rounded,
    accent: Color(0xFF6D587D),
    entries: ['Featured memory', 'Family', 'Trips', 'Recent moments', 'Desk photo rotation'],
  );

  static const _shelf = DeskRollupSpec(
    id: 'shelf',
    title: 'Collection',
    subtitle: 'Stickers, charms, souvenirs, and things you have earned.',
    icon: Icons.auto_awesome_rounded,
    accent: Color(0xFF4B6E79),
    entries: ['Desk collectibles', 'Journal stickers', 'Travel souvenirs', 'Memory objects', 'Arrange later'],
  );

  static const _world = DeskRollupSpec(
    id: 'world',
    title: 'Your World',
    subtitle: 'The landscape beyond your desk will grow with your life.',
    icon: Icons.landscape_rounded,
    accent: Color(0xFF3F6770),
    entries: ['World view placeholder', 'Home', 'Trails', 'Places & travel', 'World evolution'],
  );

  void _open(DeskRollupSpec spec) => setState(() => _activePanel = spec);

  void _close() => setState(() => _activePanel = null);

  @override
  Widget build(BuildContext context) {
    final panelOpen = _activePanel != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 460),
              curve: Curves.easeOutCubic,
              scale: panelOpen ? 1.025 : 1,
              child: PerchAssetLayer(
                assetPath: HomePerchAssets.deskInteractionBackground,
                fit: BoxFit.cover,
                alignment: Alignment.center,
                fallback: const _BackgroundMissingFallback(
                  assetPath: HomePerchAssets.deskInteractionBackground,
                ),
              ),
            ),
            _DeskHitRegions(
              enabled: !panelOpen,
              onJournal: () => _open(_journal),
              onDrink: () => _open(_drink),
              onNote: () => _open(_note),
              onMail: () => _open(_mail),
              onPlant: () => _open(_plant),
              onLantern: () => _open(_lantern),
              onPhoto: () => _open(_photo),
              onShelf: () => _open(_shelf),
              onWorld: () => _open(_world),
            ),
            IgnorePointer(
              ignoring: !panelOpen,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: panelOpen ? 1 : 0,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _close,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: panelOpen ? 4 : 0,
                      sigmaY: panelOpen ? 4 : 0,
                    ),
                    child: ColoredBox(
                      color: Colors.black.withValues(alpha: 0.30),
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 520),
              curve: Curves.easeOutCubic,
              alignment: panelOpen ? Alignment.bottomCenter : const Alignment(0, 1.9),
              child: IgnorePointer(
                ignoring: !panelOpen,
                child: SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight * 0.68,
                  child: _activePanel == null
                      ? const SizedBox.shrink()
                      : DeskRollupPanel(spec: _activePanel!, onClose: _close),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DeskHitRegions extends StatelessWidget {
  const _DeskHitRegions({
    required this.enabled,
    required this.onJournal,
    required this.onDrink,
    required this.onNote,
    required this.onMail,
    required this.onPlant,
    required this.onLantern,
    required this.onPhoto,
    required this.onShelf,
    required this.onWorld,
  });

  final bool enabled;
  final VoidCallback onJournal;
  final VoidCallback onDrink;
  final VoidCallback onNote;
  final VoidCallback onMail;
  final VoidCallback onPlant;
  final VoidCallback onLantern;
  final VoidCallback onPhoto;
  final VoidCallback onShelf;
  final VoidCallback onWorld;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.biggest;

          Widget region(
            String label,
            double left,
            double top,
            double width,
            double height,
            VoidCallback onTap,
          ) {
            return Positioned(
              left: size.width * left,
              top: size.height * top,
              width: size.width * width,
              height: size.height * height,
              child: Semantics(
                button: true,
                label: label,
                child: Tooltip(
                  message: label,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onTap,
                      child: const SizedBox.expand(),
                    ),
                  ),
                ),
              ),
            );
          }

          return Stack(
            children: [
              region('Open journal', 0.25, 0.51, 0.50, 0.30, onJournal),
              region('Daily energy', 0.00, 0.56, 0.27, 0.27, onDrink),
              region('Quick capture', 0.69, 0.65, 0.28, 0.22, onNote),
              region('Correspondence', 0.70, 0.47, 0.28, 0.18, onMail),
              region('Growth', 0.00, 0.10, 0.28, 0.34, onPlant),
              region('Ambience', 0.70, 0.14, 0.28, 0.32, onLantern),
              region('Memories', 0.68, 0.30, 0.22, 0.17, onPhoto),
              region('Collection', 0.00, 0.00, 0.28, 0.16, onShelf),
              region('Enter world view', 0.22, 0.00, 0.56, 0.40, onWorld),
            ],
          );
        },
      ),
    );
  }
}

class _BackgroundMissingFallback extends StatelessWidget {
  const _BackgroundMissingFallback({required this.assetPath});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1D140E),
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: Text(
        'Perch image missing.\nPlace this file in the project:\n$assetPath',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFF6E8C8),
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
