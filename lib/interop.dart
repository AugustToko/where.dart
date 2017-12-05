/// Provides interoperability with native APIs.
library where.interop;

import 'package:file/file.dart';
import 'package:platform/platform.dart';
import 'package:process/process.dart';

/// The command line arguments.
List<String> get arguments => null;

/// A reference to the file system.
const FileSystem fileSystem = null;

/// A reference to the platform.
const Platform platform = null;

/// A reference to the process manager.
const ProcessManager processManager = null;

/// The global exit code for the process.
int get exitCode => 0;
set exitCode(int value) => null;
