import 'package:pure_ftp_server/src/client/client_session.dart';
import 'package:pure_ftp_server/src/ftp/export.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/auth/auth_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/auth/pass_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/auth/user_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/fs/cd_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/fs/cdup_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/fs/mkd_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/fs/pwd_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/misc/type_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/transfer/list_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/commands_handler/transfer/port_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/default/unknown_handler.dart';
import 'package:pure_ftp_server/src/utils/extensions/iterable_extension.dart';

import '../ftp_work_mode.dart';
import 'default/unauthed_handler.dart';

part 'static_command_handler.dart';

class RootCommandHandler extends FtpCommandHandler {
  final List<FtpCommandHandler> _registeredHandlers;
  final FtpCommandHandler _defaultHandler;

  RootCommandHandler({
    required List<FtpCommandHandler> handlers,
    required FtpCommandHandler defaultHandler,
  })  : _registeredHandlers = handlers,
        _defaultHandler = defaultHandler;

  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) {
    final handler = _registeredHandlers.firstWhereOrNull(
      (e) => e.supportedCommands.contains(options.command.command),
    );
    return (handler ?? _defaultHandler).handle(options);
  }

  @override
  List<FtpCommands> get supportedCommands => [
        for (final e in _registeredHandlers) ...e.supportedCommands,
        ..._defaultHandler.supportedCommands,
      ];
}
