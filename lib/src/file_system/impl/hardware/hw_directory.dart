part of 'hw_entity.dart';

class HwDirectory extends HwEntity<Directory> with FsDirectory {
  HwDirectory(super._entity);

  @override
  List<FsEntity> list({bool recursive = false}) {
    final entries = _entity.listSync(recursive: recursive);
    final result = <FsEntity>[];
    //todo: remake with dart 3
    for (final entity in entries) {
      if (entity is File) {
        result.add(HwFile(entity));
      } else if (entity is Directory) {
        result.add(HwDirectory(entity));
      }
    }
    return result;
  }

  @override
  void create() => _entity.createSync();

  @override
  void delete() => _entity.deleteSync(recursive: true);
}
