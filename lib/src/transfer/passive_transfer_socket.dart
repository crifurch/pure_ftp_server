import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/transfer/transfer_socket.dart';

class PassiveTransferSocket extends TransferSocket {
  ServerSocket? _serverSocket;
  Socket? _socket;
  final String _host;
  final int _port;

  PassiveTransferSocket(String host, int port)
      : _host = host,
        _port = port;

  @override
  Future<void> connect({Duration? timeout}) async {
    _serverSocket = await ServerSocket.bind(_host, _port);
  }

  Future<void> waitClient({Duration? timeout}) {
    var result = _serverSocket!.first;
    if (timeout != null) {
      result = result.timeout(timeout);
    }
    return result.then((value) => _socket = value);
  }

  @override
  FutureOr<void> close() {
    _socket?.close();
    _serverSocket?.close();
  }

  @override
  StreamSubscription<Uint8List> listen([
    void Function(Uint8List event)? onData,
  ]) =>
      _socket!.listen(onData);

  @override
  void write(String data) => _socket!.write(data);
}
