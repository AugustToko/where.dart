/// Provides the file system abstraction.
library where.file;

import 'dart:async';
import 'package:file/file.dart';
import 'core.dart';
import 'io.dart';

// ignore: directives_ordering
export 'io.dart' show arguments, exitCode, fileSystem, platform;

part 'file/finder.dart';
part 'file/where.dart';
