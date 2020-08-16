import 'package:args/command_runner.dart';
import 'package:espada/models/project.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';
import 'package:espada/utils/template_helpers.dart';
import 'package:recase/recase.dart';
import 'dart:io';
import 'dart:convert';

class ClassCommand extends Command with TemplateHelpers, ProjedctHelpers{
  @override
  String get description => 'Create class files and include in project';

  @override
  String get name => 'class';

  ClassCommand(){
    argParser.addOption('name',abbr: 'n', help: 'Name of the class to create');
  }

  @override
  void run() async{
    // check if projet 
    // load project
    try{
      await loadProject();
      Map<String, dynamic> params = {};
      String name = argResults['name'];
      params['date_created'] = DateTime.now();
      params['user_created'] = Platform.environment['USER'];
      params['f_name'] = name.snakeCase;
      params['class_name'] = name.pascalCase;      
      print("Creating class ${params['class_name']}");
      // create header file
      params['ext'] = 'h';
      var header_path = '${project.include_dir}/${params['f_name']}.${params['ext']}';
      createFromTemplate(params, header_path, 'class_header.h');
      project.header_files.add(header_path);
      // create cpp file
      params['ext'] = 'cpp';
      var src_path = '${project.src_dir}/${params['f_name']}.${params['ext']}';
      createFromTemplate(params, src_path, 'class_body.cpp');
      project.src_files.add(src_path);
      // create test file
      if(project.include_test && project.testing_framework == 'catch'){
        var test_path = '${project.test_dir}/${project.test_src_dir}/${params['f_name']}.test.${params['ext']}';
        createFromTemplate(params, test_path, 'catch_test_case.cpp');
        project.test_files.add(test_path);
      }
      // save project file
      await saveProject();
      // regenerate cmake
      createFileFromTemplate(project,'CMakeLists.txt', 'cmakelist.txt');
    
    }
    on NotAProjectExcpetion catch(e){
      print(e.errMsg());
    }
    
  }

}