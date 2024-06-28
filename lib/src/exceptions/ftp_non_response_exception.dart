import 'ftp_server_exception.dart';

class FtpNonResponseException extends FtpServerException {
  @override
  String toString() => 'Don\'t send response';
}
