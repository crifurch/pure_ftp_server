part of 'in_mem_file_system.dart';

class InMemFile extends InMemEntity<Uint8List?> with FsFile {
  InMemFile({
    required super.path,
    required super.fileSystem,
    required super.data,
  });

  @override
  int get size => _data?.length ?? -1;
}
