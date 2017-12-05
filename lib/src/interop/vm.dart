import 'dart:async';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

/// The command line arguments.
List<String> get arguments => throw new UnsupportedError('Not supported by the Dart VM.');

/// The global exit code for the process.
int get exitCode => io.exitCode;
set exitCode(int value) => io.exitCode = value;

/// A reference to the file system.
const FileSystem fileSystem = const LocalFileSystem();

/// A reference to the platform.
const Platform platform = const LocalPlatform();

/// A reference to the process manager.
const ProcessManager processManager = const LocalProcessManager();

/// The numeric group identity of the process.
Future<int> get processGid async {
  if (platform.isWindows) return -1;
  var result = await processManager.run(['id', '-g']);
  return result.exitCode != 0 ? -1 : int.parse(result.stdout.trim(), radix: 10, onError: (_) => -1);
}

/// The numeric user identity of the process.
Future<int> get processUid async {
  if (platform.isWindows) return -1;
  var result = await processManager.run(['id', '-u']);
  return result.exitCode != 0 ? -1 : int.parse(result.stdout.trim(), radix: 10, onError: (_) => -1);
}
