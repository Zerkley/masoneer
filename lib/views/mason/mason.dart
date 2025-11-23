import 'package:commander_ui/commander_ui.dart';
import 'package:octodart/modules/config/domain/config.dart';
import 'package:octodart/modules/github/github_repository.dart';

Future<void> getMasonSelection(Commander commander, AppConfig config) async {
  final gitRepo = GithubClientRepository();
  final bricksList = await gitRepo.listRepoContents(
    config.github.bricksUrl,
    token: config.github.authToken,
  );

  if (bricksList.isNotEmpty) {
    final value = await commander.select(
      'Select a brick',
      onDisplay: (value) => value,
      placeholder: 'Type to search',
      defaultValue: bricksList[0],
      options: bricksList,
    );

    print(value);
  } else {
    print('No bricks found, exiting...');
  }
}
