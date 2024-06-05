import 'dart:io';

Future<ProcessResult> runPublish() {
  return Process.run('dart', [
    'pub',
    'publish',
    '-y',
  ]);
}
