import 'package:args/command_runner.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';

class CmakeLockCommand extends Command with ProjedctHelpers {
  @override
  String get description =>
      'Lock erebus to stop it from overriting the cmakelist file';

  @override
  String get name => 'lock';

  @override
  void run() async {
    try {
      await loadProject();
      project.lock_cmake = true;
      await saveProject();
    } on NotAProjectExcpetion catch (e) {
      print(e.errMsg());
    }
  }
}
