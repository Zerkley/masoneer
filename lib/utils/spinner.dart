import 'dart:async';
import 'dart:io';

/// Shows an ASCII spinner animation while an async operation is running.
///
/// Usage:
/// ```dart
/// final result = await showSpinner(
///   message: 'Loading...',
///   operation: () => someAsyncOperation(),
/// );
/// ```
Future<T> showSpinner<T>({
  required String message,
  required Future<T> Function() operation,
}) async {
  final spinnerFrames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
  int frameIndex = 0;

  // Start the spinner animation
  // Use stderr to avoid conflicts with commander_ui which uses stdout
  final spinnerTimer = Timer.periodic(const Duration(milliseconds: 100), (
    timer,
  ) {
    stderr.write('\r${spinnerFrames[frameIndex]} $message');
    stderr.flush();
    frameIndex = (frameIndex + 1) % spinnerFrames.length;
  });

  try {
    // Run the actual operation
    final result = await operation();
    // Stop the spinner
    spinnerTimer.cancel();
    // Clear the spinner line from stderr
    stderr.write('\r${' ' * (message.length + spinnerFrames[0].length + 1)}\r');
    stderr.flush();
    // Add a small delay to ensure stdout is ready for commander_ui
    await Future.delayed(const Duration(milliseconds: 50));
    return result;
  } catch (e) {
    // Stop the spinner on error
    spinnerTimer.cancel();
    // Clear the spinner line from stderr
    stderr.write('\r${' ' * (message.length + spinnerFrames[0].length + 1)}\r');
    stderr.flush();
    // Add a small delay to ensure stdout is ready
    await Future.delayed(const Duration(milliseconds: 50));
    rethrow;
  }
}
