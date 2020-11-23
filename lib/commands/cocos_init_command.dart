import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:espada/models/project.dart';
import 'package:espada/utils/project_helpers.dart';
import 'package:espada/utils/template_helpers.dart';

class CocosInitCommand extends Command with TemplateHelpers, ProjedctHelpers {
  @override
  String get description => 'init espada to work inside a cocos2d-x project';

  @override
  String get name => 'init';

  CocosInitCommand() {}

  @override
  void run() async {
    // read local cmake file to extract APP_NAME
    var file = File('CMakeLists.txt');
    var name;
    if (await file.exists()) {
      var content = await file.readAsString();
      var key = 'set(APP_NAME';
      var start = content.indexOf(key);
      var end = content.indexOf(')', start);
      name = content.substring(start + key.length, end).trim();
      print('Application name: $name');
    }
    project = Project(
      name: name,
      include_dir: 'Classes',
      src_dir: 'Classes',
      include_test: false,
      lock_cmake: true,
      project_type: 'exe',
      use_conan: false,
      test_dir: 'test',
      test_include_dir: 'include',
      test_src_dir: 'src',
      testing_framework: 'catch',
    );
    await saveProject();
  }
}
