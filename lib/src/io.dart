/// Provides the I/O support.
library where.io;

import 'dart:async';
import 'package:file/file.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';
import 'core.dart';

/// The command line arguments.
List<String> get arguments => const [];

/// The global exit code for the process.
int get exitCode => 0;
set exitCode(int value) => null;

/// A reference to the file system.
const FileSystem fileSystem = null;

/// A reference to the platform.
const Platform platform = null;

/// A reference to the process manager.
const ProcessManager processManager = null;

/// The numeric group identity of the process.
Future<int> get processGid => new Future.value(-1);

/// The numeric user identity of the process.
Future<int> get processUid => new Future.value(-1);

/// Returns the statistics of the specified [file].
Future<FileStats> getFileStats(String file) => null;
