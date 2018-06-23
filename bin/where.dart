#!/usr/bin/env dart

import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:args/args.dart';
import 'package:where/where.dart';
import 'package:yaml/yaml.dart';

/// The command line argument parser.
final ArgParser _parser = ArgParser()
  ..addFlag('all', abbr: 'a', help: 'List all instances of executables found (instead of just the first one).', negatable: false)
  ..addFlag('silent', abbr: 's', help: 'Silence the output, just return the exit code (0 if any executable is found, otherwise 1).', negatable: false)
  ..addFlag('help', abbr: 'h', help: 'Output usage information.', negatable: false)
  ..addFlag('version', abbr: 'v', help: 'Output the version number.', negatable: false);

/// The usage information.
final String usage = (StringBuffer()
  ..writeln('Find the instances of an executable in the system path.')..writeln()
  ..writeln('Usage: where [options] <command>')..writeln()
  ..writeln('Options:')
  ..write(_parser.usage))
  .toString();

/// The version number of this package.
Future<String> get version async {
  var package = await Isolate.resolvePackageUri(Uri.parse('package:where/'));
  var pubspec = loadYaml(await File(package.resolve('../pubspec.yaml').toFilePath()).readAsString());
  return pubspec['version'];
}

/// Application entry point.
Future<void> main(List<String> args) async {
  // Parse the command line arguments.
  ArgResults results;

  try {
    results = _parser.parse(args);
    if (results['help']) {
      print(usage);
      return null;
    }

    if (results['version']) {
      print(await version);
      return null;
    }

    if (results.rest.isEmpty) throw ArgParserException('A command must be provided');
  }

  on ArgParserException {
    print(usage);
    exitCode = 64;
    return null;
  }

  // Run the program.
  try {
    var executables = await where(results.rest.first, all: results['all']);
    if (!results['silent']) {
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
