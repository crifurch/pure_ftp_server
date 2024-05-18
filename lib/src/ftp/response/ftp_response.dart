import 'package:meta/meta.dart';

@immutable
class FtpResponse {
  final int code;
  final String message;

  const FtpResponse(this.code, {required this.message});
}
