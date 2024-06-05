import 'package:meta/meta.dart';
import 'package:pure_ftp_server/src/file_system/definition/file_system.dart';

import '../ftp/ftp_work_mode.dart';

@immutable
class FtpUser {
  final String username;
  final String? password;
  final FileSystem fileSystem;
  final FtpWorkMode workMode;

  const FtpUser({
    required this.username,
    required this.fileSystem,
    this.password,
    this.workMode = FtpWorkMode.readWrite,
  });
}
