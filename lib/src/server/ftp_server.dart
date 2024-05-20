import 'dart:io';

import 'package:pure_ftp_server/src/client/ftp_session.dart';
import 'package:pure_ftp_server/src/utils/extensions/iterable_extension.dart';
import 'package:pure_ftp_server/src/utils/typedefs.dart';

import '../ftp/export.dart';
import 'ftp_server_initial_options.dart';
import 'ftp_user.dart';

class FtpServer {
  ServerSocket? _server;
  final FtpServerInitialOptions _initialOptions;
  final LogCallback? _logCallback;

  FtpServer({
    required FtpServerInitialOptions initialOptions,
    LogCallback? logCallback,
  })  : _initialOptions = initialOptions,
        _logCallback = logCallback;

  Future<void> start() async {
    if (_server != null) {
      throw Exception('server is already started');
    }
    _server = await ServerSocket.bind(
      _initialOptions.host ?? InternetAddress.loopbackIPv4,
      _initialOptions.port,
    );
    _logCallback?.call(
        'FTP Server is running on ${_server!.address.host}:${_server!.port}');
    await for (var client in _server!) {
      _logCallback?.call(
          'New client connected from ${client.remoteAddress.address}:${client.remotePort}');
      final ftpSession = _continueNonAuthorized(client);
      ftpSession.write(
        FtpResponse(220, message: _initialOptions.welcomeMessage),
      );
    }
  }

  FtpSession _continueAuthorized(Socket socket, FtpUser user) {
    return FtpAuthorizedSession(
      socket: socket,
      logCallback: _logCallback,
      fileSystem: user.fileSystem,
      unAuthorize: _continueNonAuthorized,
    );
  }

  FtpSession _continueNonAuthorized(Socket socket) {
    return FtpNonAuthorizedSession(
      socket: socket,
      logCallback: _logCallback,
      tryAuthorize: ({required socket, password, username}) {
        final user = _initialOptions.users
            .firstWhereOrNull((element) => element.username == username);
        if (user == null || user.password != password) {
          return null;
        }
        return _continueAuthorized(socket, user);
      },
    );
  }

  Future<void> stop() async {
    await _server?.close();
    _server = null;
    _logCallback?.call('FTP Server stopped');
  }
}
