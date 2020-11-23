import 'package:espada/commands/class_command.dart';

class CocosLayerCommand extends ClassCommand {
  @override
  String get description => 'Create a layer class for cocos';

  @override
  String get name => 'layer';
  @override
  String get src_file_name => 'layer.cpp';

  @override
  String get h_file_name => 'layer.h';
}
