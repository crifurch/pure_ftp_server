import 'package:pure_ftp_server/pure_ftp_server.dart';

class RetrHandler extends FtpCommandHandler {
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
    final file = session.fileSystem.getFile(filePath);
    if (!file.exists) {
      return const FtpResponse.error(
          'can not create file? directory with current name already exists');
    }
    // ignore: prefer_foreach
    await for (final i in file.read()) {
      session.dataSocket!.write(i);
    }
    await session.closeDataSocket();

    return const FtpResponse.transferComplete();
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.RETR];
}
