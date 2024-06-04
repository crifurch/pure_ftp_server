part of 'in_mem_file_system.dart';

class InMemDirectory extends InMemEntity<Map<String, dynamic>?> with FsDirectory {
  InMemDirectory({
    required super.path,
    required super.fileSystem,
    required super.data,
  });

  void _fireExceptionNonExists() {
    if (!exists) {
      throw Exception('$path doesn\'t exists');
    }
  }

  @override
  List<FsEntity> list({bool recursive = false}) {
    _fireExceptionNonExists();
    final result = <FsEntity>[];
    for (final entity in _data!.entries) {
      if (entity.value is Map<String, dynamic>) {
        final dir = InMemDirectory(
            path: '$path/${entity.key}',
            fileSystem: _fileSystem,
            data: entity.value);
        result.add(dir);
        if (recursive) {
          result.addAll(dir.list(recursive: recursive));
        }
      } else if (entity.value is Uint8List) {
        result.add(InMemFile(
          fileSystem: _fileSystem,
          path: '$path/${entity.key}',
          data: entity.value,
        ));
      }
    }
    return result;
  }

  @override
  int get size => 0;

}
