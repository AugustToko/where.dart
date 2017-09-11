/// Find the instances of an executable in the system path.
library where;

import 'dart:async';
import 'dart:io' hide FileStat;
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

part 'src/file_stat.dart';
part 'src/finder.dart';
part 'src/where.dart';

/// The version number of this package.
const String version = '1.1.0';
