part of 'in_mem_file_system.dart';

class InMemFile extends InMemEntity<Uint8List?> with FsFile {
  InMemFile({
    required super.path,
    required super.fileSystem,
    required super.data,
  });

  @override
  int get size => _data?.length ?? -1;

  @override
  void create() {
    // TODO: implement create
  }

  @override
  void delete() {
    // TODO: implement delete
  }

  @override
  Stream<Uint8List> read([int? start, int? end]) async* {
    if (_data == null) {
      throw const FileSystemException('file doesn\'t exists');
    }
    assert((start ?? 0) >= 0, 'incorrect file start $start');
    assert(
      (end ?? _data!.length) <= _data!.length,
      'incorrect file end $end but max is ${_data!.length}',
    );
    yield _data!;
  }

  @override
  IOSink write() {
    // TODO: implement delete
    return IOSink(_InMemFileConsumer([]));
  }
}

class _InMemFileConsumer implements StreamConsumer<List<int>> {
  List<int> data;

  _InMemFileConsumer(this.data);

  @override
  Future addStream(Stream<List<int>> stream) {
    final result = Completer<bool>();
    late StreamSubscription<List<int>> subscription;
    void error(e, StackTrace stackTrace) {
      subscription.cancel();
      result.complete(false);
    }

    subscription = stream.listen((d) {
      subscription.pause();
      try {
        data.addAll(d);
        subscription.resume();
      } catch (e, stackTrace) {
        error(e, stackTrace);
      }
    }, onDone: () {
      result.complete(true);
      subscription.cancel();
    }, onError: error, cancelOnError: true);
    return result.future;
  }

  @override
  Future close() async {}
}
