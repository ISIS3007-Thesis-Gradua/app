import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:serenity/src/models/saved_meditation.dart';

const String meditationsFolder = "/meditations";

class LocalStorageService {
  late Box<SavedMeditation> meditationsBox;
  late Directory applicationsDirectory;
  late String applicationMeditationsFolderPath;

  LocalStorageService() {
    init();
  }

  Future<void> init() async {
    //Go to Hive docs for more info on what is going on here:
    //QuickStart: https://docs.hivedb.dev/#/README
    //TypeAdapters: https://docs.hivedb.dev/#/custom-objects/generate_adapter
    Hive.registerAdapter(SavedMeditationAdapter());
    applicationsDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(applicationsDirectory.path);
    meditationsBox = await Hive.openBox<SavedMeditation>('meditationBox');

    applicationMeditationsFolderPath =
        p.join(applicationsDirectory.path, meditationsFolder);

    //Creates a folder inside the applications directory to save all the meditations files.
    final Directory applicationsMeditationsDirectory =
        Directory(applicationMeditationsFolderPath);
    if (!await applicationsMeditationsDirectory.exists()) {
      await applicationsMeditationsDirectory.create();
    }
  }

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

  Future<void> deleteMeditationFile(String path) async {
    File meditationFile = File(path);
    if (await meditationFile.exists()) {
      await meditationFile.delete();
    }
  }

  SavedMeditation getMeditationByIndex(int index) {
    SavedMeditation? meditation = meditationsBox.getAt(index);
    if (meditation == null) {
      throw Exception(
          "Error getting meditation at index: $index. Returned null.");
    } else {
      return meditation;
    }
  }

  SavedMeditation getMeditationByKey(dynamic key) {
    SavedMeditation? meditation = meditationsBox.get(key);
    if (meditation == null) {
      throw Exception(
          "Error getting meditation with key: $key. Returned null.");
    } else {
      return meditation;
    }
  }

  void putMeditation(SavedMeditation meditation) {
    meditationsBox.add(meditation).then((value) {
      print("Meditation saved successfully, index: $value");
    },
        onError: (_) =>
            print("Error saving meditation.\nMessage: ${_.toString()}"));
  }

  void deleteMeditationAtIndex(int index) {
    meditationsBox.deleteAt(index).then((value) {
      print("Meditation at index: $index deleted successfully.");
    },
        onError: (_) => print(
            "Error deleting meditation at index: $index.\nMessage: ${_.toString()}"));
  }

  void deleteMeditationWithKey(dynamic key) {
    if (meditationsBox.containsKey(key)) {
      meditationsBox.delete(key).then((value) {
        print("Meditation with key: $key deleted successfully.");
      },
          onError: (_) => print(
              "Error deleting meditation with key: $key.\nMessage: ${_.toString()}"));
    } else {
      print("Error deleting meditation with key: $key. This key wasn't found.");
    }
  }

  Future<void> clearMeditations() async {
    await meditationsBox.clear();
  }

  void dispose() {
    meditationsBox.close();
  }
}
