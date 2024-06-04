import 'dart:async';

abstract class ClosableContainer<T> {

  FutureOr<void> close();
}
