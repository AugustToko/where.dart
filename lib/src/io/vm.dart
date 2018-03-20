import 'dart:async';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:where/src/core.dart';

/// The command line arguments.
List<String> get arguments => throw UnsupportedError('Not supported by the Dart VM');

/// The global exit code for the process.
int get exitCode => io.exitCode;
set exitCode(int value) => io.exitCode = value;

/// A reference to the file system.
const FileSystem fileSystem = LocalFileSystem();

/// A reference to the platform.
const Platform platform = LocalPlatform();

/// A reference to the process manager.
const ProcessManager processManager = LocalProcessManager();

/// The numeric group identity of the process.
Future<int> get processGid async {
  if (platform.isWindows) return -1;
  var result = await processManager.run(<String>['id', '-g']);
  return result.exitCode != 0 ? -1 : int.parse(result.stdout.trim(), radix: 10, onError: (_) => -1);
}

/// The numeric user identity of the process.
Future<int> get processUid async {
  if (platform.isWindows) return -1;
  var result = await processManager.run(<String>['id', '-u']);
  return result.exitCode != 0 ? -1 : int.parse(result.stdout.trim(), radix: 10, onError: (_) => -1);
}

/// Returns the statistics of the specified [file].
Future<FileStats> getFileStats(String file) async {
  if (platform.isWindows) throw UnsupportedError('Not supported by the Windows platform');

  var args = platform.isMacOS ? ['-f', '%u:%g:%p', '-L'] : ['--dereference', '--format=%u:%g:%a'];
  var result = await processManager.run(<String>['stat']..addAll(args)..add(file));
  if (result.exitCode != 0) throw io.ProcessException('stat', args);

  List<String> parts = result.stdout.trim().split(':');
  if (parts.length != 3) throw io.ProcessException('stat', args);

  return FileStats(
    uid: int.parse(parts.first, radix: 10, onError: (_) => -1),
    gid: int.parse(parts[1], radix: 10, onError: (_) => -1),
    mode: int.parse(parts.last, radix: 8, onError: (_) => 0)
  );
}
