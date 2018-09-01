#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:where/where.dart';
import 'package:where/src/cli.dart';
import 'package:where/src/version.dart';

/// The usage information.
final String usage = (StringBuffer()
  ..writeln('Find the instances of an executable in the system path.')..writeln()
  ..writeln('Usage: where [options] <command>')..writeln()
  ..writeln('Options:')
  ..write(argParser.usage))
  .toString();

/// Application entry point.
Future<void> main(List<String> args) async {
  // Parse the command line arguments.
  Options options;

  try {
    options = parseOptions(args);
    if (options.help) {
      print(usage);
      return null;
    }

    if (options.version) {
      print(packageVersion);
      return null;
    }

    if (options.rest.isEmpty) throw const FormatException('A command must be provided.');
  }

  on FormatException {
    print(usage);
    exitCode = 64;
    return null;
  }

  // Run the program.
  try {
    var executables = await where(options.rest.first, all: options.all);
    if (!options.silent) {
      if (executables is! List<String>) executables = <String>[executables];
      executables.forEach(print);
    }
  }

  on FinderException {
    exitCode = 1;
  }

  on Exception catch (err) {
    print(err);
    exitCode = 2;
  }
}
