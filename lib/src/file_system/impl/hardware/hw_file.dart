import 'dart:io';

import '../../definition/fs_file.dart';

class HwFile with FSFile {
  final File _file;

  HwFile(this._file);

  @override
  bool exists() => _file.existsSync();

  @override
  int get size => _file.lengthSync();
}
