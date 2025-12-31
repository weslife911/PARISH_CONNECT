import 'package:logger/logger.dart';

// 1. Create a filter to control logging in production
class SimpleLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // Only log events if the app is NOT in release mode (i.e., debug or profile)
    return !const bool.fromEnvironment('dart.vm.product'); 
  }
}

// 2. Initialize the logger instance
final logger = Logger(
  filter: SimpleLogFilter(), // Use the custom filter
  printer: PrettyPrinter(
    methodCount: 0,          // Don't show the calling method stack trace
    errorMethodCount: 5,     // Number of method calls to be displayed on error
    lineLength: 80,          // Width of the output
    colors: true,            // Colorful log messages
    // FIX: Replace deprecated 'printTime: false,' 
    //      with the recommended 'dateTimeFormat: DateTimeFormat.none,'
    dateTimeFormat: DateTimeFormat.none,
  ),
  output: ConsoleOutput(),
);