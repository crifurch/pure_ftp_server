part of 'in_mem_file_system.dart';

class InMemDirectory with FSDirectory {
  final InMemFileSystem _fileSystem;
  final Map<String, dynamic>? _workMap;
  final String path;

  InMemDirectory({
    required this.path,
    required InMemFileSystem fileSystem,
    Map<String, dynamic>? workMap,
  })  : _workMap = workMap,
        _fileSystem = fileSystem;

  @override
  bool exists() => _workMap != null;
}
