String sanitizeText(String text) {
  String cleanText = text
      .replaceAll(RegExp('<speak>'), '')
      .replaceAll(RegExp('<\/speak>'), '')
      .replaceAll(RegExp('<break.*/>', dotAll: true), '');

  // print("Data san");
  // print(cleanText);
  return cleanText;
}

///This method takes a String as input and splits it into a list of Strings
///where each Substring contains 0 or 1 ocurrences of the pattern (RegExp pattern).
///Ex: text = "Hello, how are you? I just said hello..." and pattern=RegExp("Hello", caseSensitive=false),
///returns ["Hello", ", how are you? I just said ", "hello", "..."]
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
