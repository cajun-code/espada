import 'package:args/command_runner.dart';
import 'package:espada/models/project.dart';
import 'package:espada/utils/template_helpers.dart';
import 'package:recase/recase.dart';
import 'dart:io';
import 'dart:convert';

class ProjectCommand extends Command with TemplateHelpers {
  @override
  final name = 'new';

  @override
  final description = 'Create C++ Project';

  ProjectCommand() {
    argParser.addFlag('include-test',
        abbr: 't',
        help: 'Include testing framework in project?',
        defaultsTo: true);
    argParser.addFlag('use-conan',
        abbr: 'c', help: 'setup project with conan support?', defaultsTo: true);
    argParser.addOption('name',
        abbr: 'n', help: 'Name of the project to create');
    argParser.addOption('include-dir',
        abbr: 'i',
        help: 'Name of the include dircetory of the project',
        defaultsTo: 'include');
    argParser.addOption('src-dir',
        abbr: 's',
        help: 'Name of the source directory of the project',
        defaultsTo: 'src');
    argParser.addOption('test-dir',
        abbr: 'T',
        help: 'Name of the test directory for the project',
        defaultsTo: 'test');
    argParser.addOption('test-include-dir',
        abbr: 'I',
        help: 'Name of the include dircetory of the project',
        defaultsTo: 'include');
    argParser.addOption('test-src-dir',
        abbr: 'S',
        help: 'Name of the source directory of the project',
        defaultsTo: 'src');
    argParser.addOption('test-framework',
        abbr: 'F',
        help: 'Testing Framework to Use',
        allowed: ['gTest', 'catch'],
        defaultsTo: 'catch');
    argParser.addOption('project-type',
        abbr: 'p',
        help: 'Type of project to create',
        allowed: ['exe', 'lib', 'dll'],
        defaultsTo: 'exe');
  }

  @override
  void run() async {
    //print(argResults.rest);
    String name = argResults['name'];
    if (name == null) {
      if (argResults.rest.length > 0) {
        name = argResults.rest[0];
      } else {
        print('Name is a required field');
        return;
      }
    }
    Project project = Project(
        name: name.pascalCase,
        use_conan: argResults['use-conan'],
        include_dir: argResults['include-dir'],
        src_dir: argResults['src-dir'],
        project_type: argResults['project-type'],
        include_test: argResults['include-test'],
        test_dir: argResults['test-dir'],
        test_include_dir: argResults['test-include-dir'],
        test_src_dir: argResults['test-src-dir'],
        testing_framework: argResults['test-framework']);

    print(project.name.snakeCase);

    // create project folder
    var proj_dir =
        await Directory(project.name.snakeCase).create(recursive: true);
    // create include folder
    var include_dir =
        await Directory("${project.name.snakeCase}/${project.include_dir}")
            .create(recursive: true);
    createFileFromWebTemplate(project,
        '${project.name.snakeCase}/${project.include_dir}/.gitkeep', 'gitkeep');
    // create src folder
    var src_dir =
        await Directory("${project.name.snakeCase}/${project.src_dir}")
            .create(recursive: true);
    // create main.cpp
    createFileFromWebTemplate(project,
        '${project.name.snakeCase}/${project.src_dir}/main.cpp', 'main.cpp');
    project.src_files.add('${project.src_dir}/main.cpp');
    await createTestProjects(project);
    // create espada file
    await File('${project.name.snakeCase}/.espada')
        .writeAsStringSync(jsonEncode(project));
    print('Creating espada project file ');
    // create cmake file
    if (project.use_conan) {
      createFileFromWebTemplate(
          project, '${project.name.snakeCase}/conanfile.txt', 'conanfile.txt');
    }
    createFileFromWebTemplate(
        project, '${project.name.snakeCase}/CMakeLists.txt', 'cmakelist.txt');
  }

  Future createTestProjects(Project project) async {
    if (project.include_test) {
      // create test folder
      var test_dir =
          await Directory("${project.name.snakeCase}/${project.test_dir}")
              .create(recursive: true);
      // create test_dir
      var test_include_dir = await Directory(
              "${project.name.snakeCase}/${project.test_dir}/${project.test_include_dir}")
          .create(recursive: true);
      var test_src_dir = await Directory(
              "${project.name.snakeCase}/${project.test_dir}/${project.test_src_dir}")
          .create(recursive: true);
      // download test tools
      var catch_url =
          'https://raw.githubusercontent.com/catchorg/Catch2/master/single_include/catch2/catch.hpp';
      var catch_file =
          "${project.name.snakeCase}/${project.test_dir}/${project.test_include_dir}/catch.hpp";
      createFileFromURL(project, catch_file, catch_url);
      catch_url =
          'https://raw.githubusercontent.com/eranpeer/FakeIt/master/single_header/catch/fakeit.hpp';
      catch_file =
          "${project.name.snakeCase}/${project.test_dir}/${project.test_include_dir}/fakeit.hpp";
      createFileFromURL(project, catch_file, catch_url);
      // create catach_main.cpp
      createFileFromWebTemplate(
          project,
          '${project.name.snakeCase}/${project.test_dir}/${project.test_src_dir}/test_main.cpp',
          'test_main.cpp');
    }
  }
}
