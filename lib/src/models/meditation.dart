class SimpleMeditation {
  String name;
  Duration duration;

  SimpleMeditation(
      {this.name = "Generated Meditation", this.duration = Duration.zero});

  String formattedDuration() {
    return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
  }
}

class Meditation extends SimpleMeditation {
  String id = '';
  String? url;
  String meditationText = '';

  Meditation.blank() : super();

  Meditation({this.id = '', this.url, required this.meditationText}) : super();
}
