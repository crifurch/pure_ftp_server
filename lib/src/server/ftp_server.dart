import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/client/client_session.dart';
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
      final ftpSession =
          _continueNonAuthorized(client, client.asBroadcastStream());
      ftpSession.write(FtpResponse.success(_initialOptions.welcomeMessage));
    }
  }

  ClientSession _continueAuthorized(
      Socket socket, Stream<Uint8List> inStream, FtpUser user) {
    return ClientAuthorizedSession(
      socket: socket,
      inStream: inStream,
      logCallback: _logCallback,
      fileSystem: user.fileSystem,
      workMode: user.workMode,
      unAuthorize: _continueNonAuthorized,
      passivePortsRange: _initialOptions.passivePortsRange,
    );
  }

  ClientSession _continueNonAuthorized(
      Socket socket, Stream<Uint8List> inStream) {
    return ClientNonAuthorizedSession(
      socket: socket,
      inStream: inStream,
      logCallback: _logCallback,
      tryAuthorize: ({
        required inStream,
        required socket,
        password,
        username,
      }) async {
        final user = _initialOptions.users
            .firstWhereOrNull((element) => element.username == username);
        if (user == null || user.password != password) {
          return null;
        }
        return _continueAuthorized(socket, inStream, user);
      },
    );
  }

  Future<void> stop() async {
    await _server?.close();
    _server = null;
    _logCallback?.call('FTP Server stopped');
  }
}
