/// Find the instances of an executable in the system path.
library where;

import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:syscall/syscall.dart' deferred as syscall;

// TODO: part 'src/application.dart';
part 'src/finder.dart';
part 'src/where.dart';

/// Value indicating whether the current platform is Windows.
final bool _isWindows = Platform.isWindows ?
  true :
  Platform.environment['OSTYPE'] == 'cygwin' || Platform.environment['OSTYPE'] == 'msys';
