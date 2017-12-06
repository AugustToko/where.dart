import 'dart:async';
import 'dart:js';
import 'package:file/file.dart';
import 'package:nodejs_interop/nodejs_interop.dart' as node;
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:where/core.dart';

/// The command line arguments.
List<String> get arguments => node.process.argv.skip(2).toList();

/// The global exit code for the process.
int get exitCode => node.exitCode;
set exitCode(int value) => node.exitCode = value;

/// A reference to the file system.
const FileSystem fileSystem = const node.FileSystem();

/// A reference to the platform.
const Platform platform = const node.Platform();

/// A reference to the process manager.
const ProcessManager processManager = const node.ProcessManager();

/// The numeric group identity of the process.
Future<int> get processGid => new Future.value(platform.isWindows ? -1 : node.process.getegid());

/// The numeric user identity of the process.
Future<int> get processUid => new Future.value(platform.isWindows ? -1 : node.process.geteuid());

/// Returns the statistics of the specified [file].
Future<FileStats> getFileStats(String file) {
  var completer = new Completer<FileStats>();
  node.loadLibrary<node.FSModule>('fs').stat(file, allowInterop((error, [stats]) {
    if (error != null) completer.completeError(new FileSystemException(error.message, file));
    else completer.complete(new FileStats(uid: stats.uid, gid: stats.gid, mode: stats.mode));
  }));

  return completer.future;
}
