import '../command/parsed_ftp_command.dart';
import '../response/ftp_response.dart';

abstract class FtpCommandHandler {
  Future<FtpResponse> handle(ParsedFtpCommand command);
}
