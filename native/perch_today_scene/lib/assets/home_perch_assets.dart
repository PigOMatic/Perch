class HomePerchAssets {
  const HomePerchAssets._();

  static const sceneRoot = 'assets/scenes/home_perch';
  static const backgroundRoot = '$sceneRoot/backgrounds';
  static const interactionRoot = '$sceneRoot/interaction';

  static const backgrounds = <HomePerchBackgroundOption>[
    HomePerchBackgroundOption('Dawn', '$backgroundRoot/background_dawn.png'),
    HomePerchBackgroundOption('Morning', '$backgroundRoot/background_morning.png'),
    HomePerchBackgroundOption('Afternoon', '$backgroundRoot/background_afternoon.png'),
    HomePerchBackgroundOption('Golden', '$backgroundRoot/background_golden_hour.png'),
    HomePerchBackgroundOption('Night', '$backgroundRoot/background_night.png'),
    HomePerchBackgroundOption('Rain', '$backgroundRoot/background_rain.png'),
    HomePerchBackgroundOption('Snow', '$backgroundRoot/background_snow.png'),
    HomePerchBackgroundOption('Storm', '$backgroundRoot/background_storm.png'),
  ];

  static const deskInteractionBackground =
      '$interactionRoot/desk_reference_background.png';
  static const journalOpenToday = '$interactionRoot/journal_open_today.png';

  static const background = '$sceneRoot/background_cabin_desk.png';
  static const deskSurface = '$sceneRoot/desk_surface.webp';
  static const morningLight = '$sceneRoot/morning_light_overlay.webp';
  static const notebook = '$sceneRoot/notebook_open_blank.webp';
  static const envelope = '$sceneRoot/envelope_cash_blank.webp';
  static const sticky = '$sceneRoot/sticky_note_blank.webp';
  static const shiftTicket = '$sceneRoot/shift_ticket_blank.webp';
  static const coffeeMug = '$sceneRoot/coffee_mug.webp';
  static const pen = '$sceneRoot/pen.webp';
  static const badge = '$sceneRoot/icu_badge.webp';
}

class HomePerchBackgroundOption {
  const HomePerchBackgroundOption(this.label, this.assetPath);

  final String label;
  final String assetPath;
}
