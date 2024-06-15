import 'dart:io';
import 'dart:typed_data';

import 'package:pure_ftp_server/pure_ftp_server.dart';

Future<void> main() async {
  final ftpServer = FtpServer(
    logCallback: print,
    initialOptions: FtpServerInitialOptions(
      port: 8080,
      users: [
        FtpUser(
          username: 'admin',
          password: 'admin',
          fileSystem: FileSystem.system(Directory.current),
        ),
        FtpUser(
          username: 'admin2',
          password: 'admin',
          fileSystem: FileSystem.inMem(
            initialData: {
              'test': {
                'readMe.txt': Uint8List.fromList('i\'m test'.codeUnits),
              },
            },
          ),
        ),
      ],
    ),
  );
  await ftpServer.start();
}
