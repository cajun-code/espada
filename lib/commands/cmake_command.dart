import 'package:args/command_runner.dart';
import 'package:espada/commands/cmake_generate_command.dart';
import 'package:espada/commands/cmake_unlock_command.dart';

import 'cmake_lock_command.dart';

class CmakeCommand extends Command {
  @override
  String get description => 'control cmake generation';

  @override
  String get name => 'cmake';

  CmakeCommand() {
    // subcommand lock
    addSubcommand(CmakeLockCommand());
    // subcommand unlock
    addSubcommand(CmakeUnlockCommand());
    // subcommand generate
    addSubcommand(CmakeGenerateCommand());
  }
}
