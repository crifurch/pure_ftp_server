//ignore_export
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
      handlers: _auth,
      defaultHandler: NonAuthorizedHandler(),
    );
    _authorizedHandler = RootCommandHandler(
      handlers: [
        ..._fsWrite,
        ..._fsLookOnly,
        ..._fsReadOnly,
      ],
      defaultHandler: _unknownHandler,
    );
    _readOnlyHandler = RootCommandHandler(
      handlers: [
        ..._fsLookOnly,
        ..._fsReadOnly,
      ],
      defaultHandler: _unknownHandler,
    );
    _lookOnlyHandler = RootCommandHandler(
      handlers: _fsLookOnly,
      defaultHandler: _unknownHandler,
    );
  }

  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) {
    if (options.command.command == FtpCommands.UNKNOWN) {
      return _unknownHandler.handle(options);
    }
    if (options.session is ClientNonAuthorizedSession) {
      return _unHandler.handle(options);
    }
    RootCommandHandler handler;
    switch ((options.session as ClientAuthorizedSession).workMode) {
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
  List<FtpCommands> get supportedCommands => const [];

  List<FtpCommandHandler> get _auth => [
        AuthHandler(),
        UserHandler(),
        PassHandler(),
      ];

  List<FtpCommandHandler> get _fsLookOnly => [
        PwdHandler(),
        PortHandler(),
        ListHandler(),
        CdHandler(),
        CdUpHandler(),
      ];

  List<FtpCommandHandler> get _fsReadOnly => [
        TypeHandler(),
      ];

  List<FtpCommandHandler> get _fsWrite => [
        MkdHandler(),
        DeleHandler(),
      ];
}
