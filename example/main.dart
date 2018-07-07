import 'dart:async';
import 'package:where/where.dart';

Future<void> main() async {
  try {
    // `path` is the absolute path to the executable.
    var path = await where('foobar');
    print('The command "foobar" is located at: $path');
  }

  on FinderException catch (err) {
    print('The command "${err.command}" is not found');
  }
}
