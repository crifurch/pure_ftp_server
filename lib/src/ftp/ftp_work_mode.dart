///option for set up how ftp clients have access
///
/// [FtpWorkMode.readWrite] allow client to read and write files and directories
/// [FtpWorkMode.read] allow client to read files and directories
/// [FtpWorkMode.look] allow client only look on files but reject read it
enum FtpWorkMode {
  readWrite,
  read,
  look,
}
