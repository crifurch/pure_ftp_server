import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/pure_ftp_server.dart';
import 'package:pure_ftp_server/src/exceptions/ftp_access_denied_exception.dart';
import 'package:pure_ftp_server/src/file_system/types/u_mask.dart';
import 'package:pure_ftp_server/src/utils/extensions/file_dir_extension.dart';

part 'hw_directory.dart';
part 'hw_file.dart';

abstract class HwEntity<T extends FileSystemEntity> implements FsEntity {
  final T _entity;

  HwEntity(this._entity);

  @override
  bool get exists => _entity.existsSync();

  @override
  String get name => _entity.name;

  @override
  int get size => _entity.statSync().size;

  @override
  DateTime get lastModified => _entity.statSync().modified;

  @override
  int get permissions => _entity.statSync().mode;

  @override
  void applyPermissions(UMask uMask) {
    int permissions;
    if (_entity is File) {
      permissions = uMask.filePermissions;
    } else if (_entity is Directory) {
      permissions = uMask.dirPermissions;
    } else {
      throw FtpAccessDeniedException();
    }
    try {
      if (!Platform.isWindows) {
        Process.runSync('chmod', [permissions.toString(), _entity.path]);
      }
    } on Exception {
      throw FtpAccessDeniedException();
    }
  }
}
