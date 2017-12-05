import 'dart:async';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:where/core.dart';

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

/// Returns the statistics of the specified [file].
Future<FileStats> getFileStats(String file) async {
  if (platform.isWindows) throw new UnsupportedError('Not supported by the Windows platform.');

  var args = platform.isMacOS ? ['-f', '%u:%g:%p', '-L'] : ['--dereference', '--format=%u:%g:%a'];
  var result = await processManager.run(['stat']..addAll(args)..add(file));
  if (result.exitCode != 0) throw new io.ProcessException('stat', args);

  var parts = result.stdout.trim().split(':');
  if (parts.length != 3) throw new io.ProcessException('stat', args);

  return new FileStats(
    uid: int.parse(parts.first, radix: 10, onError: (_) => -1),
    gid: int.parse(parts[1], radix: 10, onError: (_) => -1),
    mode: int.parse(parts.last, radix: 8, onError: (_) => 0)
  );
}
