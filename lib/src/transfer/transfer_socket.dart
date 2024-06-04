import 'dart:async';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/utils/closable_container.dart';

abstract class TransferSocket implements ClosableContainer {
  void write(String data);

  StreamSubscription<Uint8List> listen();

  Future<void> connect({Duration? timeout});
}
