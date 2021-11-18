import 'dart:typed_data';

class ByteUtils {
  static List<int> numberAsByteList(int input, numBytes, {bigEndian = true}) {
    var output = <int>[], curByte = input;
    for (var i = 0; i < numBytes; ++i) {
      output.insert(bigEndian ? 0 : output.length, curByte & 255);
      curByte >>= 8;
    }
    return output;
  }

  static int findByteSequenceInList(List<int> sequence, List<int> list) {
    for (var outer = 0; outer < list.length; ++outer) {
      var inner = 0;
      for (;
          inner < sequence.length &&
              inner + outer < list.length &&
              sequence[inner] == list[outer + inner];
          ++inner) {}
      if (inner == sequence.length) {
        return outer;
      }
    }
    return -1;
  }

  static int intIterableToInt(Iterable<int> ints, {bigEndian = true}) {
    return byteListToInt(Uint8List.fromList(ints.toList()),
        bigEndian: bigEndian);
  }

  static int byteListToInt(Uint8List bytes, {bigEndian = true}) {
    int encodedNumber = 0;
    if (bigEndian) {
      for (int i = 0; i < bytes.length; i++) {
        encodedNumber += (bytes[i] << 8 * (bytes.length - 1 - i));
      }
    } else {
      for (int i = bytes.length - 1; i >= 0; i--) {
        int powBytes = bytes[i] << (8 * i);
        encodedNumber += powBytes;
        // print(
        //     "Bytes: ${bytes[i]}. PowBytes: $powBytes. Encoded number: $encodedNumber, index: $i");
      }
    }
    return encodedNumber;
  }
}
