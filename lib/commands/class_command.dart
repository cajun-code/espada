import 'package:args/command_runner.dart';
import 'package:espada/models/project.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';
import 'package:espada/utils/template_helpers.dart';
import 'package:recase/recase.dart';
import 'dart:io';
import 'dart:convert';

class ClassCommand extends Command with TemplateHelpers, ProjedctHelpers {
  @override
  String get description => 'Create class files and include in project';

  @override
  String get name => 'class';

  String get src_file_name => 'class_body.cpp';
  String get h_file_name => 'class_header.h';
  String get test_file_name => 'catch_test_case.cpp';

  ClassCommand() {
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
        print("Deleting class ${params['class_name']}");
      } else {
        print("Creating class ${params['class_name']}");
      }
      // create header file
      params['ext'] = 'h';
      var header_path =
          '${project.include_dir}/${params['f_name']}.${params['ext']}';
      if (argResults['delete']) {
        await deleteFileFromProject(project, header_path);
      } else {
        await createFromWebTemplate(params, header_path, h_file_name);
        project.header_files.add(header_path);
      }
      // create cpp file
      params['ext'] = 'cpp';
      var src_path = '${project.src_dir}/${params['f_name']}.${params['ext']}';
      if (argResults['delete']) {
        await deleteFileFromProject(project, src_path);
      } else {
        await createFromWebTemplate(params, src_path, src_file_name);
        project.src_files.add(src_path);
      }
      // create test file
      if (project.include_test && project.testing_framework == 'catch') {
        var test_path =
            '${project.test_dir}/${project.test_src_dir}/${params['f_name']}.test.${params['ext']}';
        if (argResults['delete']) {
          await deleteFileFromProject(project, test_path);
        } else {
          await createFromWebTemplate(params, test_path, test_file_name);
          project.test_files.add(test_path);
        }
      }
      // save project file
      await saveProject();
      // regenerate cmake
      generateCMakeFromWeb(project);
    } on NotAProjectExcpetion catch (e) {
      print(e.errMsg());
    }
  }
}
