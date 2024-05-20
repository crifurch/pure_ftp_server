import 'package:meta/meta.dart';
import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';

import '../command/parsed_ftp_command.dart';
import '../response/ftp_response.dart';

abstract class FtpCommandHandler {
  List<FtpCommands> get supportedCommands;

  Future<FtpResponse> handle(CommandHandlerOptions options);
}

@immutable
class CommandHandlerOptions {
  final FtpSession session;
  final ParsedFtpCommand command;

  const CommandHandlerOptions({
    required this.session,
    required this.command,
  });
}
