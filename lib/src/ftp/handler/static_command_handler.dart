part of 'root_command_handler.dart';

class StaticCommandHandler extends FtpCommandHandler {
  static StaticCommandHandler? _instance;

  bool isInit = false;
  late RootCommandHandler _authorizedHandler;
  late RootCommandHandler _unHandler;
  late RootCommandHandler _readOnlyHandler;
  late RootCommandHandler _lookOnlyHandler;
  final UnknownHandler _unknownHandler = UnknownHandler();

  StaticCommandHandler._() {
    _init();
  }

  factory StaticCommandHandler() =>
      _instance ?? (_instance = StaticCommandHandler._());

  void _init() {
    _unHandler = RootCommandHandler(
        handlers: _auth, defaultHandler: NonAuthorizedHandler());
    //todo remake after implements more
    _authorizedHandler = RootCommandHandler(
        handlers: [], defaultHandler: NonAuthorizedHandler());
    _readOnlyHandler = RootCommandHandler(
        handlers: [], defaultHandler: NonAuthorizedHandler());
    _lookOnlyHandler = RootCommandHandler(
        handlers: [], defaultHandler: NonAuthorizedHandler());
  }

  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) {
    if (options.command.command == FtpCommands.UNKNOWN) {
      return _unknownHandler.handle(options);
    }
    if (options.session is FtpNonAuthorizedSession) {
      return _unHandler.handle(options);
    }
    RootCommandHandler handler;
    switch ((options.session as FtpAuthorizedSession).workMode) {
      case FtpWorkMode.readWrite:
        handler = _authorizedHandler;
        break;
      case FtpWorkMode.read:
        handler = _readOnlyHandler;
        break;
      case FtpWorkMode.look:
        handler = _lookOnlyHandler;
        break;
    }
    return handler.handle(options);
  }

  @override
  List<FtpCommands> get supportedCommands => [];

  List<FtpCommandHandler> get _auth => [
        AuthHandler(),
        UserHandler(),
        PassHandler(),
      ];
}
