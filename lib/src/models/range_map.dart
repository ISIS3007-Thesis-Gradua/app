///This is used to map a range of durations into a Chunk when sliding through the seek bar
///Models a [start, end) duration range.
class DurationRange extends Comparable<DurationRange> {
  ///start of range. Inclusive.
  Duration start;

  ///End of range. Exclusive.
  Duration end;

  DurationRange(this.start, this.end) {
    assert(start <= end, "Error. You tried to create a range with end < start");
  }

  DurationRange.fromDuration(Duration duration)
      : start = duration,
        end = duration;

  DurationRange.zero()
      : start = Duration.zero,
        end = Duration.zero;

  @override
  int compareTo(DurationRange other) {
    // //Comparador con números. Se asume que si le pasan números es en milisegundos.
    // if (other is num) {
    //   if (start.inMilliseconds <= (other as num) &&
    //       (other as num) < end.inMilliseconds) {
    //     return 0;
    //   } else if ((other as num) < start.inMilliseconds) {
    //     return 1;
    //   } else {
    //     return -1;
    //   }
    // }
    // //Comparador con objetos Duration
    // else if (other is Duration) {
    //   if (start <= other && other < end) {
    //     return 0;
    //   } else if (other < start) {
    //     return 1;
    //   } else {
    //     return -1;
    //   }
    // }
    //Comparador con un rango. Se asume que si se está contenido en un rango es "igual"
    // esto para que mapeen al mismo value. Y el comportamiento intuitivo de mayor y menor
    // ej: [0,1) < [1, 2). [0, 1) = [0.2, 0.3), [0, 1) = [0 1).
    // Note que no hay definición posible cuando se intersectan rango [0,1) ?? [0.5, 2)
    //De comparar algo de este estilo lanzara una excepción.
    if (other is DurationRange) {
      if (other.start <= this.start && this.end <= other.end)
        return 0; //this C other
      else if (this.start <= other.start && other.end <= this.end)
        return 0; // other C this
      else if (other.end <= this.start)
        return 1; // other < this
      else if (this.end <= other.start)
        return -1; // this < other
      else {
        print("This: ${this.toStringR()}. Other: ${other.toStringR()}");
        throw UnimplementedError();
      } // Se intersectan los rangos
    } else {
      // No se debería comparar esta clase con otro tipo de objetos que no sean número, rango o duración.
      print("This: $this. Other: $other");
      throw UnimplementedError();
    }
  }

  // @override
  String toStringR() {
    return "Range: [$start, $end). Size: ${end - start}";
  }
}

class DurationRangeInt {
  DurationRange range;
  int index;

  DurationRangeInt(this.range, this.index);

  factory DurationRangeInt.empty() {
    return DurationRangeInt(DurationRange.zero(), 0);
  }

  @override
  String toString() {
    return "Index: $index . ${range.toStringR()}";
  }
}
