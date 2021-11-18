import 'dart:io';
import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/utils/sound_manipulation.dart';
import 'package:serenity/src/utils/wave_builder.dart';
import 'package:serenity/src/view_models/player_view_model.dart';

const String meditationsFolder = "/meditations";

///This class is the Singleton that will manage all operations related with
///Local Storage, such as Writing Files to the Applications Folder
///or save values inside Hive Boxes.
class LocalStorageService {
  late Box<SimpleMeditation> meditationsBox;
  late Directory applicationsDirectory;
  late String applicationMeditationsFolderPath;

  LocalStorageService() {
    init();
  }

  Future<void> init() async {
    //Go to Hive docs for more info on what is going on here:
    //QuickStart: https://docs.hivedb.dev/#/README
    //TypeAdapters: https://docs.hivedb.dev/#/custom-objects/generate_adapter
    Hive.registerAdapter(SimpleMeditationAdapter());
    applicationsDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(applicationsDirectory.path);
    meditationsBox = await Hive.openBox<SimpleMeditation>('meditationBox');

    applicationMeditationsFolderPath =
        p.join(applicationsDirectory.path, meditationsFolder);

    //Creates a folder inside the applications directory to save all the meditations files.
    final Directory applicationsMeditationsDirectory =
        Directory(applicationMeditationsFolderPath);
    if (!await applicationsMeditationsDirectory.exists()) {
      await applicationsMeditationsDirectory.create();
    }
  }

  ///Does all corresponding steps to save the given meditation locally.
  Future<void> saveMeditation(
      Meditation meditation, TtsSource ttsSource) async {
    final WaveBuilder builder = WaveBuilder();
    for (ChunkSource chunk in meditation.getChunks()) {
      if (chunk is StepChunk) {
        Uint8List meditationAudioBytes =
            await http.readBytes(Uri.parse(chunk.sourcePath(ttsSource.url)));
        builder.appendFileContents(meditationAudioBytes);
      } else if (chunk is StepSilence) {
        builder.appendSilence(chunk.silenceDuration.inMilliseconds,
            WaveBuilderSilenceType.BeginningOfLastSample);
      }
    }
    File savedMeditationFile = await saveMeditationBytesToFile(
        "${meditation.name}-${meditation.id}", builder.fileBytes);

    meditation.path = savedMeditationFile.path;

    WavFileInfo wavInfo = WavFileInfo.fileInfoFromBytes(builder.fileBytes);
    meditation.duration = wavInfo.duration;
    putMeditation(meditation);
  }

  ///Given a meditation audio File as a sequence of Bytes it will write this bytes
  ///to the meditations subfolder inside the Applications folder.
  Future<File> saveMeditationBytesToFile(
      String fileName, List<int> fileContents,
      {String fileExtension = ".wav"}) {
    String filePath =
        p.join(applicationMeditationsFolderPath, fileName, fileExtension);

    // Write source File content to the set location inside the app's document folder
    File savedMeditationFile = File(filePath);
    return savedMeditationFile.writeAsBytes(fileContents);
  }

  ///Given a meditation source File and a file name it will write the contents of
  ///the given source to the meditations subfolder inside the Applications Folder.
  ///If a file with this name already exists it will just override its contents.
  Future<File> saveMeditationToFile(String fileName, File source,
      {String fileExtension = ".wav"}) async {
    String filePath =
        p.join(applicationMeditationsFolderPath, fileName, fileExtension);

    // Read the source file
    final contents = await source.readAsBytes();

    // Write source File content to the set location inside the app's document folder
    File savedMeditationFile = File(filePath);
    return savedMeditationFile.writeAsBytes(contents);
  }

  ///Given a path, it will look for that path inside local File System to see
  ///if a File exists in that location. If it does it will delete it.
  Future<void> deleteMeditationFile(String path) async {
    File meditationFile = File(path);
    if (await meditationFile.exists()) {
      await meditationFile.delete();
    }
  }

  ///Gets the meditation at the given index from the meditation's Hive Box.
  ///If it does not find it, will Throw an Exception.
  SimpleMeditation getMeditationByIndex(int index) {
    SimpleMeditation? meditation = meditationsBox.getAt(index);
    if (meditation == null) {
      throw Exception(
          "Error getting meditation at index: $index. Returned null.");
    } else {
      return meditation;
    }
  }

  ///Gets the meditation with the given key from the meditation's Hive Box.
  ///If it does not find it, will Throw an Exception.
  SimpleMeditation getMeditationByKey(dynamic key) {
    SimpleMeditation? meditation = meditationsBox.get(key);
    if (meditation == null) {
      throw Exception(
          "Error getting meditation with key: $key. Returned null.");
    } else {
      return meditation;
    }
  }

  ///Puts the meditation with the given key inside the meditation's Hive Box.
  ///Throws an Exception if an error occurs in the process.
  void putMeditationWithKey(String key, SimpleMeditation meditation) {
    meditationsBox.put(key, meditation).then((_) {
      print("Meditation saved successfully, key: $key");
    },
        onError: (e) => Exception(
            "Error saving meditation with key: $key.\nMessage: ${e.toString()}"));
  }

  ///Puts the meditation inside the meditation's Hive Box at the last available index.
  ///Throws an Exception if an error occurs in the process.
  void putMeditation(SimpleMeditation meditation) {
    meditationsBox.add(meditation).then((value) {
      print("Meditation saved successfully, index: $value");
    },
        onError: (e) =>
            Exception("Error saving meditation.\nMessage: ${e.toString()}"));
  }

  ///Deletes the meditation at the given index inside the Hive Box.
  ///Throws Exception if an error occurs in the process.
  void deleteMeditationAtIndex(int index) {
    meditationsBox.deleteAt(index).then((value) {
      print("Meditation at index: $index deleted successfully.");
    },
        onError: (e) => Exception(
            "Error deleting meditation at index: $index.\nMessage: ${e.toString()}"));
  }

  ///Deletes the meditations with the given key inside the Hive Box.
  ///If it doesn't exists a meditation with this key it will throw an Exception.
  ///If an error occurs in the process it will Throw an Exception.
  void deleteMeditationWithKey(dynamic key) {
    if (meditationsBox.containsKey(key)) {
      meditationsBox.delete(key).then((value) {
        print("Meditation with key: $key deleted successfully.");
      },
          onError: (e) => Exception(
              "Error deleting meditation with key: $key.\nMessage: ${e.toString()}"));
    } else {
      Exception(
          "Error deleting meditation with key: $key. This key wasn't found.");
    }
  }

  ///Deletes all the entries inside the meditation's Hive Box.
  Future<void> clearMeditations() async {
    await meditationsBox.clear();
  }

  ///Close all the Hive Boxes in use.
  void dispose() {
    meditationsBox.close();
  }
}
