import 'ftp_server_exception.dart';

class FtpConnectionClosedException extends FtpServerException {
  @override
  String toString() => 'Connection closed';
}
