import 'fs_entity.dart';

mixin FsFile implements FsEntity {
  @override
  String get permissionsString =>
      '-${FsEntity.permissionsToString(permissions)}';
}
