import 'ftp_server_exception.dart';

class FtpAccessDeniedException extends FtpServerException {
  @override
  String toString() => 'Access denied';
}
