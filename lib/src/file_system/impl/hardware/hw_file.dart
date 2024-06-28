part of 'hw_entity.dart';

class HwFile extends HwEntity<File> with FsFile {
  HwFile(super._entity);

  @override
  int get size => _entity.lengthSync();

  @override
  void create() => _entity.createSync();

  @override
  void delete() => _entity.deleteSync(recursive: true);
}
