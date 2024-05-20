import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/file_system/definition/file_system.dart';
import 'package:pure_ftp_server/src/ftp/command/parser.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/utils/typedefs.dart';

part 'ftp_nonauth_session.dart';
part 'ftp_auth_session.dart';

class FtpSession {
  final LogCallback? _logCallback;
  final Socket _controlSocket;
  final FtpCommandParser _commandParser;
  late StreamSubscription<Uint8List> _listen;

  FtpSession({
    required Socket socket,
    LogCallback? logCallback,
    FtpCommandParser? commandParser,
  })
      : _logCallback = logCallback,
        _controlSocket = socket,
        _commandParser = commandParser ?? const FtpCommandParser() {
    _listen = _controlSocket.listen(_onMessage, onDone: close);
  }

  void _onMessage(Uint8List messageList) {
    final decode = utf8.decode(messageList);
    final command = _commandParser.parse(decode);
    _logCallback?.call(
      '[${DateTime.now().toString()}] '
          '${_controlSocket.remoteAddress.address}:${_controlSocket
          .remoteAddress.address}< '
          '$decode',
    );
  }

  void write(FtpResponse response) {
    final responseString = '${response.code} ${response.message}';
    _controlSocket.write('$responseString\r\n');
    _logCallback?.call(
      '[${DateTime.now().toString()}] '
          '${_controlSocket.remoteAddress.address}:${_controlSocket
          .remoteAddress.address}> '
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
