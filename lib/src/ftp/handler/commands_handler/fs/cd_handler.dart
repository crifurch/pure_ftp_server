import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class CdHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;

    if (options.command.args.isNotEmpty) {
      try {
        session.changePath(options.command.args.join());
      } on Exception {
        return const FtpResponse.error('No such directory');
      }
    }

    return FtpResponse.success(session.currentPath);
  }

  @override
  List<FtpCommands> get supportedCommands => [
        FtpCommands.CD,
        FtpCommands.CWD,
      ];
}
