import 'package:args/command_runner.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';
import 'package:espada/utils/template_helpers.dart';

class CmakeGenerateCommand extends Command
    with ProjedctHelpers, TemplateHelpers {
  @override
  String get description => 'Generate cmake file';

  @override
  String get name => 'gen';

  @override
  void run() async {
    try {
      await loadProject();
      generateCMakeFromWeb(project);
      //await saveProject();
    } on NotAProjectExcpetion catch (e) {
      print(e.errMsg());
    }
  }
}
