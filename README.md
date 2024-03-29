# emoji_lumberdash

![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)
![Dart Version](https://img.shields.io/badge/dart-2.12-blue)
![MADE WITH](https://img.shields.io/static/v1.svg?labelColor=lightgray&color=gray&label=flutter&message=compatible&logo=flutter&logoColor=blue&cacheSeconds=33600)

Package for [lumberdash](https://github.com/jorgecoca/lumberdash) that colors your logs and adds emoji's for more visual clarity.

It you love the [logger](https://pub.dev/packages/logger) package output format , but the extensibility of lumberdash is a wanted feature ; this is where this package gets you.
By extending a regular LumberdashClient and formatting it's output more coherently, it gets you from the `colorize_lumberdash` not so awesome output: 
 
 ![](https://raw.githubusercontent.com/fabiancrx/emoji_lumberdash/master/art/colorize_lumberdash.png)

to this one :

![](https://raw.githubusercontent.com/fabiancrx/emoji_lumberdash/master/art/emoji_lumberdash.png)
## Options

The logger can be customized as follows:
```dart

  putLumberdashToWork(withClients: [
    EmojiLumberdash(
      methodCount: 0,         // Number of stacktrace lines to show in the logs for non-error entries.
      lineLength: 50,        // The length of the horizontal separator lines.
      printTime: false,      // Whether to show the current system time at which the log was submitted.
      errorMethodCount: 5,   // Number of stacktrace lines to show in the log for error entries.
      printEmoji:true,       // Whether to show an emoji at the start of the log.
      printBox:true,         // Whether to wrap the log body into boxes.        
      printColors:true       // Whether to color the output.
    )
  ]);

```

To achieve results  as :

![](https://raw.githubusercontent.com/fabiancrx/emoji_lumberdash/master/art/extras.png)

## Get started

### Add dependency

```yaml
dependencies:
  emoji_lumberdash: latest
```
## How to use
Pass an instance of `EmojiLumberdash` to `lumberdash`:

```dart
import 'package:emoji_lumberdash/emoji_lumberdash.dart';
import 'package:lumberdash/lumberdash.dart';

void main() {
  putLumberdashToWork(withClients: [EmojiLumberdash()]);
  logWarning('Hello Warning');
  logFatal('Hello Fatal!');
  logMessage('Hello Message!');
  logError(Exception('Hello Error'), stacktrace: StackTrace.current);
}
```
That's it you have a beautiful highly customizable logger.
