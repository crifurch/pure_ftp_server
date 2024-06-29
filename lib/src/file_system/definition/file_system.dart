import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';
import 'package:pure_ftp_server/src/file_system/impl/hardware/hw_file_system.dart';
import 'package:pure_ftp_server/src/file_system/impl/in_memory/in_mem_file_system.dart';

abstract class FileSystem {
  UMask defaultUMask;

  FileSystem(this.defaultUMask);

  factory FileSystem.system(
    Directory workingDir, {
    UMask defaultUMask = UMask.u022,
  }) =>
      HwFileSystem(
        workingDir,
        defaultUMask: defaultUMask,
      );

  factory FileSystem.inMem({
    int? memoryLimit,
    Map<String, dynamic>? initialData,
    UMask defaultUMask = UMask.u022,
  }) =>
      InMemFileSystem(
        initialData: initialData,
        memoryLimit: memoryLimit,
        defaultUMask: defaultUMask,
      );

  FsFile getFile(String path);

  FsDirectory getDirectory(String path);

  FsEntity? getEntity(String path);

  void applyPermissions(String path);
}
