part of 'ftp_session.dart';

typedef OnUnAuthorize = FutureOr<FtpSession> Function(Socket socket);

class FtpAuthorizedSession extends FtpSession {
  final FileSystem _fileSystem;
  final OnUnAuthorize _unAuthorize;

  FtpAuthorizedSession({
    required super.socket,
    required FileSystem fileSystem,
    required OnUnAuthorize unAuthorize,
    super.logCallback,
    super.commandParser,
  })  : _fileSystem = fileSystem,
        _unAuthorize = unAuthorize;

  Future<FtpSession> logout({
    String? username,
    String? password,
  }) async {
    final result = await _unAuthorize(_controlSocket);
    await _quit();
    return result;
  }
}
