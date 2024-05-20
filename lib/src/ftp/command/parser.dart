import 'package:meta/meta.dart';

import 'ftp_commands.dart';
import 'parsed_ftp_command.dart';

@immutable
class FtpCommandParser {
  const FtpCommandParser();

  ParsedFtpCommand parse(String string) {
    final parts = string.trim().split(' ');
    final command = FtpCommands.values.firstWhere(
      (element) => parts.first.toUpperCase() == element.name,
      orElse: () => FtpCommands.UNKNOWN,
    );
    return ParsedFtpCommand(
      command,
      parts.skip(1).map((e) => e.trim()).toList(),
    );
  }
}
