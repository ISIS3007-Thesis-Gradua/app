import 'dart:io';

import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_ffmpeg/media_information.dart';
import 'package:path/path.dart' as p;
import 'package:serenity/src/utils/bytes_manipulation.dart';

///This class gets some basic info (Including the header params) for a .wav file.
///For more info see WAVE format specification:
///http://soundfile.sapp.org/doc/WaveFormat/
///http://www.topherlee.com/software/pcm-tut-wavformat.html
///https://stackoverflow.com/questions/28137559/can-someone-explain-wavwave-file-headers
class WavFileInfo {
  late int fileSizeBytes;
  late String subChunkId;
  late int subChunkSize;
  late int audioFormat;
  late int numChannels;
  late int sampleRate;
  late int byteRate;
  late int numBytesInData;
  late Duration duration;

  WavFileInfo(
      this.fileSizeBytes,
      this.subChunkId,
      this.subChunkSize,
      this.audioFormat,
      this.numChannels,
      this.sampleRate,
      this.byteRate,
      this.numBytesInData,
      this.duration);

  WavFileInfo.fileInfoFromBytes(List<int> bytes) {
    String riff = String.fromCharCodes(bytes.getRange(0, 4));
    String wave = String.fromCharCodes(bytes.getRange(8, 12));

    //Checks for compliance with the .wav specification.
    assert(riff == "RIFF", "The provided bytes do not encode a RIFF file.");
    assert(wave == "WAVE", "The provided bytes do not encode a Wav file.");

    fileSizeBytes =
        ByteUtils.intIterableToInt(bytes.getRange(4, 8), bigEndian: false);
    subChunkId = String.fromCharCodes(bytes.getRange(12, 16));
    subChunkSize =
        ByteUtils.intIterableToInt(bytes.getRange(16, 20), bigEndian: false);
    audioFormat =
        ByteUtils.intIterableToInt(bytes.getRange(20, 22), bigEndian: false);
    numChannels =
        ByteUtils.intIterableToInt(bytes.getRange(22, 24), bigEndian: false);
    sampleRate =
        ByteUtils.intIterableToInt(bytes.getRange(24, 28), bigEndian: false);
    byteRate =
        ByteUtils.intIterableToInt(bytes.getRange(28, 32), bigEndian: false);

    numBytesInData =
        ByteUtils.intIterableToInt(bytes.getRange(40, 44), bigEndian: false);

    num milliseconds = (numBytesInData / byteRate) * 1000;

    duration = Duration(milliseconds: milliseconds.round());
  }

  ///Checks if the header of the file says this is a Wav file.
  static bool isWav(List<int> bytes) {
    String wave = String.fromCharCodes(bytes.getRange(8, 12));
    return wave == "WAVE";
  }
}

///Converts the .wav file inside [sourceFile] to an .mp3 file inside
///the specified [outputDirectory], with the given [fileName]. The fileName
///should NOT provide the extension. That will be added here.
///For a mor precise conversion the arguments [bitRateKb] and [numChannels]
///will model the bit rate of the mp3 in KiloBits and the number of channels (1 or 2)
///respectively.
Future<File> convertWavToMp3(
  File sourceFile,
  String outputDirectory,
  String fileName, {
  int bitRateKb = 80,
  int numChannels = 1,
}) async {
  //Verify correctness of the input args.
  assert(1 <= numChannels && numChannels <= 2,
      "The provided number of channels is not 1 or 2");
  assert(WavFileInfo.isWav(await sourceFile.readAsBytes()),
      "The source file is not a .wav file.");
  assert(await Directory(outputDirectory).exists(),
      "The target output directory does not exist.");

  final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
  FlutterFFmpegConfig().disableLogs();
  String outputPath = p.join(outputDirectory, fileName + ".mp3");

  ///See what this command does:
  ///https://stackoverflow.com/questions/3255674/convert-audio-files-to-mp3-using-ffmpeg
  ///the "-y" flag at the start is just to overwrite the destination file if necessary.
  int rc = await flutterFFmpeg.execute(
      "-y -i ${sourceFile.path} -vn -ac $numChannels -b:a ${bitRateKb}k $outputPath");
  if (rc == 0) {
    print("Successfully converted ${sourceFile.path} to mp3");
    return File(outputPath);
  } else {
    throw Exception("[ERROR] converting ${sourceFile.path} to mp3");
  }
}

Future<File> concatenateListOfAudioFiles(
    List<File> audioFiles, String outputDirectory, String fileName,
    {bool enableFFmpegLogs = false}) async {
  assert(await Directory(outputDirectory).exists(),
      "The target output directory does not exist.");

  String ffmpegConcatCommand = "-y ";
  int n = audioFiles.length;
  for (File file in audioFiles) {
    String audioPath = file.path;
    ffmpegConcatCommand += "-i $audioPath ";
  }
  ffmpegConcatCommand += "-filter_complex '";
  for (int i = 0; i < n; i++) {
    ffmpegConcatCommand += "[$i:0]";
  }
  ffmpegConcatCommand +=
      "concat=n=$n:v=0:a=1[out]' -map '[out]' -codec:a libmp3lame -q:a 3 ";

  String outputPath = p.join(outputDirectory, fileName + ".mp3");
  ffmpegConcatCommand += outputPath;

  final FlutterFFmpeg flutterFFmpeg = FlutterFFmpeg();
  if (enableFFmpegLogs) {
    FlutterFFmpegConfig().enableLogs();
  } else {
    FlutterFFmpegConfig().disableLogs();
  }
  print("[CONCAT FILES COMMAND] $ffmpegConcatCommand");
  int rc = await flutterFFmpeg.execute(ffmpegConcatCommand);
  if (rc == 0) {
    print("Successfully converted $n audio files to mp3");
    return File(outputPath);
  } else {
    throw Exception("[ERROR] converting $n audio files to mp3");
  }
}

class AudioFileInfo {
  ///Get the duration of an MP3 file.
  ///Technically it should work for other file formats also but i haven't test it for more.
  static Future<Duration> fileDuration(File file) async {
    FlutterFFprobe FFprobe = FlutterFFprobe();
    MediaInformation mediaInformation =
        await FFprobe.getMediaInformation(file.path);
    String durationInSeconds =
        mediaInformation.getMediaProperties()?["duration"] ?? "0.0";
    print("[Duration in seconds:] $durationInSeconds");
    // print(durationInSeconds);
    return Duration(seconds: num.parse(durationInSeconds).round());
  }
}
