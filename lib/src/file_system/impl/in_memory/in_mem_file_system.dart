import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/src/file_system/definition/file_system.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_directory.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_entity.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_file.dart';
import 'package:pure_ftp_server/src/file_system/types/u_mask.dart';
import 'package:pure_ftp_server/src/utils/extensions/string_extension.dart';

part 'in_mem_directory.dart';
part 'in_mem_entity.dart';
part 'in_mem_file.dart';

class InMemFileSystem implements FileSystem {
  static const int _maxInteger = 0x7FFFFFFFFFFFFFFF;
  final Map<String, dynamic> _workMap;
  final int? memoryLimit;
  int _usedMemory = 0;
  @override
  UMask defaultUMask;

  InMemFileSystem({
    required this.defaultUMask,
    this.memoryLimit,
    Map<String, dynamic>? initialData,
  }) : _workMap = initialData ?? {} {
    _recalculateMemory();
  }

  int get availableSpace => (memoryLimit ?? _maxInteger) - _usedMemory;

  dynamic _scanForData(String path) {
    final urlPath = path.urlEncoded;
    final pathEncoded = urlPath.substring(
      urlPath.startsWith('/') ? 1 : 0,
    );
    var split = pathEncoded.split('/');
    dynamic workMap = _workMap;
    if (split.isEmpty || (split.length == 1 && split.first.isEmpty)) {
      return workMap;
    }
    if (split.isNotEmpty && split.first.isEmpty) {
      split = split.skip(1).toList();
    }

    try {
      for (final path in split) {
        workMap = workMap?[path];
        if (workMap == null) {
          break;
        }
      }
      return workMap;
    } on Exception {
      return null;
    }
  }

  @override
  FsEntity? getEntity(String path) {
    final urlPath = path.urlEncoded;
    final data = _scanForData(urlPath);
    if (data is Map<String, dynamic>) {
      return InMemDirectory(
        path: urlPath,
        fileSystem: this,
        data: data,
      );
    }
    if (data is Uint8List) {
      return InMemFile(
        path: urlPath,
        fileSystem: this,
        data: data,
      );
    }
    return null;
  }

  @override
  FsDirectory getDirectory(String path) {
    final urlPath = path.urlEncoded;
    final data = _scanForData(urlPath);
    return InMemDirectory(
      path: urlPath,
      fileSystem: this,
      data: (data is Map) ? data.cast() : null,
    );
  }

  @override
  FsFile getFile(String path) {
    final urlPath = path.urlEncoded;
    final data = _scanForData(urlPath);
    return InMemFile(
      path: urlPath,
      fileSystem: this,
      data: data is Uint8List ? data : null,
    );
  }

  void _recalculateMemory() {
    _usedMemory = _calculateDir(_workMap);
  }

  int _calculateDir(Map<String, dynamic> dir) {
    int memory = 0;
    for (final value in dir.values) {
      if (value is Map<String, dynamic>) {
        memory += _calculateDir(value);
      } else if (value is Uint8List) {
        memory += value.length;
      }
    }
    return memory;
  }

  @override
  void applyPermissions(String path) =>
      getEntity(path)?.applyPermissions(defaultUMask);
}
