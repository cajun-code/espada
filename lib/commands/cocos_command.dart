import 'package:args/command_runner.dart';
import 'package:espada/commands/cocos_init_command.dart';
import 'package:espada/commands/cocos_layer_command.dart';

class CocosCommand extends Command {
  @override
  // TODO: implement description
  String get description => 'Cocos 2d-x Helpers ';

  @override
  // TODO: implement name
  String get name => 'cocos';

  CocosCommand() {
    // subcommand init
    addSubcommand(CocosInitCommand());
    // subcommand layer
    addSubcommand(CocosLayerCommand());
  }
}
