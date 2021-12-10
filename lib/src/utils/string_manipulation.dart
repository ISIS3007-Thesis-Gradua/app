///Extension on String Objects for common capitalization requirements
extension StringCasingExtension on String {
  ///Capitalizes all the first letter of the whole string.
  ///
  /// Ex: 'hello world' => 'Hello world'.
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';

  ///Capitalizes all the first letters of each word.
  ///
  /// Ex: 'hello world' => 'Hello World'.
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.toCapitalized())
      .join(" ");
}

///Removes some SSML text from the input. Doesn't touch
///the SSML corresponding to break times. Just the <speak> and <speak/> tags.
String sanitizeTtsText(String text) {
  //Docs for this regex: https://regex101.com/r/IzkgzM/1
  String cleanText = text.replaceAll(RegExp(r'<\\?\/?speak\/?>'), '');
  // cleanText = text.replaceAll(RegExp(r'<\/?speak\/?>'), '');
  return cleanText;
}

List<String> splitTtsText(String text) {
  //Docs for this Regex: https://regex101.com/r/6CreYZ/1
  //Esta es una opción más "bervosa" y exacta
  // RegExp splitBy = RegExp(r'<break\s+time="\d+ms"/>', dotAll: true);

  //Esta es más genérica. Usar cualquiera a discreción.
  // Docs for this Regex: https://regex101.com/r/bzmddu/1
  RegExp splitBy = RegExp(r'<break[^/>]*/>', dotAll: true);
  List<String> splittedList = separateStringByPattern(text, splitBy);
  return splittedList;
}

Duration getDurationFromBreakSSML(String text) {
  //This is just for getting the numbers in te String. Shouldn't be more than 1 chain of numbers
  RegExp numbers = RegExp(r'\d+');
  //This regex supports spaces between the number and the seconds key "s".
  RegExp seconds = RegExp(r'\d+\s*s');

  RegExp miliseconds = RegExp(r'\d+\s*ms');
  int intNumbers = int.parse(numbers.firstMatch(text)?.group(0) ?? "100");

  if (miliseconds.hasMatch(text)) {
    return Duration(milliseconds: intNumbers);
  } else if (seconds.hasMatch(text)) {
    return Duration(seconds: intNumbers);
  } else {
    return Duration(milliseconds: intNumbers);
  }
}

///This method takes a String as input and splits it into a list of Strings
///where each Substring contains 0 or 1 occurrences of the pattern (RegExp pattern).
///Ex: text = "Hello, how are you? I just said hello..." and pattern=RegExp("Hello", caseSensitive=false),
///returns ["Hello", ", how are you? I just said ", "hello", "..."]
/// This is mainly used in the helper dialog method to separate the words with different styles from de json file annotations.
List<String> separateStringByPattern(String text, Pattern pattern) {
  //Markes befora and after of the pattern with "<>"
  text = text.splitMapJoin(pattern,
      onMatch: (m) => '<>${m.group(0)}<>', onNonMatch: (m) => m);
  //Removes starting and ending marks <> in case they exist.
  if (text.startsWith("<>")) {
    text = text.replaceFirst("<>", "");
  }
  if (text.endsWith("<>")) {
    text = text.replaceRange(text.length - 2, text.length, "");
  }
  return text.split("<>");
}

///Extracts the actual value of an enum's toString() method.
///
///When you do toString() on an enum value it returns 'enumName.value'
///instead of just 'value'. This method extracts this value.
String enumValue(Object enumObject, {bool capitalize = true}) {
  String enumValue = enumObject.toString().split('.').last;
  return capitalize ? enumValue.toCapitalized() : enumValue;
}
