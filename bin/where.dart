#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'package:args/args.dart';
import 'package:where/where.dart';

/// The version number of this package.
const String version = '2.1.1';

/// The command line argument parser.
final ArgParser _parser = new ArgParser()
  ..addFlag('all', abbr: 'a', help: 'list all instances of executables found (instead of just the first one)', negatable: false)
  ..addFlag('silent', abbr: 's', help: 'silence the output, just return the exit code (0 if any executable is found, otherwise 1)', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'output usage information', negatable: false)
  ..addFlag('version', abbr: 'v', help: 'output the version number', negatable: false);

/// The usage information.
final String usage = (new StringBuffer()
  ..writeln('Find the instances of an executable in the system path.')
  ..writeln()
  ..writeln('Usage:')
  ..writeln('pub global run where [options] <command>')
  ..writeln()
  ..writeln('Options:')
  ..write(_parser.usage))
  .toString();

/// Application entry point.
Future main(List<String> args) async {
  // Parse the command line arguments.
  ArgResults results;

  try {
    results = _parser.parse(args);
    if (results['help']) {
      print(usage);
      exit(0);
    }

    if (results['version']) {
      print(version);
      exit(0);
    }

    if (results.rest.isEmpty) throw new ArgParserException('A command must be provided.');
  }

  on ArgParserException {
    print(usage);
    exit(64);
  }

  // Run the program.
  try {
    var executables = await where(results.rest.first, all: results['all'], onError: (_) => exit(1));
    if (!results['silent']) {
      if (executables is! List<String>) executables = [executables];
      executables.forEach(print);
    }

    exit(0);
  }

  on Exception catch (err) {
    print(err);
    exit(2);
  }
}
