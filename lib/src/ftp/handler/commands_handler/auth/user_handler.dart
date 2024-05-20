import 'package:pure_ftp_server/src/client/ftp_session.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class UserHandler extends FtpCommandHandler {

  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final args = options.command.args;
    if (args.isEmpty) {
      return const FtpResponse.error('you must provide username');
    }
    final ftpSession = await (options.session as FtpNonAuthorizedSession)
        .login(username: args.join(' '));
    if (identical(ftpSession,options.session)) {
      return const FtpResponse(331, message: 'Provide password');
    } else {
      return const FtpResponse.success('Successful authorized');
    }
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.USER];
}
