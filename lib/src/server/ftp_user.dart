import 'package:meta/meta.dart';
import 'package:pure_ftp_server/src/file_system/definition/file_system.dart';

@immutable
class FtpUser {
  final String username;
  final String? password;
  final FileSystem fileSystem;

  const FtpUser({
    required this.username,
    required this.fileSystem,
    this.password,
  });
}
