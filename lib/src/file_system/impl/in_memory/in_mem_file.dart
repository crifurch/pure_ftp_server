//ignore_export
part of 'in_mem_file_system.dart';

class InMemFile with FSFile {
  final InMemFileSystem _fileSystem;
  final Uint8List? _data;
  final String path;

  InMemFile({
    required InMemFileSystem fileSystem,
    required this.path,
    Uint8List? data,
  })  : _data = data,
        _fileSystem = fileSystem;

  @override
  bool exists() => _data != null;

  @override
  int get size => _data?.length ?? -1;
}
