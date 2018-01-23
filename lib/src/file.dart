/// Provides the file system abstraction.
library where.file;

import 'dart:async';
import 'package:file/file.dart';
import 'package:where/src/core.dart';
import 'package:where/src/io.dart'
  if (dart.library.io) 'src/io/vm.dart'
  if (node) 'src/io/node.dart';

// ignore: directives_ordering
export 'package:where/src/io.dart'
  if (dart.library.io) 'src/io/vm.dart'
  if (node) 'src/io/node.dart'
  show arguments, exitCode, fileSystem, platform;

part 'file/finder.dart';
part 'file/where.dart';
