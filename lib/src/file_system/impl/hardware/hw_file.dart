part of 'hw_entity.dart';

class HwFile extends HwEntity<File> with FsFile {
  HwFile(super._entity);

  @override
  int get size => _entity.lengthSync();

  @override
  void create() => _entity.createSync();

  @override
  void delete() => _entity.deleteSync(recursive: true);

  @override
  Stream<Uint8List> read([int? start, int? end]) async* {
    await for (var i in _entity.openRead(start, end)) {
      yield Uint8List.fromList(i);
    }
  }

  @override
  IOSink write() => _entity.openWrite();
}
