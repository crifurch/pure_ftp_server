import 'fs_entity.dart';

mixin FsDirectory implements FsEntity {
  List<FsEntity> list({bool recursive = false});

  @override
  String get permissionsString =>
      'd${FsEntity.permissionsToString(permissions)}';
}
