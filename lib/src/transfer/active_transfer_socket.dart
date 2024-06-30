import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/transfer/transfer_socket.dart';

class ActiveTransferSocket extends TransferSocket {
  Socket? _socket;
  final String _host;
  final int _port;

  ActiveTransferSocket(String host, int port)
      : _host = host,
        _port = port;

  @override
  bool get isConnected => _socket != null;

  @override
  Future<void> connect({Duration? timeout}) => Socket.connect(
        _host,
        _port,
        timeout: timeout,
      ).then((value) => _socket = value);

  @override
  FutureOr<void> close() {
    _socket?.close();
  }

  @override
  StreamSubscription<Uint8List> listen({
    void Function(Uint8List event)? onData,
    void Function()? onDone,
  }) =>
      _socket!.listen(
        onData,
        onDone: onDone,
      );

  @override
  Stream<Uint8List> listenStream() => _socket!;

  @override
  void write(List<int> data) => _socket!.add(data);
}
