library emoji_lumberdash;

import 'package:ansicolor/ansicolor.dart';
import 'package:lumberdash/lumberdash.dart';

/// [LumberdashClient] that colors your logs adds emoji's for more visual clarity.
class EmojiLumberdash extends LumberdashClient {
  /// Number of stacktrace lines to show in the logs for non-error entries
  final int methodCount;

  /// Number of stacktrace lines to show in the log for error entries
  final int errorMethodCount;

  /// The length of the horizontal separator lines
  final int lineLength;

  /// Whether to show the current system time at which the log was submitted
  final bool printTime;

  /// Whether to show an emoji at the start of the log
  final bool printEmoji;

  /// Whether to wrap the log body into boxes. (More readable but
  /// ┌───────
  /// │ It takes more space)
  /// └───────
  final bool printBox;

  String _topBorder = '';
  String _middleBorder = '';
  String _bottomBorder = '';

  EmojiLumberdash(
      {this.methodCount = 0,
      this.errorMethodCount = 5,
      this.lineLength = 50,
      this.printTime = false,
      this.printEmoji = true,
      this.printBox = true}) {
    var doubleDividerLine = StringBuffer();
    var singleDividerLine = StringBuffer();

    for (var i = 0; printBox && i < lineLength - 1; i++) {
      doubleDividerLine.write(_doubleDivider);
      singleDividerLine.write(_singleDivider);
    }

    _topBorder = '$_topLeftCorner$doubleDividerLine';
    _middleBorder = '$_middleCorner$singleDividerLine';
    _bottomBorder = '$_bottomLeftCorner$doubleDividerLine';

    if (!printBox) _verticalLine = '';
  }

  static const _topLeftCorner = '┌';
  static const _middleCorner = '├';
  static const _doubleDivider = '─';
  static const _singleDivider = '┄';
  static var _verticalLine = '│';
  static const _bottomLeftCorner = '└';

  static final Map<String, AnsiPen> _levelColors = {
    'message': AnsiPen()..white(),
    'warning': AnsiPen()..yellow(),
    'error': AnsiPen()..xterm(196),
    'fatal': AnsiPen()..xterm(200),
  };

  static const Map<String, String> _levelEmojis = {
    'message': '💡  ',
    'warning': '⚠️ ',
    'error': '⛔ ',
    'fatal': '💀  ',
  };

  /// Prints a regular message preceded by a light bulb and in grey color.
  @override
  void logMessage(String message, [Map<String, String> extras]) {
    _printFormatted('message', message, extras: extras);
  }

  /// Prints the given message preceded by a warning sign and in yellow color.
  @override
  void logWarning(String message, [Map<String, String> extras]) {
    _printFormatted('warning', message, extras: extras);
  }

  /// Prints the given message preceded by a skull sign and in magenta color.
  @override
  void logFatal(String message, [Map<String, String> extras]) {
    _printFormatted('fatal', message, extras: extras);
  }

  /// Prints the given message preceded by a no-entry sign  and in red color.
  @override
  void logError(dynamic exception, [dynamic stacktrace]) {
    _printFormatted('error', exception.toString(), stacktrace: stacktrace);
  }

  void _printFormatted(
    String tag,
    String message, {
    Map<String, String> extras,
    StackTrace stacktrace,
  }) {
    final color = _levelColors[tag];
    var buffer = <String>[];

    if (printBox) buffer.add(color(_topBorder));

    if (extras != null) message = '$message , extras: $extras';

    var messages = message.split('\n');
    var emoji = printEmoji ? _levelEmojis[tag] : '';
    //Message
    for (var i = 0; i < messages.length; i++) {
      var line = messages[i];
      if (i == 0) {
        buffer.add(color('$_verticalLine $emoji$line'));
      } else {
        buffer.add(color('$_verticalLine $line'));
      }
    }
    // Stacktrace
    List<String> stackTraceFormatted;
    if (stacktrace == null) {
      if (methodCount > 0) {
        stackTraceFormatted = formatStackTrace(StackTrace.current, methodCount, color);
      }
    } else if (errorMethodCount > 0) {
      stackTraceFormatted = formatStackTrace(stacktrace, errorMethodCount, color);
    }

    if (stackTraceFormatted != null) {
      if (printBox) buffer.add(color(_middleBorder));

      buffer.addAll(stackTraceFormatted);
    }

    // Time

    if (printTime) {
      if (printBox) buffer.add(color(_middleBorder));

      buffer.add(color('$_verticalLine${_getTime()}'));
    }
    if (printBox) buffer.add(color(_bottomBorder));

    buffer.forEach(print);
  }

  static final stackTraceRegex = RegExp(r'#[0-9]+[\s]+(.+) \(([^\s]+)\)');

  List<String> formatStackTrace(StackTrace stackTrace, int methodCount, AnsiPen color) {
    var lines = stackTrace.toString().split('\n');

    var formatted = <String>[];
    for (var i = 0; i < methodCount && i < lines.length; i++) {
      var line = lines[i];

      var match = stackTraceRegex.matchAsPrefix(line);

      if (match != null) {
        var newLine = color('$_verticalLine #$i => ${match.group(1)} (${match.group(2)})');
        formatted.add(newLine.replaceAll('<anonymous closure>', '()'));
      }
    }
    return formatted;
  }

  String _getTime() {
    final now = DateTime.now();

    var h = now.hour;
    var min = now.minute;
    var sec = now.second;
    var ms = now.millisecond;

    var emoji = printEmoji ? '⏳' : '';

    return ' $emoji $h:$min:$sec.$ms ';
  }
}
