import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:stacked/stacked.dart';

const String _positionDataSreamKey = "positionData-stream";
const String _playerStateStreamKey = "playerState-stream";
const String ttsEndPoint = "http://192.168.0.4:5002/api/tts?text=";

enum TtsSource { mozilla, aws, native }

extension EndPoint on TtsSource {
  String get url {
    switch (this) {
      case TtsSource.mozilla:
        return "http://192.168.0.4:5002/api/tts?text=";
      case TtsSource.native:
        return "not-implemented";
      case TtsSource.aws:
        return "not-implemented";
    }
  }
}

class PlayerViewModel extends MultipleStreamViewModel {
  final AudioPlayer player = AudioPlayer();

  // "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3";

  List<Step> steps = [];

  /// Backend seleccionado para el TTS
  TtsSource ttsSource;

  PlayerViewModel({
    this.steps = const [],
    this.ttsSource = TtsSource.mozilla,
  });

  ///Dado un pedazo de texto devuelve el endpoint correspondiente al TTS provider Actual
  String constructSingleSource(String ttsChunk) {
    return ttsSource.url + ttsChunk;
  }

  @override
  Stream<PositionData> get stream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  ///This method will handle general Changes
  void onPlayBackStateChange(PlaybackEvent playbackEvent) {}

  Future<void> init() async {
    //Subscribe to the stream that holds basically all information about the player
    player.playbackEventStream.listen(onPlayBackStateChange);

    // print("Audio source: $url");
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
      await player.setAudioSource(
        ConcatenatingAudioSource(
          useLazyPreparation: true,
          children: steps.map(
            (step) {
              String source = constructSingleSource(step.cleanText);
              return AudioSource.uri(Uri.parse(source));
            },
          ).toList(),
        ),
      );
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

  void dispose() {}
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
