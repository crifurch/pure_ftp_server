import 'dart:io';

import 'package:meta/meta.dart';

@immutable
class FtpUser {
  final String username;
  final String? password;
  final Directory workingDir;

  const FtpUser({
    required this.username,
    required this.workingDir,
    this.password,
  });
}
