//ignore_export
part of 'client_session.dart';

typedef OnUnAuthorize = FutureOr<ClientSession> Function(
    Socket socket, Stream<Uint8List> inStream);

class ClientAuthorizedSession extends ClientSession {
  final FileSystem _fileSystem;
  final FtpWorkMode workMode;
  final OnUnAuthorize _unAuthorize;
  TransferSocket? _dataSocket;
  TransferType fileTransferType;
  String _currentPath;

  ClientAuthorizedSession({
    required super.socket,
    required super.inStream,
    required this.workMode,
    required FileSystem fileSystem,
    required OnUnAuthorize unAuthorize,
    super.logCallback,
    super.commandParser,
    this.fileTransferType = TransferType.ascii,
    String initialPath = '/',
  })  : _fileSystem = fileSystem,
        _unAuthorize = unAuthorize,
        _currentPath = initialPath;

  Future<ClientSession> logout({
    String? username,
    String? password,
  }) async {
    final result = await _unAuthorize(_controlSocket, _inStream);
    await _quit();
    return result;
  }

  FileSystem get fileSystem => _fileSystem;

  void changePath(String path) {
    final relativePath = getRelativePath(path);
    final directory = _fileSystem.getDirectory(relativePath);
    if (!directory.exists) {
      throw Exception('dir is not exists');
    }
    _currentPath = relativePath;
  }

  String get currentPath => _currentPath;

  String getRelativePath(String incomePath) {
    final result = incomePath == '-a' ? '' : incomePath.urlEncoded;
    if (result.startsWith('/')) {
      return result;
    }

    if (result.isEmpty) {
      return currentPath;
    }
    final split = currentPath.split('/');
    final split2 = result.split('/');
    for (var i = 0; i < split2.length; i++) {
      if (split2[i] == '..' && split.length > 1) {
        split2.removeAt(0);
        split.removeAt(split.length - 1);
      } else {
        break;
      }
    }

    final join = [
      ...split,
      ...split2,
    ].join('/');
    return join.isEmpty ? '/' : join;
  }

  Future<void> closeDataSocket() async {
    final futureOr = _dataSocket?.close();
    _dataSocket = null;
    return futureOr;
  }

  set dataSocket(TransferSocket? value) {
    closeDataSocket();
    _dataSocket = value;
  }

  TransferSocket? get dataSocket => _dataSocket;

  @override
  Future<void> _quit() async {
    await closeDataSocket();
    await _listen.cancel();
  }
}
