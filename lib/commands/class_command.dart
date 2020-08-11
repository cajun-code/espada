import 'package:args/command_runner.dart';
import 'package:espada/models/project.dart';
import 'package:espada/utils/template_helpers.dart';
import 'package:recase/recase.dart';
import 'dart:io';
import 'dart:convert';

class ClassCommand extends Command with TemplateHelpers{
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
    var project_file = File('.espada');
    var project_found = await project_file.exists();
    if(project_found){
    // load project
    var project = Project.fromJson(jsonDecode( project_file.readAsStringSync()));
    print('loading project ${project.name}');
    // create header file
    // create cpp file
    // create test file
    // update project file
    // save project file
    // regenerate cmake
    }else{
      print('Please execute command inside main directory an Espada project');
    }
  }

}