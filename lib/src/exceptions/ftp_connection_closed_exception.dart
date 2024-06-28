import 'package:pure_ftp_server/src/exceptions/ftp_non_response_exception.dart';

class FtpConnectionClosedException extends FtpNonResponseException {
  @override
  String toString() => 'Connection closed';
}
