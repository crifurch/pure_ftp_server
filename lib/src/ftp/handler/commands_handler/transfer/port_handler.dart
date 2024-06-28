import 'dart:async';

import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/transfer/active_transfer_socket.dart';

import '../../ftp_command_handler.dart';

class PortHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    final parts = FtpCommandHandler.safeGetArg(options.command, 0).split(',');
    try {
      session.dataSocket = ActiveTransferSocket(
        parts.take(4).join('.'),
        (int.parse(parts[4]) << 8) | int.parse(parts[5]),
      );
      await session.dataSocket!.connect(
        timeout: const Duration(seconds: 5),
      );
    } on TimeoutException {
      return const FtpResponse.error(
        'Can not establish active mode connection',
      );
    }
    return const FtpResponse.success(
      'Active mode connection established',
    );
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.PORT];
}
