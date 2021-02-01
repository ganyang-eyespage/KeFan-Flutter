import 'package:logger/logger.dart';

class OLogger {
  OLogger._();

  static var _logger = Logger(
    printer: PrettyPrinter(
        methodCount: 2,
        // number of method calls to be displayed
        errorMethodCount: 8,
        // number of method calls if stacktrace is provided
        lineLength: 120,
        // width of the output
        colors: true,
        // Colorful log messages
        printEmojis: true,
        // Print an emoji for each log message
        printTime: false // Should each log print contain a timestamp
        ),
  );

  static v(dynamic msg) {
    _logger.v(msg);
  }

  static i(dynamic msg) {
    _logger.i(msg);
  }

  static d(dynamic msg) {
    _logger.d(msg);
  }

  static e(dynamic msg) {
    _logger.e(msg);
  }

  ///打印重要错误日志
  static wtf(dynamic msg) {
    _logger.wtf(msg);
  }
}
