import 'dart:io';

import 'package:pure_ftp_server/pure_ftp_server.dart';

Future<void> main() async {
  final ftpServer = FtpServer(
    logCallback: print,
    initialOptions: FtpServerInitialOptions(
      port: 8080,
      users: [
        FtpUser(
          username: 'admin',
          fileSystem: FileSystem.system(Directory.current),
        ),
      ],
    ),
  );
  await ftpServer.start();
}
