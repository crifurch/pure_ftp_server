import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class AuthHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    // TODO: implements security layer
    return const FtpResponse.error('Security layer not supported by server');
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.AUTH];
}
