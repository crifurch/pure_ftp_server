part of 'in_mem_file_system.dart';

abstract class InMemEntity<T> implements FsEntity {
  final String path;
  final InMemFileSystem _fileSystem;
  final T _data;

  InMemEntity({
    required this.path,
    required T data,
    required InMemFileSystem fileSystem,
  })  : _data = data,
        _fileSystem = fileSystem;

  @override
  bool get exists => _data != null;

  @override
  String get name => path.split('/').last;

  @override
  DateTime get lastModified => DateTime.now();

  @override
  int get permissions => 0x0777;

  @override
  void applyPermissions(UMask uMask) {
    //todo: mind about that if need implements? if not set to empty
  }
}
