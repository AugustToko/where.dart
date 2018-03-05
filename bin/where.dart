#!/usr/bin/env dart

import 'dart:async';
import 'dart:isolate';
import 'package:args/args.dart';
import 'package:where/where.dart';
import 'package:yaml/yaml.dart';

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
  ..writeln('where [options] <command>')
  ..writeln()
  ..writeln('Options:')
  ..write(_parser.usage))
  .toString();

/// The version number of this package.
Future<String> get version async {
  var path = const bool.fromEnvironment('node') ? '../../pubspec.yaml' : '../pubspec.yaml';
  var uri = (await Isolate.resolvePackageUri(Uri.parse('package:where/'))).resolve(path);
  Map pubspec = loadYaml(await fileSystem.file(uri.toFilePath(windows: platform.isWindows)).readAsString());
  return pubspec['version'];
}

/// Application entry point.
Future main(List<String> args) async {
  // Parse the command line arguments.
  ArgResults results;

  try {
    results = _parser.parse(const bool.fromEnvironment('node') ? arguments : args);
    if (results['help']) {
      print(usage);
      return;
    }

    if (results['version']) {
      print(await version);
      return;
    }

    if (results.rest.isEmpty) throw new ArgParserException('A command must be provided.');
  }

  on ArgParserException {
    print(usage);
    exitCode = 64;
    return;
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
