import 'package:pure_ftp_server/src/client/client_session.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class PassHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final args = options.command.args;
    if (args.isEmpty) {
      return const FtpResponse.error('you must provide username');
    }
    final ftpSession = await (options.session as ClientNonAuthorizedSession)
        .login(password: args.join(' '));

    if (identical(ftpSession, options.session)) {
      return const FtpResponse.error('Wrong Username or password');
    } else {
      return const FtpResponse.success('Successful authorized');
    }
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.PASS];
}
