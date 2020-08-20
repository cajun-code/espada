import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';
import 'package:espada/utils/template_helpers.dart';
import 'package:recase/recase.dart';

class SourceCommand extends Command with TemplateHelpers, ProjedctHelpers {
  @override
  String get description => 'Create a C++ source file ';

  @override
  String get name => 'source';

  SourceCommand() {
    argParser.addOption('name', abbr: 'n', help: 'Name of the class to create');
    argParser.addFlag('delete',
        abbr: 'd',
        help: 'Delete files created by this gnerator',
        defaultsTo: false);
  }

  @override
  void run() async {
    // check if projet
    // load project
    try {
      await loadProject();
      // ignore: omit_local_variable_types
      Map<String, dynamic> params = {};
      String name = argResults['name'];
      if (name == null) {
        if (argResults.rest.isNotEmpty) {
          name = argResults.rest[0];
        } else {
          print('Name is a required field');
          return;
        }
      }
      params['date_created'] = DateTime.now();
      params['user_created'] = Platform.environment['USER'];
      params['f_name'] = name.snakeCase;
      params['class_name'] = name.pascalCase;
      if (argResults['delete']) {
        print("Deleting source ${params['class_name']}");
      } else {
        print("Creating source ${params['class_name']}");
      }
      // create header file
      params['ext'] = 'cpp';
      var path = '${project.src_dir}/${params['f_name']}.${params['ext']}';
      if (argResults['delete']) {
        await deleteFileFromProject(project, path);
      } else {
        await createFromWebTemplate(params, path, 'file_header.h');
        project.src_files.add(path);
      }
      // save project file
      await saveProject();
      // regenerate cmake
      await createFileFromWebTemplate(
          project, 'CMakeLists.txt', 'cmakelist.txt');
    } on NotAProjectExcpetion catch (e) {
      print(e.errMsg());
    }
  }
}
