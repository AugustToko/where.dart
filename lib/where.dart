/// Find the instances of an executable in the system path.
library where;
// ignore_for_file: directives_ordering

import 'dart:async';
import 'package:file/file.dart';
import 'core.dart';

import 'io.dart'
  if (dart.library.io) 'src/io/vm.dart'
  if (node) 'src/io/node.dart';

export 'core.dart';
export 'io.dart'
  if (dart.library.io) 'src/io/vm.dart'
  if (node) 'src/io/node.dart'
  hide processGid, processUid;

part 'src/finder.dart';
part 'src/where.dart';
