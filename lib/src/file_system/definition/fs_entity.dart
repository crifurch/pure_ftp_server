abstract class FsEntity {
  bool get exists;

  String get name;

  DateTime get lastModified;

  int get size;

  int get permissions;

  String get permissionsString;

  void create();

  static String permissionsToString(int permissionCode) {
    const codes = ['---', '--x', '-w-', '-wx', 'r--', 'r-x', 'rw-', 'rwx'];
    final permissions = permissionCode & 0xFFF;
    final result = [
      codes[(permissions >> 6) & 0x7],
      codes[(permissions >> 3) & 0x7],
      codes[permissions & 0x7],
    ];
    return result.join();
  }
}
