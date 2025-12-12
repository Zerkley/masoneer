import 'package:commander_ui/commander_ui.dart';
import 'package:octodart/modules/config/domain/config.dart';
import 'package:octodart/routing/custom_router.dart';
import 'package:octodart/views/mason/mason.dart';
import 'package:octodart/views/android_sign/android_sign.dart';

class HomeScreen extends TuiScreen {
  final Commander commander;
  final AppConfig config;

  HomeScreen(this.commander, this.config) : super('Main Menu');

  @override
  Future<ScreenAction> run() async {
    final value = await commander.select(
      'Select a menu',
      onDisplay: (value) => value,
      defaultValue: 'Mason',
      options: ['Mason', 'Android sign', 'Exit'],
    );

    switch (value) {
      case 'Mason':
        // PUSH: Go to the Mason screen and keep HomeScreen on the stack
        return ScreenAction.push(MasonScreen(commander, config));
      case 'Android sign':
        // PUSH: Go to the Android Sign screen and keep HomeScreen on the stack
        return ScreenAction.push(AndroidSignScreen(commander, config));
      case 'Exit':
        // EXIT: Terminate the entire application
        return ScreenAction.exit();
      default:
        print('Invalid option selected.');
        // Stay on the current screen (run again)
        return ScreenAction.push(this);
    }
  }
}
