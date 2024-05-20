import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';
import 'package:pure_ftp_server/src/file_system/impl/hardware/hw_directory.dart';
import 'package:pure_ftp_server/src/file_system/impl/hardware/hw_file.dart';
import 'package:pure_ftp_server/src/utils/extensions/file_dir_extension.dart';
import 'package:pure_ftp_server/src/utils/extensions/string_extension.dart';

class HwFileSystem implements FileSystem {
  final Directory _workingDir;

  HwFileSystem(this._workingDir);

  @override
  FSDirectory getDirectory(String path) {
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
  FSFile getFile(String path) {
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
