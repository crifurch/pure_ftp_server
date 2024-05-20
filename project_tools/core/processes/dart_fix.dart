import 'dart:io';

import 'package:pure_ftp_server/src/utils/extensions/file_dir_extension.dart';

Future<ProcessResult> runDartFix(FileSystemEntity entity) {
  final current = Directory.current;
  assert(entity is File || entity is Directory);
  final subPath = entity.getSubPath(current);
  return Process.run('dart', [
    'fix',
    subPath,
    '--apply',
  ]);
}
