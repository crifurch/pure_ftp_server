import 'dart:io';

import 'package:pure_ftp_server/src/file_system/definition/fs_directory.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_file.dart';
import 'package:pure_ftp_server/src/file_system/impl/hardware/hw_file_system.dart';
import 'package:pure_ftp_server/src/file_system/impl/in_memory/in_mem_file_system.dart';

abstract class FileSystem {
  factory FileSystem.system(Directory workingDir) => HwFileSystem(workingDir);

  factory FileSystem.inMem({
    int? memoryLimit,
    Map<String, dynamic>? initialData,
  }) =>
      InMemFileSystem(initialData: initialData, memoryLimit: memoryLimit);

  FSFile getFile(String path);

  FSDirectory getDirectory(String path);
}
