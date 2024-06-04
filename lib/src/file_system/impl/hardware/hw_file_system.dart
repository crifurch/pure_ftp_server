import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';
import 'package:pure_ftp_server/src/file_system/impl/hardware/hw_entity.dart';
import 'package:pure_ftp_server/src/utils/extensions/file_dir_extension.dart';
import 'package:pure_ftp_server/src/utils/extensions/string_extension.dart';

class HwFileSystem implements FileSystem {
  final Directory _workingDir;

  HwFileSystem(this._workingDir);

  @override
  FsEntity? getEntity(String path) {
    final urlPath = path.urlEncoded;
    final pathEncoded = urlPath
        .substring(
          urlPath.startsWith('/') ? 1 : 0,
        )
        .pathEncoded;
    final entityType = _workingDir.getEntityType(
      pathEncoded,
    );
    switch (entityType) {
      case FileSystemEntityType.directory:
        return HwDirectory(_workingDir.getFolder(pathEncoded));
      case FileSystemEntityType.file:
        return HwFile(_workingDir.getFile(pathEncoded));
      default:
        return null;
    }
  }

  @override
  FsDirectory getDirectory(String path) {
    final urlPath = path.urlEncoded;
    return HwDirectory(_workingDir.getFolder(
      urlPath
          .substring(
            urlPath.startsWith('/') ? 1 : 0,
          )
          .pathEncoded,
    ));
  }

  @override
  FsFile getFile(String path) {
    final urlPath = path.urlEncoded;
    return HwFile(_workingDir.getFile(
      urlPath
          .substring(
            urlPath.startsWith('/') ? 1 : 0,
          )
          .pathEncoded,
    ));
  }
}
