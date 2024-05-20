part of 'ftp_session.dart';

typedef OnTryAuthorize = FutureOr<FtpSession?> Function({
  required Socket socket,
  String? username,
  String? password,
});

class FtpNonAuthorizedSession extends FtpSession {
  final OnTryAuthorize _onTryAuthorize;
  String? _cachedUserName;

  FtpNonAuthorizedSession({
    required super.socket,
    required OnTryAuthorize tryAuthorize,
    super.logCallback,
    super.commandParser,
  }) : _onTryAuthorize = tryAuthorize;

  Future<FtpSession> login({
    String? username,
    String? password,
  }) async {
    final result = await _onTryAuthorize(
      socket: _controlSocket,
      username: username ?? _cachedUserName,
      password: password,
    );
    if (result == null) {
      if (username != null) {
        _cachedUserName = username;
      }
      return this;
    } else {
      await _quit();
      return result;
    }
  }
}
