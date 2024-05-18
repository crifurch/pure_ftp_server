import 'dart:io';

import 'package:pure_ftp_server/src/utils/typedefs.dart';

import 'ftp_server_initial_options.dart';

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
        'FTP Server is running on ${_server!.address.host}:${_server!.address.host}');
    await for (var client in _server!) {
      _logCallback?.call(
          'New client connected from ${client.remoteAddress.address}:${client.remotePort}');
    }
  }

  Future<void> stop() async {
    await _server?.close();
    _server = null;
    _logCallback?.call('FTP Server stopped');
  }
}
