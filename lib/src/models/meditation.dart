import 'dart:io';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serenity/src/models/emotions_measure.dart';
import 'package:serenity/src/models/meditation_config.dart';
import 'package:serenity/src/utils/string_manipulation.dart';
import 'package:serenity/src/utils/wave_builder.dart';
//TODO better model this thing

class SimpleMeditation {
  String? name;
  Duration duration;
  String path;

  SimpleMeditation(
      {this.name = "Generated Meditation",
      this.duration = Duration.zero,
      this.path = "default-path"});

  String formattedDuration() {
    return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
  }
}

class Meditation extends SimpleMeditation {
  String id = '';
  String meditationText = '';
  MeditationConfig config = MeditationConfig();
  List<Step> steps = [];

  Meditation.blank() : super();

  Meditation({
    this.id = '',
    this.steps = const [],
    required this.meditationText,
    required this.config,
    Duration duration = Duration.zero,
  }) : super(duration: duration);

  EmotionsMeasure getEmotionMeasure() {
    return EmotionsMeasure(
        emotion: config.emotion,
        stress: config.stress,
        anxiety: config.anxiety);
  }

  factory Meditation.fromRawJson(
      Map<String, dynamic> json, MeditationConfig config) {
    String meditationText = "";
    String rawContent = "";
    List<Step> steps = [];

    // print("CLEAN DATA");
    json.forEach((stepName, value) {
      if (value is List && value.isNotEmpty) {
        String id =
            value[0]["_id"] is String ? (value[0]["_id"] as String) : "";
        String content = value[0]["content"] is String
            ? (value[0]["content"] as String)
            : "";
        rawContent += content;
        String cleanContent = sanitizeTtsText(content);
        steps.add(Step(id, cleanContent, content));
        meditationText += ". " + cleanContent;
      }
    });

    print(steps);
    // print(meditationText);

    return Meditation(
      meditationText: meditationText,
      config: config,
      steps: steps,
      duration: Duration(minutes: config.time.round()),

      // [Step("generic_id", meditationText, rawContent)]
    );
  }
}

class Step {
  String id;
  String cleanText;
  String rawText;
  List<String> initialChunks = [];
  List<ChunkSource> chunks = <ChunkSource>[];

  Step(this.id, this.cleanText, this.rawText) {
    initialChunks = splitTtsText(cleanText);
    processChunks();
  }

  void processChunks() {
    int silenceChunksCount = 0;
    chunks = initialChunks.map((chunk) {
      RegExp ssmlPattern = RegExp(r'<break[^/>]*/>', dotAll: true);
      if (ssmlPattern.hasMatch(chunk)) {
        silenceChunksCount++;
        Duration silenceDuration = getDurationFromBreakSSML(chunk);
        return StepSilence(
            silenceDuration: silenceDuration,
            id: id + silenceChunksCount.toString());
      } else {
        return StepChunk(chunkText: chunk);
      }
    }).toList();
  }

  @override
  String toString() {
    return """{
      'Step_id':$id,
      'chunks':${chunks.toString()}
    }""";
  }
}

abstract class ChunkSource {
  AudioSource chunkSource(String ttsPath);
}

class StepChunk implements ChunkSource {
  String chunkText;
  StepChunk({required this.chunkText});

  @override
  AudioSource chunkSource(String ttsPath) {
    return AudioSource.uri(Uri.parse(ttsPath + chunkText));
  }

  @override
  String toString() {
    return chunkText;
  }
}

class StepSilence implements ChunkSource {
  Duration silenceDuration;
  late String durationPath;
  String id;
  late String filePath;
  StepSilence({required this.silenceDuration, required this.id}) {
    // print(this.id);
    init();
  }

  Future<void> init() async {
    // print("Creating file");
    Directory tempDir = await getTemporaryDirectory();
    filePath = tempDir.path + id + ".wav";
    print(filePath);
    // filePath = "./bin/out/$id.wav";
    File fileOut = File(filePath);
    final WaveBuilder builder = WaveBuilder();

    builder.appendSilence(silenceDuration.inMilliseconds,
        WaveBuilderSilenceType.BeginningOfLastSample);
    fileOut.writeAsBytes(builder.fileBytes);
  }

  @override
  String toString() {
    return "Step silence duration: " + silenceDuration.toString();
  }

  @override
  AudioSource chunkSource(String ttsPath) {
    return AudioSource.uri(Uri.parse(filePath));
  }
}
