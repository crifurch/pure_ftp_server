import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../ftp_command_handler.dart';

class UnknownHandler extends FtpCommandHandler {
  UnknownHandler();

  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    return const FtpResponse.error('this ftp server doesn\'t support this command');
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.UNKNOWN];
}
