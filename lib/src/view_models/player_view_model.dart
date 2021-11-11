import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:serenity/src/models/meditation.dart';

const String _positionDataSreamKey = "positionData-stream";
const String _playerStateStreamKey = "playerState-stream";
const String ttsEndPoint = "http://192.168.0.4:5002/api/tts?text=";

// 192.168.0.4

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

class PlayerViewModel extends ChangeNotifier {
  final AudioPlayer player = AudioPlayer();

  // "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3";

  // List<Step> steps = [];

  SimpleMeditation meditation;

  /// Backend seleccionado para el TTS
  TtsSource ttsSource;

  PlayerViewModel({
    // this.steps = const [],
    this.ttsSource = TtsSource.mozilla,
    required this.meditation,
  });

  ///Dado un pedazo de texto devuelve el endpoint correspondiente al TTS provider Actual
  String constructSingleSource(String ttsChunk) {
    return ttsSource.url + ttsChunk;
  }

  // @override
  // Stream<PositionData> get stream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //         player.positionStream,
  //         player.bufferedPositionStream,
  //         player.durationStream,
  //         (position, bufferedPosition, duration) => PositionData(
  //             position, bufferedPosition, duration ?? Duration.zero));

  Duration? currentDuration;

  Duration totalDuration = Duration.zero;

  ///This method will handle general Changes
  void onPlayBackStateChange(PlaybackEvent playbackEvent) {}

  void _onBufferedPositionChange(Duration bufferedPosition) {
    print("BufferedPosition: $bufferedPosition");
  }

  void _onCurrentPlayerIndexChange(int? index) {
    totalDuration += currentDuration ?? Duration.zero;
    print("Track Duration at index Change: $currentDuration");
    print("Total duration: $totalDuration");
    print("Player duratio: ${player.duration}");
    print("PlayerIndex: $index");
  }

  void _onCurrentPositionChange(Duration playerPosition) {
    // print("Position: $playerPosition");
  }

  void _onCurrentDurationChange(Duration? currentTrackDuration) {
    currentDuration = currentTrackDuration;
    print("Duration: $currentTrackDuration");
  }

  Future<void> init() async {
    //Subscribe to the stream that holds basically all information about the player
    player.playbackEventStream.listen(onPlayBackStateChange);

    //Subscribe to the stream that holds information about how much buffer has been load
    player.bufferedPositionStream.listen(_onBufferedPositionChange);

    //Subscribe to the stream that holds information about the index of the current "track" in the playlist
    player.currentIndexStream.listen(_onCurrentPlayerIndexChange);

    player.positionStream.listen(_onCurrentPositionChange);

    player.durationStream.listen(_onCurrentDurationChange);

    //Register audio sources
    configureAudioSources();

    // Informs the OS of the creation of this Audio session
    // final session = await AudioSession.instance;
    // await session.configure(const AudioSessionConfiguration.speech());

    // Listen to errors during playback.
    player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
  }

  Future<void> configureAudioSources() async {
    // Try to load audio from a source and catch any errors.
    try {
      if (meditation is Meditation) {
        List<AudioSource> audioSources = [];
        for (Step step in (meditation as Meditation).steps) {
          Iterable<AudioSource> stepAudioSources = step.chunks.map<AudioSource>(
            (chunk) => chunk.chunkSource(ttsSource.url),
          );
          audioSources.addAll(stepAudioSources);
        }

        await player.setAudioSource(
          ConcatenatingAudioSource(
            useLazyPreparation: true,
            children: audioSources,
          ),
        );
      } else {
        await player
            .setAudioSource(AudioSource.uri(Uri.parse(meditation.path)));
      }
      //Test 60 seconds of playback
      player.play();
      Future.delayed(Duration(seconds: 60), () => player.pause());

      print("First audio source");
      print(player.audioSource!.sequence.first.toString());
    } on PlayerException catch (e) {
      print("Source error at loading audio source: $e");
      print("Code: ${e.code}");
      print("Message: ${e.message}");
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  // Stream<PositionData> _positionDataStreamCreation() {
  //   return Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
  //       player.positionStream,
  //       player.bufferedPositionStream,
  //       player.durationStream,
  //       (position, bufferedPosition, duration) => PositionData(
  //           position, bufferedPosition, duration ?? Duration.zero));
  // }
  //
  //
  // Map<String, StreamData> get streamsMap => {
  //       _positionDataSreamKey:
  //           StreamData<PositionData>(_positionDataStreamCreation()),
  //       _playerStateStreamKey:
  //           StreamData<PlayerState>(player.playerStateStream),
  //     };

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
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
