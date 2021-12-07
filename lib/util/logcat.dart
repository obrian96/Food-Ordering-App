import 'dart:developer' as developer;

class Log {
  static void d(String tag, String message) {
    developer.log(
      tag + ': \n\n' + message + '\n\n---',
      name: 'Debug',
    );
  }

  static void e(String tag, String error) {
    developer.log(
      tag + ': ',
      name: 'Error',
      error: '\n' + error + '\n\n---',
    );
  }
}
