/// Find the instances of an executable in the system path.
library where;

import 'dart:async';
import 'dart:io' hide FileStat;
import 'package:path/path.dart' as p;

part 'src/file_stat.dart';
part 'src/finder.dart';
part 'src/where.dart';

/// Value indicating whether the current platform is Windows.
final bool _isWindows = Platform.isWindows ?
  true :
  Platform.environment['OSTYPE'] == 'cygwin' || Platform.environment['OSTYPE'] == 'msys';
