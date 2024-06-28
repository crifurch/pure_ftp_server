part of 'in_mem_file_system.dart';

class InMemFile extends InMemEntity<Uint8List?> with FsFile {
  InMemFile({
    required super.path,
    required super.fileSystem,
    required super.data,
  });

  @override
  int get size => _data?.length ?? -1;

  @override
  void create() {
    // TODO: implement create
  }

  @override
  void delete() {
    // TODO: implement delete
  }

  @override
  Stream<Uint8List> read([int? start, int? end]) async* {
    if (_data == null) {
      throw const FileSystemException('file doesn\'t exists');
    }
    assert((start ?? 0) >= 0, 'incorrect file start $start');
    assert(
      (end ?? _data!.length) <= _data!.length,
      'incorrect file end $end but max is ${_data!.length}',
    );
    yield _data!;
  }
}
