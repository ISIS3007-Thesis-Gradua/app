class SimpleMeditation {
  String name = "Generic Meditation";
  Duration duration = Duration(seconds: 0);

  SimpleMeditation.blank();

  SimpleMeditation({required this.name, required this.duration});

  String formattedDuration() {
    return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
  }
}

class Meditation extends SimpleMeditation {
  String id = '';
  String? url;

  Meditation.blank() : super.blank();

  Meditation(
      {required this.id,
      this.url,
      required String name,
      required Duration duration})
      : super(name: name, duration: duration);
}
