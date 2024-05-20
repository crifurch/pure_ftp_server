import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/ftp/command/parser.dart';
import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/utils/typedefs.dart';

class FtpSession {
  final LogCallback? _logCallback;
  final Socket _controlSocket;
  final FtpCommandParser _commandParser;

  FtpSession({
    required Socket socket,
    LogCallback? logCallback,
    FtpCommandParser? commandParser,
  })  : _logCallback = logCallback,
        _controlSocket = socket,
        _commandParser = commandParser ?? const FtpCommandParser() {
    _controlSocket.listen(_onMessage, onDone: quit);
    write(const FtpResponse(220, message: 'hello'));
  }

  void _onMessage(Uint8List messageList) {
    final decode = utf8.decode(messageList);
    final command = _commandParser.parse(decode);
    _logCallback?.call(
      '[${DateTime.now().toString()}] '
      '${_controlSocket.remoteAddress.address}:${_controlSocket.remoteAddress.address}< '
      '$decode',
    );
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

  Future<void> quit() async {
    await _controlSocket.close();
    _logCallback?.call('Connection closed');
  }
}
