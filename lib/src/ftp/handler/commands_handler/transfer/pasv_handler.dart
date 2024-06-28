import 'dart:async';
import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';
import 'package:pure_ftp_server/src/exceptions/ftp_non_response_exception.dart';

class PasvHandler extends FtpCommandHandler {
  @override
  Future<FtpResponse> handle(CommandHandlerOptions options) async {
    final session = options.session as ClientAuthorizedSession;
    final port = session.passivePortsRange.freePort;
    final p1 = port >> 8;
    final p2 = port & 0xFF;
    final transferSocket = PassiveTransferSocket(
      InternetAddress.anyIPv4.host,
      port,
    );

    session.dataSocket = transferSocket;
    final address = (await _getIpAddress()).replaceAll('.', ',');
    session.write(
      FtpResponse(227, message: 'Entering Passive Mode ($address,$p1,$p2)'),
    );
    await transferSocket.waitClient(timeout: const Duration(seconds: 30));
    //we sent all that was necessary
    throw FtpNonResponseException();
  }

  Future<String> _getIpAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }

  @override
  List<FtpCommands> get supportedCommands => [FtpCommands.PASV];
}
