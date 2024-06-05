//ignore_export
part of 'client_session.dart';

typedef OnTryAuthorize = FutureOr<ClientSession?> Function({
  required Socket socket,
  required Stream<Uint8List> inStream,
  String? username,
  String? password,
});

class ClientNonAuthorizedSession extends ClientSession {
  final OnTryAuthorize _onTryAuthorize;
  String? _cachedUserName;

  ClientNonAuthorizedSession({
    required super.socket,
    required super.inStream,
    required OnTryAuthorize tryAuthorize,
    super.logCallback,
    super.commandParser,
  }) : _onTryAuthorize = tryAuthorize;

  Future<ClientSession> login({
    String? username,
    String? password,
  }) async {
    final result = await _onTryAuthorize(
      socket: _controlSocket,
      inStream: _inStream,
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
