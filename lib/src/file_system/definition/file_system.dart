import 'package:pure_ftp_server/src/file_system/definition/fs_directory.dart';
import 'package:pure_ftp_server/src/file_system/definition/fs_file.dart';

abstract class FileSystem {
  FSFile getFile(String path);

  FSDirectory getDirectory(String path);
}
