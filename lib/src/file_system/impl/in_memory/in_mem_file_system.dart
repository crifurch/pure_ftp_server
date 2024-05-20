//ignore_export
import 'dart:typed_data';

import 'package:pure_ftp_server/src/file_system/definition/file_system.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_directory.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_file.dart';

part 'in_mem_file.dart';

part 'in_mem_directory.dart';

class InMemFileSystem implements FileSystem {
  final Map<String, dynamic> _workMap;
  final int? memoryLimit;

  InMemFileSystem({
    this.memoryLimit,
    Map<String, dynamic>? initialData,
  }) : _workMap = initialData ?? {};

  @override
  FSDirectory getDirectory(String path) {
    // TODO: implement getDirectory
    throw UnimplementedError();
  }

  @override
  FSFile getFile(String path) {
    // TODO: implement getFile
    throw UnimplementedError();
  }
}
