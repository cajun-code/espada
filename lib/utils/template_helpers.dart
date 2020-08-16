import 'dart:io';
import 'package:path/path.dart';
import 'package:espada/models/project.dart';
import 'package:mustache_template/mustache.dart';
import 'package:http/http.dart' as http;

mixin TemplateHelpers {

  void createFileFromTemplate(Project project, String file_name, String template_name) async{
    var params = project.toJson();
    _expandParams(params, project);
    createFromTemplate(params, file_name, template_name);
  }

  void createFileFromURL(Project project, String file, String url ){
    http.get(url).then((response) {
      File(file).writeAsString(response.body);
    });
    print('Downloading ${file}');
  }
}

void createFromTemplate(Map<String, dynamic> params, String file_name, String template_name) async{
  var template_path = join(dirname(Platform.script.path), '..', 'templates', template_name);
    print('Creating ${file_name}');
    var templateFile = await File(template_path);
    var template = Template(templateFile.readAsStringSync());
    await File(file_name).writeAsStringSync(template.renderString(params));
}

void _expandParams(Map<String, dynamic> params, Project project) {
  params['date_created'] = DateTime.now();
  params['user_created'] = Platform.environment['USER'];
  if(project.project_type.toLowerCase() == 'exe'){
    params['project_is_exe'] = true;
    params['project_is_staic_lib'] = false;
    params['project_is_dynamic_lib'] = false;
  } else if(project.project_type.toLowerCase() == 'lib'){
    params['project_is_exe'] = false;
    params['project_is_staic_lib'] = true;
    params['project_is_dynamic_lib'] = false;
  }else{
    params['project_is_exe'] = false;
    params['project_is_staic_lib'] = false;
    params['project_is_dynamic_lib'] = true;
  }
  
  if(project.testing_framework.toLowerCase() == 'catch'){
    params['testing_framework_catch'] = true;
    params['testing_framework_gtest'] = false;
  }else if(project.testing_framework.toLowerCase() == 'gtest'){
    params['testing_framework_catch'] = false;
    params['testing_framework_gtest'] = true;
  }else{
    params['testing_framework_catch'] = false;
    params['testing_framework_gtest'] = false;
  }
}