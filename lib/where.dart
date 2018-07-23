/// Find the instances of an executable in the system path.
library where;

import 'dart:async';
import 'dart:io';
import 'package:build_cli_annotations/build_cli_annotations.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

part 'where.g.dart';
part 'src/cli.dart';
part 'src/file_stats.dart';
part 'src/finder.dart';
part 'src/where.dart';
