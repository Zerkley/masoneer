import 'package:commander_ui/commander_ui.dart';

Future<void> getUserSelection(Commander commander) async {
  final value = await commander.select(
    'Select a menu',
    onDisplay: (value) => value,
    defaultValue: 'Mason',
    options: ['Mason', 'Android sign'],
  );

  switch (value) {
    case 'Mason':
      //move to the mason screen here
      print('moving to mason');
      break;
    case 'Android Sign':
      //move to android sign screen
      break;
    default:
      print('Invalid option selected');
  }
}
