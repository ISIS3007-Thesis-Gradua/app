import 'package:serenity/src/utils/bytes_manipulation.dart';

///This class gets some basic info (Including the header params) for a .wav file.
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
}
