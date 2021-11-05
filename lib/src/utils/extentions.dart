extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
