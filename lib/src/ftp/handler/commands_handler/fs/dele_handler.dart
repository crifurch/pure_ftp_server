import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';

import '../../ftp_command_handler.dart';

class DeleHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    final dir = session.getRelativePath(options.command.args.join());
    if (dir.isEmpty) {
      return const FtpResponse.error('You should provide path');
    }
    final directory = session.fileSystem.getDirectory(dir);
    if (directory.exists) {
      return const FtpResponse.error('FSEntity not exist exists');
    }
    try {
      directory.delete();
    } on Exception {
      return const FtpResponse.permissionDenied();
    }
    return const FtpResponse.success('Directory created successfully');
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.DELE];
}
