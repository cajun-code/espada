import 'package:args/command_runner.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';

class CmakeUnlockCommand extends Command with ProjedctHelpers {
  @override
  String get description =>
      'Lock erebus to stop it from overriting the cmakelist file';

  @override
  String get name => 'unlock';

  @override
  void run() async {
    try {
      await loadProject();
      project.lock_cmake = false;
      await saveProject();
    } on NotAProjectExcpetion catch (e) {
      print(e.errMsg());
    }
  }
}
