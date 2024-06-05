import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';
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
}
