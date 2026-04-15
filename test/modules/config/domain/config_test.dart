import 'package:masoneer/modules/config/data/config_repository.dart';
import 'package:masoneer/modules/config/domain/config.dart';
import 'package:test/test.dart';

void main() {
  group('GitHubRepoConfig', () {
    test('fromMap uses defaults for missing keys', () {
      final r = GitHubRepoConfig.fromMap(<String, dynamic>{});
      expect(r.name, '');
      expect(r.githubUrl, '');
      expect(r.authToken, isNull);
      expect(r.isValid, isFalse);
    });

    test('fromMap reads all keys', () {
      final r = GitHubRepoConfig.fromMap(<String, dynamic>{
        'name': 'MyRepo',
        'github_url': 'https://github.com/o/r',
        'auth_token': 'secret',
      });
      expect(r.name, 'MyRepo');
      expect(r.githubUrl, 'https://github.com/o/r');
      expect(r.authToken, 'secret');
      expect(r.isValid, isTrue);
    });

    test('fromMap allows null auth_token', () {
      final r = GitHubRepoConfig.fromMap(<String, dynamic>{
        'name': 'A',
        'github_url': 'https://a.com',
        'auth_token': null,
      });
      expect(r.authToken, isNull);
    });

    test('isValid is false when name or url is empty', () {
      expect(
        GitHubRepoConfig(name: '', githubUrl: 'https://x').isValid,
        isFalse,
      );
      expect(GitHubRepoConfig(name: 'a', githubUrl: '').isValid, isFalse);
      expect(
        GitHubRepoConfig(name: 'a', githubUrl: 'u').isValid,
        isTrue,
      );
    });

    test('toMap omits auth_token when null', () {
      final m = GitHubRepoConfig(
        name: 'n',
        githubUrl: 'u',
      ).toMap();
      expect(m.containsKey('auth_token'), isFalse);
    });

    test('toMap includes auth_token when set', () {
      final m = GitHubRepoConfig(
        name: 'n',
        githubUrl: 'u',
        authToken: 't',
      ).toMap();
      expect(m['auth_token'], 't');
    });

    test('round-trip via toMap and fromMap', () {
      final original = GitHubRepoConfig(
        name: 'R',
        githubUrl: 'https://github.com/a/b',
        authToken: 'tok',
      );
      final restored = GitHubRepoConfig.fromMap(original.toMap());
      expect(restored.name, original.name);
      expect(restored.githubUrl, original.githubUrl);
      expect(restored.authToken, original.authToken);
    });
  });

  group('AppConfig', () {
    test('fromMap with missing github uses empty repos', () {
      final c = AppConfig.fromMap(<String, dynamic>{});
      expect(c.repos, isEmpty);
    });

    test('fromMap with github but no repos list uses empty repos', () {
      final c = AppConfig.fromMap(<String, dynamic>{
        'github': <String, dynamic>{},
      });
      expect(c.repos, isEmpty);
    });

    test('fromMap filters out invalid repo entries', () {
      final c = AppConfig.fromMap(<String, dynamic>{
        'github': <String, dynamic>{
          'repos': <dynamic>[
            <String, dynamic>{
              'name': '',
              'github_url': 'https://ok',
            },
            <String, dynamic>{
              'name': 'Good',
              'github_url': 'https://github.com/o/r',
            },
          ],
        },
      });
      expect(c.repos, hasLength(1));
      expect(c.repos.single.name, 'Good');
    });

    test('fromMap keeps multiple valid repos', () {
      final c = AppConfig.fromMap(<String, dynamic>{
        'github': <String, dynamic>{
          'repos': <dynamic>[
            <String, dynamic>{
              'name': 'A',
              'github_url': 'https://a',
            },
            <String, dynamic>{
              'name': 'B',
              'github_url': 'https://b',
            },
          ],
        },
      });
      expect(c.repos.map((e) => e.name).toList(), ['A', 'B']);
    });

    test('toMap nests under github.repos', () {
      final c = AppConfig(
        repos: [
          GitHubRepoConfig(name: 'X', githubUrl: 'https://x'),
        ],
      );
      final m = c.toMap();
      expect(m['github'], isA<Map>());
      final gh = m['github']! as Map<String, dynamic>;
      expect(gh['repos'], isA<List>());
      expect((gh['repos'] as List).length, 1);
    });

    test('round-trip preserves repo data', () {
      final original = AppConfig(
        repos: [
          GitHubRepoConfig(
            name: 'One',
            githubUrl: 'https://1',
            authToken: 't',
          ),
        ],
      );
      final restored = AppConfig.fromMap(original.toMap());
      expect(restored.repos, hasLength(1));
      expect(restored.repos.single.name, 'One');
      expect(restored.repos.single.githubUrl, 'https://1');
      expect(restored.repos.single.authToken, 't');
    });
  });

  group('defaultAppConfig', () {
    test('round-trip with AppConfig.fromMap matches known defaults', () {
      final roundTrip = AppConfig.fromMap(defaultAppConfig.toMap());
      expect(roundTrip.repos, hasLength(1));
      expect(roundTrip.repos.single.name, 'Very Good Templates');
      expect(
        roundTrip.repos.single.githubUrl,
        'https://github.com/VeryGoodOpenSource/very_good_templates',
      );
      expect(roundTrip.repos.single.authToken, isNull);
    });
  });
}
