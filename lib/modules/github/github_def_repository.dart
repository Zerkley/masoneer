import 'package:octodart/modules/github/github_repository.dart';

abstract class GithubRepository {
  Future<List<String>> listRepoContents(String repo, {String? token});
}
