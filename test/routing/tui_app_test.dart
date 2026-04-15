import 'package:masoneer/routing/custom_router.dart';
import 'package:test/test.dart';

/// [TuiScreen] that delegates each [run] to [onRun], which receives this screen
/// and the number of times [run] has been called (1-based).
class ScriptedScreen extends TuiScreen {
  ScriptedScreen(
    super.screenName,
    this.onRun,
  );

  final Future<ScreenAction> Function(ScriptedScreen screen, int invocation)
      onRun;

  int runCount = 0;

  @override
  Future<ScreenAction> run() async {
    runCount++;
    return onRun(this, runCount);
  }
}

void main() {
  group('TuiApp', () {
    test('EXIT runs optional onExit once and ends', () async {
      var onExitCalls = 0;
      final screen = ScriptedScreen('exit', (_, _) async {
        return ScreenAction.exit(() async {
          onExitCalls++;
        });
      });

      await TuiApp(screen).run();

      expect(onExitCalls, 1);
      expect(screen.runCount, 1);
    });

    test('POP on the only screen stops the app without popping the stack', () async {
      final screen = ScriptedScreen('solo', (_, _) async {
        return ScreenAction.pop();
      });

      await TuiApp(screen).run();

      expect(screen.runCount, 1);
    });

    test('PUSH then POP returns to first screen; then EXIT', () async {
      late ScriptedScreen second;

      final first = ScriptedScreen('first', (self, n) async {
        if (n == 1) {
          second = ScriptedScreen('second', (_, _) async {
            return ScreenAction.pop();
          });
          return ScreenAction.push(second);
        }
        return ScreenAction.exit();
      });

      await TuiApp(first).run();

      expect(first.runCount, 2);
      expect(second.runCount, 1);
    });

    test('PUSH with same screen instance re-runs without growing stack', () async {
      final screen = ScriptedScreen('repeat', (self, n) async {
        if (n < 3) {
          return ScreenAction.push(self);
        }
        return ScreenAction.exit();
      });

      await TuiApp(screen).run();

      expect(screen.runCount, 3);
    });
  });
}
