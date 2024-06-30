import 'dart:async';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/utils/closable_container.dart';

abstract class TransferSocket implements ClosableContainer {
  void write(List<int> data);

  StreamSubscription<Uint8List> listen({
    void Function(Uint8List event)? onData,
    void Function()? onDone,
  });

  Stream<Uint8List> listenStream();

  Future<void> connect({Duration? timeout});

  bool get isConnected;
}
