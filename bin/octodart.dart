import 'package:commander_ui/commander_ui.dart';
import 'package:octodart/views/home/home.dart';

Future<void> main() async {
  // 1. Initialize Commander in main
  final commander = Commander(level: Level.verbose);

  // 2. Call the new function and await its completion
  await getUserSelection(commander);
}
