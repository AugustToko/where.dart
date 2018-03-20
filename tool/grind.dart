import 'dart:async';
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:node_preamble/preamble.dart';

/// The current environment.
final String _environment = Platform.environment['DART_ENV'] ?? String.fromEnvironment('env', defaultValue: 'development');

/// Value indicating whether the debug mode is enabled.
final bool _debug = _environment == 'development' || _environment == 'test';

/// Starts the build system.
Future main(List<String> args) => grind(args);

/// Builds the project.
@DefaultTask('Build the project')
Future build() async {
  var executable = joinFile(binDir, ['where.js']);
  var args = ['-Dnode=true']..addAll(_debug ? [] : ['--trust-primitives', '--trust-type-annotations']);
  Dart2js.compile(joinFile(binDir, ['where.dart']), extraArgs: args, minify: !_debug, outFile: executable);

  await executable.writeAsString('#!/usr/bin/env node\n${getPreamble(minified: !_debug)}\n${await executable.readAsString()}');
  if (!Platform.isWindows) run('chmod', arguments: ['+x', executable.path]);
  FileSet.fromDir(binDir, pattern: '*.{deps,map}').files.forEach(delete);
}

/// Deletes all generated files and reset any saved state.
@Task('Delete the generated files')
void clean() {
  defaultClean();
  delete(joinFile(binDir, ['where.js']));
  ['doc/api', 'web'].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '*.{info,json}').files.forEach(delete);
}

/// Uploads the code coverage report.
@Task('Upload the code coverage')
void coverage() => Pub.run('coveralls', arguments: ['var/lcov.info']);

/// Builds the documentation.
@Task('Build the documentation')
void doc() {
  DartDoc.doc();
  run('mkdocs', arguments: ['build']);
}

/// Fixes the coding standards issues.
@Task('Fix the coding issues')
void fix() => DartFmt.format(existingSourceDirs);

/// Performs static analysis of source code.
@Task('Perform the static analysis')
void lint() => Analyzer.analyze(existingSourceDirs);

/// Runs all the test suites.
@Task('Run the tests')
Future test() async {
  await Future.wait([
    Dart.runAsync('test/all.dart', vmArgs: ['--enable-vm-service', '--pause-isolates-on-exit']),
    Pub.runAsync('coverage', script: 'collect_coverage', arguments: ['--out=var/coverage.json', '--resume-isolates', '--wait-paused'])
  ]);

  var args = ['--in=var/coverage.json', '--lcov', '--out=var/lcov.info', '--packages=.packages', '--report-on=${libDir.path}'];
  return Pub.runAsync('coverage', script: 'format_coverage', arguments: args);
}
