import 'package:emoji_lumberdash/emoji_lumberdash.dart';
import 'package:lumberdash/lumberdash.dart';

void main() {
  putLumberdashToWork(withClients: [EmojiLumberdash()]);
  logWarning('Hello Warning');
  logFatal('Hello Fatal!');
  logMessage('Hello Message!');
  logError(Exception('Hello Error'), stacktrace: StackTrace.current);
}
