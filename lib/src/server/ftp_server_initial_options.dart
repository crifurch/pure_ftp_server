// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:math';

import 'package:meta/meta.dart';
import 'package:pure_ftp_server/src/server/ftp_user.dart';

@immutable
class FtpServerInitialOptions {
  final List<FtpUser> users;
  final InternetAddress? host;
  final int port;
  final PassivePortsRange passivePortsRange;
  final Duration? keepAliveTimeout;
  final SecurityType secureType;
  final String welcomeMessage;

  const FtpServerInitialOptions(
      {required this.users,
      this.host,
      this.port = 21,
      this.passivePortsRange = const PassivePortsRange(min: 10000, max: 20000),
      this.keepAliveTimeout,
      this.secureType = SecurityType.FTP,
      this.welcomeMessage = 'Welcome to dart Pure FTP Server'})
      : assert(users.length != 0, 'You must provide as least one user');
}

@immutable
class PassivePortsRange {
  final int min;
  final int max;

  const PassivePortsRange({
    required this.min,
    required this.max,
  }) : assert(min < max, 'min port should be lower than max port');

  int get randomPort =>
      Random(
        DateTime.now().millisecondsSinceEpoch,
      ).nextInt(max) +
      min;
}

enum SecurityType {
  FTP,
  FTPS,
  ;

  bool get isSecure => this != SecurityType.FTP;
}
