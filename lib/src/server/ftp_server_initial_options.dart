// ignore_for_file: constant_identifier_names

import 'dart:io';

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
      this.passivePortsRange = const PassivePortsRange(min: 55000, max: 65000),
      this.keepAliveTimeout,
      this.secureType = SecurityType.FTP,
      this.welcomeMessage = 'Welcome to dart Pure FTP Server'})
      : assert(users.length != 0, 'You must provide as least one user');
}

class PassPortsService {
  static final instance = PassPortsService._();

  final List<int> _ports = [];

  PassPortsService._();

  int allocatePort(int min, int max) {
    var free = min;
    for (final values in _ports) {
      if (free == values) {
        free++;
        if (free >= max) {
          throw Exception('Can not allocate port');
        }
        continue;
      }
      break;
    }
    return free;
  }

  void removePort(int port) => _ports.remove(port);
}

@immutable
class PassivePortsRange {
  final int min;
  final int max;

  const PassivePortsRange({
    required this.min,
    required this.max,
  }) : assert(min < max, 'min port should be lower than max port');

  int get freePort => PassPortsService.instance.allocatePort(min, max);
}

enum SecurityType {
  FTP,
  FTPS,
  ;

  bool get isSecure => this != SecurityType.FTP;
}
