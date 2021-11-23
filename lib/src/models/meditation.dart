import 'dart:io';

import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:serenity/src/models/emotions_measure.dart';
import 'package:serenity/src/models/meditation_config.dart';
import 'package:serenity/src/utils/string_manipulation.dart';
import 'package:serenity/src/utils/wave_builder.dart';

///Is important to put this here BEFORE running the script from below on terminal.
part 'meditation.g.dart';

///This class will model the information for the most simple meditation and
///also for the one saved Locally.
///It is also used to generate the corresponding Hive Type Adapter to store it
///inside a HiveBox. To retrieve it we should use the LocalStorageService Singleton.
///To generate the TypeAdapter run on terminal:
///flutter pub get && flutter  pub run build_runner build --delete-conflicting-outputs
///More info, see: https://docs.hivedb.dev/#/custom-objects/generate_adapter
@HiveType(typeId: 0)
class SimpleMeditation {
  ///Meditation id, by default is a String representation of the timestamp of its creation.
  @HiveField(0)
  String id = '';

  ///Path to local file containing the audio for this meditation.
  @HiveField(1)
  String path;

  ///Meditation Name.
  @HiveField(2)
  String name;

  ///Meditation Duration.
  @HiveField(3)
  late double durationInSeconds;

  Duration duration;

  SimpleMeditation(
      {this.path = "default-path",
      this.name = "Generated Meditation",
      this.duration = Duration.zero}) {
    durationInSeconds = duration.inMilliseconds / 1000;
    id = DateTime.now().millisecondsSinceEpoch.toString();
  }

  void set durationInSec(Duration duration) {
    this.duration = duration;
    durationInSeconds = duration.inMilliseconds / 1000;
  }

  ///Returns a String with the duration formatted as: "mm:ss mins"
  String formattedDuration() {
    return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60))} mins";
  }
}

///This class will model a more complex meditation generated based on the MeditationConfig
///parameters passed at the HomeView. This will alsa contain the generated Steps and the
///corresponding meditation's entire text (Concatenation of each step text with SSML break times)
class Meditation extends SimpleMeditation {
  String meditationText = '';
  MeditationConfig config = MeditationConfig();
  List<Step> steps = [];

  Meditation.blank() : super();

  Meditation({
    this.steps = const [],
    required this.meditationText,
    required this.config,
    Duration duration = Duration.zero,
  }) : super(duration: duration);

  ///Returns the measurement of the user's emotion contained inside the meditation config.
  EmotionsMeasure getEmotionMeasure() {
    return config.emotionsMeasure;
  }

  ///Creates a meditation object from the Raw Json returned by the backend.
  factory Meditation.fromRawJson(
      Map<String, dynamic> json, MeditationConfig config) {
    String meditationText = "";
    List<Step> steps = [];

    // print("CLEAN DATA");
    json.forEach((stepName, value) {
      if (value is List && value.isNotEmpty) {
        //This highly depends on the Backend response format. If something
        //there changes this code will have to be chnaged.
        String id =
            value[0]["_id"] is String ? (value[0]["_id"] as String) : "";
        String content = value[0]["content"] is String
            ? (value[0]["content"] as String)
            : "";

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
    );
  }

  ///Concatenates all the chunks of each step in a single list.
  List<ChunkSource> getChunks() {
    List<ChunkSource> chunks = [];

    for (Step step in steps) {
      chunks.addAll(step.chunks);
    }
    return chunks;
  }
}

///This class will model a single step.
///Each step will also have so called "Chunks" which are basically a partition
///of the text inside each step such that the text is split by the SSML breaks.
///Ex: Step = "¡bienvenido! buen día. <break time=\"900ms\"/> que bien que te regales un momento para meditar"
///Will be separated into:
///["¡bienvenido! buen día. ", "<break time=\"900ms\"/>",  "que bien que te regales un momento para meditar"]
///The purpose of this is to generate the Voice in smaller chunks that the backend can process. Also,
///to programmatically generate "silence audio" corresponding to the break times for those TTS backends
///that does not support SSML breaks.
class Step {
  String id;

  ///This step text without <speak> and <speak/> tags.
  String cleanText;

  ///The original raw text for this Step sent by the backend generator.
  String rawText;

  ///Initial Step split into Strings
  List<String> initialChunks = [];

  ///List of classes that model each chunk.
  List<ChunkSource> chunks = <ChunkSource>[];

  Step(this.id, this.cleanText, this.rawText) {
    initialChunks = splitTtsText(cleanText);
    processChunks();
  }

  ///Based on the split chunks it will generate one of two classes for each chunk.
  ///An StepChunk for a simple chunk that is pure text like: "¡bienvenido! buen día. "
  ///Or a StepSilence for a chunk that is an SSML break like: "<break time=\"900ms\"/>"
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

///Abstract class that every Chunk class will implement, so the compiler knows
///that every chunk class will have a method that returns its corresponding audio
///source.
abstract class ChunkSource {
  AudioSource chunkSource(String ttsPath);

  String sourcePath(String ttsPath);
}

///Class that models a simple text chunk
class StepChunk implements ChunkSource {
  String chunkText;

  StepChunk({required this.chunkText});

  @override
  AudioSource chunkSource(String ttsPath) {
    return AudioSource.uri(Uri.parse(ttsPath + chunkText));
  }

  @override
  String sourcePath(String ttsPath) {
    return ttsPath + chunkText;
  }

  @override
  String toString() {
    return chunkText;
  }
}

///Class that models an SSML break chunk.
class StepSilence implements ChunkSource {
  String id;
  Duration silenceDuration;
  late String durationPath;
  late String filePath;

  StepSilence({required this.silenceDuration, required this.id}) {
    init();
  }

  ///Creates a .wav file with some duration of silence given by the SSML break
  ///that this class models. This file will be saved in the temporary directory and,
  ///for those services that does not support SSML break, this is the file that the
  ///player will use to emulate the periods of silence.
  Future<void> init() async {
    Directory tempDir = await getTemporaryDirectory();
    filePath = tempDir.path + id + ".wav";
    print(filePath);

    File fileOut = File(filePath);
    final WaveBuilder builder = WaveBuilder();

    builder.appendSilence(silenceDuration.inMilliseconds,
        WaveBuilderSilenceType.BeginningOfLastSample);
    fileOut.writeAsBytes(builder.fileBytes);
  }

  @override
  AudioSource chunkSource(String ttsPath) {
    return AudioSource.uri(Uri.parse(filePath));
  }

  @override
  String sourcePath(String ttsPath) {
    return filePath;
  }

  @override
  String toString() {
    return "Step silence duration: " + silenceDuration.toString();
  }
}
