import 'dart:io';
import 'dart:io' as io;

import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:serenity/src/models/meditation.dart';
import 'package:serenity/src/utils/sound_manipulation.dart';
import 'package:serenity/src/utils/wave_builder.dart';
import 'package:serenity/src/view_models/player_view_model.dart';

import 'notifications_service.dart';

const String meditationsFolder = "meditations";

///This class is the Singleton that will manage all operations related with
///Local Storage, such as Writing Files to the Applications Folder
///or save values inside Hive Boxes.
class LocalStorageService {
  late Box<SimpleMeditation> meditationsBox;
  late Directory applicationsDirectory;
  late Directory cacheDirectory;
  late String applicationMeditationsFolderPath;
  late String appMeditationsCacheFolderPath;

  LocalStorageService() {
    init();
  }

  ///Registers Hive adapters, open boxes, and creates the directories inside
  ///the local application and cache paths that will contain the meditation
  ///audio files.
  Future<void> init() async {
    //Go to Hive docs for more info on what is going on here:
    //QuickStart: https://docs.hivedb.dev/#/README
    //TypeAdapters: https://docs.hivedb.dev/#/custom-objects/generate_adapter
    Hive.registerAdapter(SimpleMeditationAdapter());
    applicationsDirectory = await getApplicationDocumentsDirectory();
    cacheDirectory = await getTemporaryDirectory();
    await Hive.initFlutter(applicationsDirectory.path);
    meditationsBox = await Hive.openBox<SimpleMeditation>('meditationBox');

    print("start");

    ///Stores the paths to the folder where meditation audio files and cached files
    ///will be stored.
    applicationMeditationsFolderPath =
        p.join(applicationsDirectory.path, meditationsFolder);
    appMeditationsCacheFolderPath =
        p.join(cacheDirectory.path, meditationsFolder);

    //Creates a folder inside the applications directory to save all the meditations files.
    final Directory applicationsMeditationsDirectory =
        Directory(applicationMeditationsFolderPath);
    if (!await applicationsMeditationsDirectory.exists()) {
      await applicationsMeditationsDirectory.create();
    }
    if (!await Directory(appMeditationsCacheFolderPath).exists()) {
      await Directory(appMeditationsCacheFolderPath).create();
    }

    print("end");
  }

  ///Does all corresponding steps to save the given meditation locally.
  Future<void> saveMeditation(
      Meditation meditation, TtsSource ttsSource) async {
    NotificationService notifications = GetIt.instance<NotificationService>();

    print("[INFO] Started de Downloading and saving meditation process.");
    // final WaveBuilder builder = WaveBuilder();
    int counter = 0;
    int totalChunks = meditation.getChunks().length;
    List<int> chunkFileBytes = [];
    List<File> chunkFiles = [];
    DownloadController<Meditation> download =
        notifications.addDownload(downloadingObject: meditation);
    download.downloadState = DownloadState.downloading;

    //Goes to every chunk of this meditation and generates the corresponding
    //audio file. If is a silence chunk generates a .wav for the specified period
    //of silence. If is a text chunk saves the generated TTS audio.
    for (ChunkSource chunk in meditation.getChunks()) {
      counter++;
      download.progress = counter / totalChunks;
      print("[DOWNLOADED CHUNKS COUNTER] $counter");

      if (chunk is StepChunk) {
        chunkFileBytes = await processStepChunk(chunk, ttsSource, download);
      } else if (chunk is StepSilence) {
        chunkFileBytes = processSilenceChunk(chunk);
      }
      //TODO handle error saving meditation file to cache
      chunkFiles.add(await saveMeditationFileToCache(
          meditation.id + "_audio_file_$counter", chunkFileBytes));
    }

    //Change meditation name
    meditation.name = "Meditación #${getAllSavedMeditations().length + 1}";

    //Concatenates all the audio files for each chunk as a single mp3 file.
    File savedMeditationFile =
        await concatenateAndSaveChunks(chunkFiles, download, meditation);

    //Save the meditation file path to the meditation's Hive Box as a
    //SimpleMeditation instance.
    await storeMeditationAudioPath(savedMeditationFile, meditation, download);

    print("[INFO] Clearing local cache");
    //Clear cache files
    clearMeditationsCacheFolder();
  }

