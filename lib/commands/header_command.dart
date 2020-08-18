import 'dart:io';
import 'package:args/command_runner.dart';
import 'package:espada/utils/exceptions.dart';
import 'package:espada/utils/project_helpers.dart';
import 'package:espada/utils/template_helpers.dart';

class HeaderCommand extends Command with TemplateHelpers, ProjedctHelpers{
  @override
  String get description => 'Create a header file ';

  @override
  String get name => 'header';

  HeaderCommand(){
    argParser.addOption('name',abbr: 'n', help: 'Name of the class to create');
    argParser.addFlag('delete', abbr: 'd', help: 'Delete files created by this gnerator', defaultsTo: false);
  }

  @override
  void run() async{
    // check if projet 
    // load project
    try{
      await loadProject();
      Map<String, dynamic> params = {};
      String name = argResults['name'];
      if (name == null){
        if(argResults.rest.isNotEmpty){
          name = argResults.rest[0];
        }else{
          print('Name is a required field');
          return;
        }
      }
      params['date_created'] = DateTime.now();
      params['user_created'] = Platform.environment['USER'];
      params['f_name'] = name.snakeCase;
      params['class_name'] = name.pascalCase;  
      if(argResults['delete']){
        print("Deleting class ${params['class_name']}");
      }else{    
        print("Creating class ${params['class_name']}");
      }
      // create header file
      params['ext'] = 'h';
      var header_path = '${project.include_dir}/${params['f_name']}.${params['ext']}';
      if(argResults['delete']){
        await deleteFileFromProject(project, header_path);
      }else{
        await createFromWebTemplate(params, header_path, 'file_header.h');
        project.header_files.add(header_path);
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