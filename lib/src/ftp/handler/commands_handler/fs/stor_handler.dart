import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';

class StorHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    final filePath = session.getRelativePath(options.command.args.join());
    if (filePath.isEmpty) {
      return const FtpResponse.error('You should provide path');
    }
    if (!(session.dataSocket?.isConnected ?? true)) {
      return const FtpResponse.error('No active transfer socket');
    }
    final entity = session.fileSystem.getEntity(filePath);
    if ((entity?.exists ?? false) && entity is Directory) {
      return const FtpResponse.error(
          'can not create file, directory with current name already exists');
    }
    final file = session.fileSystem.getFile(filePath);
    if (!file.exists) {
      file.create();
    }

    final write = file.write();
    await write.addStream(session.dataSocket!.listenStream());
    await session.closeDataSocket();
    await write.close();
    try {
      file.applyPermissions(session.fileSystem.defaultUMask);
    } on Exception catch (e) {
      options.logCallback?.call(e.toString());
    }

    return const FtpResponse.transferComplete();
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.STOR];
}
