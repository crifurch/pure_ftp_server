import 'dart:async';

import 'package:pure_ftp_server/src/client/export.dart';
import 'package:pure_ftp_server/src/ftp/command/ftp_commands.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/utils/format_date.dart';

import '../../../../file_system/export.dart';
import '../../ftp_command_handler.dart';

class ListHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    final dataSocket = session.dataSocket;
    if (dataSocket == null) {
      return const FtpResponse.error(
        'You must establish transfer connection before',
      );
    }
    final entity = session.fileSystem.getEntity(session.getRelativePath(
      options.command.argsLine,
    ));
    final list = <FsEntity>[];
    if (entity is FsFile) {
      list.add(entity);
    } else if (entity is FsDirectory) {
      list.addAll(entity.list());
    }
    if (list.isEmpty && (entity is FsDirectory && !entity.exists)) {
      return const FtpResponse.error('file system entity not found');
    }
    session.write(const FtpResponse.transferAccept());
    session.write(const FtpResponse(226, message: 'Options: -l'));
    session.write(FtpResponse(226, message: 'Options: ${list.length} matches'));

    for (final entity in list) {
      //todo: mind about owner and group and number of items
      dataSocket.write(
        ''
                '${entity.permissionsString}'
                ' 1' // Number of items
                ' unknown' // File owner
                ' unknown' // File group
                ' ${entity.size}' // File size in bytes
                ' ${formatListDate(entity.lastModified)}' // lastModified dateTime
                ' ${entity.name}'
                '\r\n'
            .codeUnits,
      );
    }
    await session.closeDataSocket();

    return const FtpResponse.transferComplete();
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.LIST];
}
