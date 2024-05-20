import 'dart:io';

import '../../definition/fs_directory.dart';

class HwDirectory with FSDirectory {
  final Directory _directory;

  HwDirectory(this._directory);

  @override
  bool exists() => _directory.existsSync();
}
