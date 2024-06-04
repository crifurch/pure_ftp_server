import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/ftp/transfer_type.dart';

import '../../ftp_command_handler.dart';

class TypeHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    session.fileTransferType =
        FtpCommandHandler.safeGetArg(options.command, 0) == 'I'
            ? TransferType.binary
            : TransferType.ascii;
    return FtpResponse.success(
      'changed transfer type to ${session.fileTransferType.name}',
    );
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.TYPE];
}
