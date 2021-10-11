import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

const String _positionDataSreamKey = "positionData-stream";
const String _playerStateStreamKey = "playerState-stream";

class PlayerViewModel extends MultipleStreamViewModel {
  PositionData? get positionData => dataMap?[_positionDataSreamKey];
  bool get hasPositionData => dataReady(_positionDataSreamKey);

  PlayerState get playerState => dataMap![_playerStateStreamKey];
  bool get hasPlayerState => dataReady(_playerStateStreamKey);

  final AudioPlayer player = AudioPlayer();
  String url =
      "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3";

  PlayerViewModel(
      {this.url =
          "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3"});

  @override
  // TODO: implement stream
  Stream<PositionData> get stream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  Future<void> init() async {
    print("Audio source: $url");
    // Informs the OS of the creation of this Audio session
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      await player.setAudioSource(AudioSource.uri(Uri.parse(url)));
      print("Audio source first");
      print(player.audioSource!.sequence.first.toString());
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Stream<PositionData> _positionDataStreamCreation() {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
            position, bufferedPosition, duration ?? Duration.zero));
  }

  @override
  // TODO: implement streamsMap
  Map<String, StreamData> get streamsMap => {
        _positionDataSreamKey:
            StreamData<PositionData>(_positionDataStreamCreation()),
        _playerStateStreamKey:
            StreamData<PlayerState>(player.playerStateStream),
      };
}

class PositionData {
  Duration duration;
  Duration position;
  Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition, this.duration);

  get sliderValue => (position != null &&
          duration != null &&
          position.inMilliseconds > 0 &&
          position.inMilliseconds < duration.inMilliseconds)
      ? position.inMilliseconds / duration.inMilliseconds
      : 0.0;
}
