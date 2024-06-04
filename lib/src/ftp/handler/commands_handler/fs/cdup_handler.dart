import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class CdUpHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    session.changePath('..');
    return FtpResponse.success(session.currentPath);
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.CDUP];
}
