import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/exceptions/ftp_connection_closed_exception.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class QuitHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session;
    if (session is ClientAuthorizedSession) {
      await session.closeDataSocket();
    }
    //todo make stats
    session.write(const FtpResponse.success('good bye'));
    await session.close();
    throw FtpConnectionClosedException();
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.QUIT];
}
