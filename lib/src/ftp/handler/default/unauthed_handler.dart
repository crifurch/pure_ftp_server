import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../ftp_command_handler.dart';

class NonAuthorizedHandler extends FtpCommandHandler {
  NonAuthorizedHandler();

  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    return const FtpResponse.error('you should authorize before do something');
  }

  @override
  List<FtpCommands> get supportedCommands => [];
}
