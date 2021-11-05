String sanitizeText(String text) {
  String cleanText = text
      .replaceAll(RegExp('<speak>'), '')
      .replaceAll(RegExp('<\/speak>'), '')
      .replaceAll(RegExp('<break.*/>', dotAll: true), '');

  // print("Data san");
  // print(cleanText);
  return cleanText;
}
