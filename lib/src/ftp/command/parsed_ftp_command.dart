import 'package:meta/meta.dart';

import 'ftp_commands.dart';

@immutable
class ParsedFtpCommand {
  final FtpCommands command;
  final List<String> args;

  const ParsedFtpCommand(this.command, this.args);

  ParsedFtpCommand copyWithArgs(List<String> args) {
    return ParsedFtpCommand(command, args);
  }
}
