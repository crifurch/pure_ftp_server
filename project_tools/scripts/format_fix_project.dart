import 'dart:io';

import 'package:pure_ftp_server/src/utils/extensions/file_dir_extension.dart';

import '../core/processes/dart_fix.dart';
import '../core/processes/dart_format.dart';

Future<void> main() async {
  var processResult = await runDartFormat([
    Directory.current.getFolder('lib'),
    Directory.current.getFolder('example'),
  ]);
  if (processResult.exitCode != 0) {
    throw Exception(processResult.stderr);
  }
  processResult = await runDartFix(
    Directory.current.getFolder('lib'),
  );
  if (processResult.exitCode != 0) {
    throw Exception(processResult.stderr);
  }

  processResult = await runDartFix(
    Directory.current.getFolder('example'),
  );
  if (processResult.exitCode != 0) {
    throw Exception(processResult.stderr);
  }
}
