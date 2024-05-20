import '../core/processes/pub_publish.dart';
import 'build_export.dart' as build_export;
import 'format_fix_project.dart' as format_project;

Future<void> main() async {
  build_export.main();
  await format_project.main();
  final processResult = await runPublish();
  if (processResult.exitCode != 0) {
    throw Exception(processResult.stderr);
  }
}
