import 'dart:io';

extension NullIfEmpty on String {
  String? get nullIfEmpty => isNotEmpty ? this : null;
}

extension PathFormatExtension on String {
  String get urlEncoded => replaceAll(Platform.pathSeparator, '/');

  String get pathEncoded => replaceAll('/', Platform.pathSeparator)
      .replaceAll(r'\', Platform.pathSeparator);
}

extension SttrinFormatExtension on String {
  List<String> splitInPos(int pos) {
    assert(pos > 0, 'pos must be greater than 0');
    assert(pos < length, 'pos must be less than length');
    return [substring(0, pos), substring(pos)];
  }

  String get capitalize =>
      length < 2 ? toUpperCase() : '${this[0].toUpperCase()}${substring(1)}';

  String get uncapitalize =>
      length < 2 ? toLowerCase() : '${this[0].toLowerCase()}${substring(1)}';

  String get camelCase => splitMapJoin(
        RegExp(r'([\s|_].)'),
        onMatch: (m) => '${m[1]?[1]}'.toUpperCase(),
      ).uncapitalize;

  String get pascalCase => camelCase.capitalize;

  String get snakeCase => uncapitalize
      .splitMapJoin(RegExp(r'([A-Z|\s])'), onMatch: (m) => '_${m[1]}'.trim())
      .toLowerCase();
}
