import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class PwdHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
        return FtpResponse.success((options.session as ClientAuthorizedSession).currentPath);
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.PWD];
}
