import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/models/range_map.dart';

const String _positionDataSreamKey = "positionData-stream";
const String _playerStateStreamKey = "playerState-stream";
const String ttsEndPoint = "http://3.237.62.115:5002/api/tts?text=";

// 192.168.0.4 local
// http://3.237.62.115:5002/ aws

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

  ///Maps a range of durations to an integer that represents the index of
  ///the track that corresponds to that given duration.
  ///Ex: [0s-10s)->index to Chunk 1,[10s-25s)-> index chunk 2....
  ///This is used so the seekbar knows to which track to seek with a given duration.
  SplayTreeMap<DurationRange, DurationRangeInt> rangesToChunks = SplayTreeMap();

  PlayerViewModel(
      {
      // this.steps = const [],
      this.ttsSource = TtsSource.mozilla,
      required this.meditation});

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

  ///Get the maximum Duration to use for the "max" property in the seekBar.
  Duration get effectiveTotalDuration {
    if (totalDuration < meditation.duration)
      return meditation.duration;
    else
      return totalDuration;
  }

  Duration get effectivePosition {
    return player.position;
  }

  Duration get effectiveBufferedPosition {
    return this.effectivePosition + player.bufferedPosition;
  }

  ///This method will handle general Changes
  void onPlayBackStateChange(PlaybackEvent playbackEvent) {}

  void _onBufferedPositionChange(Duration bufferedPosition) {
    print("BufferedPosition: $bufferedPosition");
    notifyListeners();
  }

  ///When a new chunk Duration is resolved this function maps its duration range
  ///to the corresponding track index in the player.
  ///Also verifies it doesn't already exists this key. This may happen when the
  ///user seeks to a previous track.
  void _onDurationResolved(Future<Duration?>? future,
      Duration totalDurationAtCall, int indexAtCall) {
    print(
        "Before calling Duration Future. Total duration: $totalDurationAtCall. CurrentIndex: $indexAtCall");
    future?.then(
      (resolvedDuration) {
        print("Resolved duration: $resolvedDuration");
        if (resolvedDuration != null && resolvedDuration > Duration.zero) {
          print(
              "After Duration Future Resolved. Total duration: $totalDurationAtCall. CurrentIndex: $indexAtCall. Resolved Duration: $resolvedDuration");
          DurationRange thisChunkRange = DurationRange(
              totalDurationAtCall, totalDurationAtCall + resolvedDuration);
          if (!rangesToChunks.containsKey(thisChunkRange)) {
            DurationRangeInt value =
                DurationRangeInt(thisChunkRange, indexAtCall);
            rangesToChunks[thisChunkRange] = value;
            print(value);
          }
        }
      },
    ).onError((error, stackTrace) {
      print("Erro resolving duration: $error");
      print(stackTrace);
    });
  }

  void _onCurrentPlayerIndexChange(int? index) {
    totalDuration += currentDuration ?? Duration.zero;
    if (player.currentIndex != null) {
      _onDurationResolved(
          player.durationFuture, totalDuration, player.currentIndex!);
    }

    print("Track Duration at index Change: $currentDuration");
    print("Total duration: $totalDuration");
    print("Player duratio: ${player.duration}");
    print("PlayerIndex: $index");

    notifyListeners();
  }

  void _onCurrentPositionChange(Duration playerPosition) {
    // print("Position: $playerPosition");
    notifyListeners();
  }

  void _onCurrentDurationChange(Duration? currentTrackDuration) {
    currentDuration = currentTrackDuration;
    print(
        "## Current Index: ${player.currentIndex}. CurrentDuration: $currentTrackDuration");
    notifyListeners();
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

    player.playerStateStream.listen((event) {
      notifyListeners();
    });

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
        // await player.setAudioSource(AudioSource.uri(Uri.parse(
        //     "http://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")));
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
      // Future.delayed(Duration(seconds: 60), () => player.pause())
      //     .then((value) => print("Final map: $rangesToChunks"));

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

  ///Given a duration since less than or equal to the current total playtime
  ///of the playlist, it seeks to the start of the track that corresponds
  ///to that moment in time in the playlist order.
  ///Ej: Playlist: [0, 10s) step1, [10, 30) step2, then calling with Duration(15secs)
  ///would seek to the start of step2.
  Future<void> seekToWithDuration(Duration duration) async {
    if (meditation is Meditation) {
      print("Seeking Duration: $duration");
      print(rangesToChunks[DurationRange.fromDuration(duration)]);
      DurationRangeInt value =
          rangesToChunks[DurationRange.fromDuration(duration)] ??
              DurationRangeInt.empty();
      totalDuration = value.range.start;
      currentDuration = duration;
      notifyListeners();
      await player.seek(duration - value.range.start, index: value.index);
    } else {
      print(duration);
      await player.seek(duration);
    }
    // totalDuration = value.range.start;
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
  Future<void> dispose() async {
    print("Disposing player view model");
    if (player.audioSource is ConcatenatingAudioSource) {
      await (player.audioSource as ConcatenatingAudioSource).clear();
    }
    // player.set
    await player.stop();
    await player.dispose();
    // AudioPlayer.clearAssetCache();
    super.dispose();
  }
}

// class PositionData {
//   Duration duration;
//   Duration position;
//   Duration bufferedPosition;
//
//   PositionData(this.position, this.bufferedPosition, this.duration);
//
//   get sliderValue => (position != null &&
//           duration != null &&
//           position.inMilliseconds > 0 &&
//           position.inMilliseconds < duration.inMilliseconds)
//       ? position.inMilliseconds / duration.inMilliseconds
//       : 0.0;
// }
