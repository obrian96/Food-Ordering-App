import 'dart:developer' as developer;

// TODO: Need to improve log levels.
class Log {
  static void i(String tag, String message) {
    developer.log(
      tag + ': \n\n' + message + '\n\n---',
      name: 'Info',
    );
  }

  static void d(String tag, String message) {
    developer.log(
      tag + ': \n\n' + message + '\n\n---',
      name: 'Debug',
    );
  }

  static void w(String tag, String error) {
    developer.log(
      tag + ': ',
      name: 'Warning',
      error: '\n' + error + '\n\n---',
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
