import 'package:meta/meta.dart';

@immutable
class FtpResponse {
  final int code;
  final String message;

  const FtpResponse(this.code, {required this.message});

  const FtpResponse.error([this.message = 'Error']) : code = 550;

  const FtpResponse.success([this.message = 'Ok']) : code = 220;

  const FtpResponse.transferAccept([this.message = 'Accepted data connection'])
      : code = 150;

  const FtpResponse.transferComplete([this.message = 'Transfer complete'])
      : code = 226;
}
