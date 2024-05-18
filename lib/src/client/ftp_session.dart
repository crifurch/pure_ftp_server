import 'dart:io';

import 'package:pure_ftp_server/src/ftp/response/ftp_response.dart';
import 'package:pure_ftp_server/src/server/ftp_user.dart';
import 'package:pure_ftp_server/src/utils/typedefs.dart';

class FtpSession {
  final LogCallback? _logCallback;
  FtpUser? user;
  final Socket _controlSocket;

  FtpSession({
    required Socket socket,
    LogCallback? logCallback,
  })  : _logCallback = logCallback,
        _controlSocket = socket {
    _controlSocket.listen((event) {}, onDone: quit);
    write(const FtpResponse(220, message: 'hello'));
  }

  void write(FtpResponse response) {
    _controlSocket.write('${response.code} ${response.message}\r\n');
  }

  Future<void> quit() async {
    await _controlSocket.close();
    _logCallback?.call('Connection closed');
  }
}
