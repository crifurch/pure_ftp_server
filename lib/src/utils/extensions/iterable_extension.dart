import 'dart:async';

extension IterableFirstWhere<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }

  Future<T> firstWhereAsync(
      Future<bool> Function(T element) test, {
        FutureOr<T> Function()? orElse,
      }) async {
    for (final element in this) {
      if (await test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return await orElse();
    }
    throw StateError('No element');
  }
}

extension IterableElementAtOrNull on Iterable {
  T? elementAtOrNull<T>(int index) {
    if (index < 0 || index >= length) {
      return null;
    }
    return elementAt(index);
  }
}