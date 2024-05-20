import 'package:meta/meta.dart';

@immutable
class FtpResponse {
  final int code;
  final String message;

  const FtpResponse(this.code, {required this.message});

  const FtpResponse.error(this.message) : code = 550;

  const FtpResponse.success(this.message) : code = 220;
}
