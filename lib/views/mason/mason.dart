import 'package:commander_ui/commander_ui.dart';
import 'package:octodart/modules/config/domain/config.dart';
import 'package:octodart/modules/github/github_repository.dart';
import 'package:octodart/routing/custom_router.dart';
import 'package:octodart/utils/spinner.dart';

class MasonScreen extends TuiScreen {
  final Commander commander;
  final AppConfig config;

  MasonScreen(this.commander, this.config) : super('Mason');

  @override
  Future<ScreenAction> run() async {
    final gitRepo = GithubClientRepository();

    final bricksList = await showSpinner(
      message: 'Loading bricks...',
      operation: () => gitRepo.listRepoContents(
        config.github.bricksUrl,
        token: config.github.authToken,
      ),
    );

    if (bricksList.isNotEmpty) {
      final options = [...bricksList, 'Back'];

      final value = await commander.select(
        'Select a brick',
        onDisplay: (value) => value,
        placeholder: 'Type to search',
        defaultValue: bricksList[0],
        options: options,
      );

      if (value == 'Back') {
        // POP: Go back to the previous screen
        return ScreenAction.pop();
      } else {
        print(value);
        // After selection, go back to previous screen
        return ScreenAction.pop();
      }
    } else {
      print('No bricks found.');
      // Show a menu with just Back option if no bricks found
      final value = await commander.select(
        'No bricks available',
        onDisplay: (value) => value,
        options: ['Back'],
      );

      if (value == 'Back') {
        return ScreenAction.pop();
      }
      return ScreenAction.pop();
    }
  }
}
