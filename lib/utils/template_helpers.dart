import 'dart:io';
import 'package:path/path.dart';
import 'package:espada/models/project.dart';
import 'package:mustache_template/mustache.dart';
import 'package:http/http.dart' as http;

mixin TemplateHelpers {
  void createFileFromTemplate(
      Project project, String file_name, String template_name) async {
    var params = project.toJson();
    _expandParams(params, project);
    createFromTemplate(params, file_name, template_name);
  }

  void createFileFromWebTemplate(
      Project project, String file_name, String template_name) async {
    var params = project.toJson();
    _expandParams(params, project);
    createFromWebTemplate(params, file_name, template_name);
  }

  void deleteFileFromProject(Project project, String file_name) async {
    var file = File(file_name);
    if (await file.exists()) {
      file.deleteSync();
    }
    print('Deleting File: $file_name');
    if (project.header_files.contains(file_name)) {
      project.header_files.remove(file_name);
    }
    if (project.src_files.contains(file_name)) {
      project.src_files.remove(file_name);
    }
    if (project.test_files.contains(file_name)) {
      project.test_files.remove(file_name);
    }
  }

  void createFileFromURL(Project project, String file, String url) async {
    await http.get(url).then((response) {
      File(file).writeAsString(response.body);
    });
    print('Downloading ${file}');
  }

  void createFromTemplate(Map<String, dynamic> params, String file_name,
      String template_name) async {
    var template_path =
        join(dirname(Platform.script.path), '..', 'templates', template_name);
    print('Creating ${file_name}');
    var templateFile = await File(template_path);
    var template = Template(templateFile.readAsStringSync());
    await File(file_name).writeAsStringSync(template.renderString(params));
  }

// https://raw.githubusercontent.com/cajun-code/espada/master/templates/
  void createFromWebTemplate(Map<String, dynamic> params, String file_name,
      String template_name) async {
    var url =
        'https://raw.githubusercontent.com/cajun-code/espada/master/templates/${template_name}';
    await http.get(url).then((response) async {
      print('Creating ${file_name}');
      var template = Template(response.body);
      await File(file_name).writeAsStringSync(template.renderString(params));
    });
  }

  void _expandParams(Map<String, dynamic> params, Project project) {
    params['date_created'] = DateTime.now();
    params['user_created'] = Platform.environment['USER'];

    // Project Type
    params['project_is_exe'] = (project.project_type.toLowerCase() == 'exe');
    params['project_is_static_lib'] =
        (project.project_type.toLowerCase() == 'lib');
    params['project_is_dynamic_lib'] =
        (project.project_type.toLowerCase() == 'dll');

    // Testing Framework
    params['testing_framework_catch'] =
        (project.testing_framework.toLowerCase() == 'catch');
    params['testing_framework_gtest'] =
        (project.testing_framework.toLowerCase() == 'gtest');
  }

  void generateCMakeFromWeb(Project project) async {
    if (!project.lock_cmake) {
      print('Regenerating Cmake file');
      await createFileFromWebTemplate(
          project, 'CMakeLists.txt', 'cmakelist.txt');
    } else {
      print('Cmake file is locked and will not be regenerated.');
    }
  }
}