  ///Given a [StepChunk] it goes to the also given [ttsSource] and saves the
  ///tts audio response as a .wav file inside the cache folder.
  Future<List<int>> processStepChunk(StepChunk chunk, TtsSource ttsSource,
      DownloadController controller) async {
    print("[TTS-PATH] ${chunk.sourcePath(ttsSource.url)}");
    http.Response meditationAudioResponse = await http
        .get(Uri.parse(chunk.sourcePath(ttsSource.url)))
        .onError((e, _) {
      saveMeditationFailed(controller);
      throw Exception(
          "Error getting audio bytes from ttsSource. ${chunk.sourcePath(ttsSource.url)}");
    });
    return meditationAudioResponse.bodyBytes;
  }

  ///Informs to the Download Controller that the current download process has failed.
  void saveMeditationFailed(DownloadController controller) {
    controller.downloadResult = DownloadResult.error;
    controller.downloadState = DownloadState.finished;
  }

  ///Given a [StepSilence] it saves a .wav file on the cache folder with the period
  ///of silence corresponding to the [StepSilence.silenceDuration]
  List<int> processSilenceChunk(StepSilence chunk) {
    var silenceBuilder = WaveBuilder()
      ..appendSilence(chunk.silenceDuration.inMilliseconds,
          WaveBuilderSilenceType.BeginningOfLastSample);
    return silenceBuilder.fileBytes;
  }

  ///Concatenates all the audio files for each chunk as a single mp3 file and
  ///return this concatenated mp3 file.
  Future<File> concatenateAndSaveChunks(List<File> chunkFiles,
      DownloadController download, Meditation meditation) async {
    print("[INFO] Start concatenating audio files");
    download.downloadState = DownloadState.processing;
    File savedMeditationFile = await concatenateListOfAudioFiles(
            chunkFiles, applicationMeditationsFolderPath, meditation.id,
            enableFFmpegLogs: true)
        .onError((e, _) {
      saveMeditationFailed(download);
      throw Exception("Error concatenating and converting to mp3.");
    });
    download.downloadState = DownloadState.saving;
    return savedMeditationFile;
  }

  Future<void> storeMeditationAudioPath(File savedMeditationFile,
      Meditation meditation, DownloadController download) async {
    print("[INFO] Saving path to final meditation audio file to HiveBox.");
    //Save the meditation file path to the meditation's Hive Box as a
    //SimpleMeditation instance.
    meditation.path = savedMeditationFile.path;
    meditation.durationInSec =
        await AudioFileInfo.fileDuration(savedMeditationFile);
    print("[INFO] Got Duration: ${meditation.durationInSeconds}");
    download.downloadState = DownloadState.saving;
    putMeditationWithKey(meditation.id, meditation.asSimpleMeditation());
    download.downloadState = DownloadState.finished;
    download.downloadResult = DownloadResult.success;
  }

  ///Deletes all the files inside the meditation Cache folder.
  Future<void> clearMeditationsCacheFolder() async {
    await for (FileSystemEntity entity
        in Directory(appMeditationsCacheFolderPath).list()) {
      await entity.delete();
    }
  }

  ///Given a meditation audio File as a sequence of Bytes it will write this bytes
  ///to the meditations subfolder inside the Applications Cache folder.
  Future<File> saveMeditationFileToCache(
      String fileName, List<int> fileContents,
      {String fileExtension = ".wav"}) async {
    bool exists = await Directory(appMeditationsCacheFolderPath).exists();
    String filePath =
        p.join(appMeditationsCacheFolderPath, fileName + fileExtension);
    File savedMeditationFile = File(filePath);
    return savedMeditationFile.writeAsBytes(fileContents,
        mode: io.FileMode.write);
  }

