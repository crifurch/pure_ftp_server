import 'dart:io';

import 'package:pure_ftp_server/src/utils/extensions/file_dir_extension.dart';

Future<ProcessResult> runDartFormat(List<FileSystemEntity> entities) {
  assert(entities.isNotEmpty);
  final current = Directory.current;
  final filesToFormat = <String>[];
  for (final entity in entities) {
    assert(entity is File || entity is Directory);
    final subPath = entity.getSubPath(current);
    filesToFormat.add(subPath);
  }

  return Process.run('dart', [
    'format',
    '--fix',
    ...filesToFormat,
  ]);
}
