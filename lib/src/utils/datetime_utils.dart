///Formats a [duration] in the form: ## días ## horas ## mins ## s ## ms
///
/// Ex: if [duration] == Duration(hours: 1, minutes: 5, seconds: 10)
/// formatDuration([duration]) returns: '1 hora 5 minutos 10 segundos'
String formatDuration(Duration duration) {
  String plural(int time) {
    return time > 1 ? 's' : '';
  }

  String response = '';
  if (duration >= const Duration(days: 1)) {
    int d = duration.inDays;
    response += '$d día${plural(d)} ';
  }
  if (duration >= const Duration(hours: 1)) {
    int d = duration.inHours;
    response += '${d.remainder(24)} hora${plural(d)} ';
  }
  if (duration >= const Duration(minutes: 1)) {
    int d = duration.inMinutes;
    response += '${d.remainder(60)} min${plural(d)} ';
  }
  if (duration >= const Duration(seconds: 1)) {
    response += '${duration.inSeconds.remainder(60)} s';
  }
  if (duration < const Duration(seconds: 1)) {
    response += '${duration.inMilliseconds} ms';
  }
  return response;
}
