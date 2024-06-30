import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'fs_entity.dart';

mixin FsFile implements FsEntity {
  @override
  String get permissionsString =>
      '-${FsEntity.permissionsToString(permissions)}';

  Stream<Uint8List> read([int? start, int? end]);

  IOSink write();
}
