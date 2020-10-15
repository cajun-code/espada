import 'package:args/command_runner.dart';
import 'package:espada/commands/header_command.dart';
import 'package:espada/commands/source_command.dart';
import './commands/project_command.dart';
import './commands/class_command.dart';

const String VERSION = '3.0.1';

class Espada {
  static void run(List<String> args) {
    var runner = CommandRunner('espada', 'Project tools for C++ Development');
    runner.addCommand(ProjectCommand());
    runner.addCommand(ClassCommand());
    runner.addCommand(HeaderCommand());
    runner.addCommand(SourceCommand());
    runner.run(args).catchError((error) {
      print('Espada: v$VERSION');
      runner.printUsage();
    });
  }
}
