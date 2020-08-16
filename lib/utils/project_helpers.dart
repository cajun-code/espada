import 'dart:convert';
import 'dart:io';

import 'package:espada/models/project.dart';
import 'package:espada/utils/exceptions.dart';

abstract class ProjedctHelpers{

  Project project;
  
  Future<void> loadProject()async{
    // check if projet 
    var project_file = File('.espada');
    var project_found = await project_file.exists();
    if(project_found){
      // load project
      project = Project.fromJson(jsonDecode( project_file.readAsStringSync()));
      print('loading project ${project.name}');
    }else{
      throw NotAProjectExcpetion();
    }
  }

  Future saveProject()async{
    await File('.espada').writeAsStringSync(jsonEncode(project));
    print('updating espada project file ');    
  }
}