/// Find the instances of an executable in the system path.
library where;

import 'dart:async';
import 'dart:io' show ProcessException;
import 'package:file/file.dart';

import 'interop.dart'
  if (dart.library.io) 'src/interop/vm.dart'
  if (node) 'src/interop/node.dart';

// ignore: directives_ordering
export 'interop.dart'
  if (dart.library.io) 'src/interop/vm.dart'
  if (node) 'src/interop/node.dart'
  show arguments, exitCode, fileSystem, platform;

part 'src/file_stat.dart';
part 'src/finder.dart';
part 'src/where.dart';
