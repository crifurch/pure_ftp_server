import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/file_system/definition/file_system.dart';
import 'package:pure_ftp_server/src/ftp/command/parser.dart';
import 'package:pure_ftp_server/src/ftp/ftp_work_mode.dart';
import 'package:pure_ftp_server/src/ftp/handler/ftp_command_handler.dart';
import 'package:pure_ftp_server/src/ftp/handler/root_command_handler.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/ftp/transfer_type.dart';
import 'package:pure_ftp_server/src/transfer/transfer_socket.dart';
import 'package:pure_ftp_server/src/utils/extensions/string_extension.dart';
import 'package:pure_ftp_server/src/utils/typedefs.dart';

part 'client_auth_session.dart';

part 'client_nonauth_session.dart';

class ClientSession {
  final LogCallback? _logCallback;
  final Socket _controlSocket;
  final Stream<Uint8List> _inStream;
  final FtpCommandParser _commandParser;
  late StreamSubscription<Uint8List> _listen;
  final FtpCommandHandler _commandHandler;

  ClientSession({
    required Socket socket,
    required Stream<Uint8List> inStream,
    LogCallback? logCallback,
    FtpCommandParser? commandParser,
    FtpCommandHandler? commandHandler,
  })  : _logCallback = logCallback,
        _controlSocket = socket,
        _inStream = inStream,
        _commandParser = commandParser ?? const FtpCommandParser(),
        _commandHandler = commandHandler ?? StaticCommandHandler() {
    _listen = _inStream.listen(_onMessage, onDone: close);
  }

  void _onMessage(Uint8List messageList) async {
    final decode = utf8.decode(messageList);
    final command = _commandParser.parse(decode);
    _logCallback?.call(
      '[${DateTime.now().toString()}] '
      '${_controlSocket.remoteAddress.address}:${_controlSocket.remoteAddress.address}< '
      '$decode',
    );
    FtpResponse response;
    try {
      response = await _commandHandler
          .handle(
            CommandHandlerOptions(
              session: this,
              command: command,
            ),
          )
          .catchError(
            (error) => const FtpResponse.error('Error while handling'),
          );
    } on Exception {
      response = const FtpResponse.error('Error while handling');
    }
    write(response);
  }

  void write(FtpResponse response) {
    final responseString = '${response.code} ${response.message}';
    _controlSocket.write('$responseString\r\n');
    _logCallback?.call(
      '[${DateTime.now().toString()}] '
      '${_controlSocket.remoteAddress.address}:${_controlSocket.remoteAddress.address}> '
      '$responseString',
    );
  }

  Future<void> _quit() => _listen.cancel();

  Future<void> close() async {
    await _quit();
    await _controlSocket.close();
    _logCallback?.call('Connection closed');
  }
}