  ///Given a meditation audio File as a sequence of Bytes it will write this bytes
  ///to the meditations subfolder inside the Applications Documents folder.
  Future<File> saveMeditationBytesToFile(
      String fileName, List<int> fileContents,
      {String fileExtension = ".wav"}) {
    String filePath =
        p.join(applicationMeditationsFolderPath, fileName + fileExtension);

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
        p.join(applicationMeditationsFolderPath, fileName + fileExtension);

    // Read the source file
    final contents = await source.readAsBytes();

    // Write source File content to the set location inside the app's document folder
    File savedMeditationFile = File(filePath);
    return savedMeditationFile.writeAsBytes(contents);
  }

  ///Retrieves all the meditations saved locally.
  List<SimpleMeditation> getAllSavedMeditations() {
    return meditationsBox.values.toList();
  }

  ///Creates a Stream that will produce new values whenever there is a change
  ///to the meditationsBox
  Stream<List<SimpleMeditation>> watchAllSavedMeditations() async* {
    yield meditationsBox.values.toList();
    await for (BoxEvent e in meditationsBox.watch()) {
      yield meditationsBox.values.toList();
    }
  }

  ///Given a path, it will look for that path inside local File System to see
  ///if a File exists in that location. If it does it will delete it.
  Future<void> deleteMeditationFile(String path) async {
    File meditationFile = File(path);
    if (await meditationFile.exists()) {
      await meditationFile.delete().onError((error, stackTrace) {
        throw Exception(
            "Error deleting meditation at: $path.\nError: $error.\nTrace:$stackTrace");
      });
      print("Successfully deleted meditation file at: $path");
    } else {
      print("There is no meditation file at: $path");
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
  Future<void> putMeditationWithKey(
      String key, SimpleMeditation meditation) async {
    await meditationsBox.put(key, meditation).then((_) {
      print("Meditation saved successfully, key: $key");
    },
        onError: (e) => Exception(
            "Error saving meditation with key: $key.\nMessage: ${e.toString()}"));
  }

  ///Puts the meditation inside the meditation's Hive Box at the last available index.
  ///Throws an Exception if an error occurs in the process.
  Future<void> putMeditation(SimpleMeditation meditation) async {
    print("Putting meditation");
    await meditationsBox.add(meditation).then((value) {
      print("Meditation saved successfully, index: $value");
    }, onError: (e) {
      print("Error saving meditation.\nMessage: ${e.toString()}");
      return 0;
    });
  }

  ///Deletes the meditation at the given index inside the Hive Box.
  ///Throws Exception if an error occurs in the process.
  Future<void> deleteMeditationAtIndex(int index,
      {bool deleteFile = true}) async {
    SimpleMeditation? meditation = meditationsBox.getAt(index);
    await meditationsBox.deleteAt(index).then((value) {
      print("Meditation at index: $index deleted successfully.");
    },
        onError: (e) => Exception(
            "Error deleting meditation at index: $index.\nMessage: ${e.toString()}"));
    if (deleteFile && meditation != null) {
      await deleteMeditationFile(meditation.path);
    }
  }

  ///Deletes the meditations with the given key inside the Hive Box.
  ///If it doesn't exists a meditation with this key it will throw an Exception.
  ///If an error occurs in the process it will Throw an Exception.
  Future<void> deleteMeditationWithKey(dynamic key,
      {bool deleteFile = true}) async {
    if (meditationsBox.containsKey(key)) {
      SimpleMeditation meditation = meditationsBox.get(key)!;
      await meditationsBox.delete(key).then((value) {
        print("Meditation with key: $key deleted successfully.");
      },
          onError: (e) => Exception(
              "Error deleting meditation with key: $key.\nMessage: ${e.toString()}"));
      if (deleteFile) {
        await deleteMeditationFile(meditation.path);
      }
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
