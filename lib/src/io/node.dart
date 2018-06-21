import 'dart:async';
import 'dart:js';
import 'package:file/file.dart';
import 'package:nodejs_interop/io.dart' as io;
import 'package:nodejs_interop/node.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'package:where/src/core.dart';

/// The command line arguments.
List<String> get arguments => process.argv.skip(2).toList();

/// The global exit code for the process.
int get exitCode => io.exitCode;
set exitCode(int value) => io.exitCode = value;

/// A reference to the file system.
const FileSystem fileSystem = io.FileSystem();

/// A reference to the platform.
const Platform platform = io.Platform();

/// A reference to the process manager.
const ProcessManager processManager = io.ProcessManager();

/// The numeric group identity of the process.
Future<int> get processGid => Future.value(platform.isWindows ? -1 : process.getegid());

/// The numeric user identity of the process.
Future<int> get processUid => Future.value(platform.isWindows ? -1 : process.geteuid());

/// Returns the statistics of the specified [file].
Future<FileStats> getFileStats(String file) {
  var completer = Completer<FileStats>();
  loadLibrary<FSModule>('fs').stat(file, allowInterop((error, [stats]) {
    if (error == null) completer.complete(FileStats(uid: stats.uid, gid: stats.gid, mode: stats.mode));
    else completer.completeError(FileSystemException(error.message, file));
  }));

  return completer.future;
}
