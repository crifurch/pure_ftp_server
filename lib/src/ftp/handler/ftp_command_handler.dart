import 'package:meta/meta.dart';
import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/handler/exceptions/not_enought_params.dart';
import 'package:pure_ftp_server/src/utils/typedefs.dart';

import '../command/parsed_ftp_command.dart';
import '../response/ftp_response.dart';

abstract class FtpCommandHandler {
  List<FtpCommands> get supportedCommands;

  Future<FtpResponse> handle(CommandHandlerOptions options);

  static String safeGetArg(ParsedFtpCommand command, int index) {
    if (command.args.length < index) {
      throw NotEnoughParams(
          '${command.command.name} require at least ${index + 1} arguments');
    }
    return command.args[index];
  }
}

@immutable
class CommandHandlerOptions {
  final ClientSession session;
  final ParsedFtpCommand command;
  final LogCallback? logCallback;

  const CommandHandlerOptions(
      {required this.session, required this.command, this.logCallback});
}
