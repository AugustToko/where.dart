import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:grinder/grinder.dart';
import 'package:test/test.dart';

/// Starts the build system.
Future<void> main(List<String> args) => grind(args);

@DefaultTask('Builds the project')
void build() => Pub.run('build_runner', arguments: ['build', '--delete-conflicting-outputs']);

@Task('Deletes all generated files and reset any saved state')
void clean() {
  defaultClean();
  ['.dart_tool/build', 'doc/api', webDir.path].map(getDir).forEach(delete);
  FileSet.fromDir(getDir('var'), pattern: '!.*', recurse: true).files.forEach(delete);
}

@Task('Uploads the results of the code coverage')
void coverage() => Pub.global.run('coveralls', arguments: ['var/lcov.info']);

@Task('Builds the documentation')
Future<void> doc() async {
  await getFile('CHANGELOG.md').copy('doc/about/changelog.md');
  await getFile('LICENSE.md').copy('doc/about/license.md');
  DartDoc.doc();
  run('mkdocs', arguments: ['build', '--config-file=doc/mkdocs.yml']);
  delete(joinFile(webDir, ['mkdocs.yml']));
}

@Task('Fixes the coding standards issues')
void fix() => DartFmt.format(existingSourceDirs);

@Task('Performs the static analysis of source code')
void lint() => Analyzer.analyze(existingSourceDirs);

@Task('Runs the test suites')
Future<void> test() async {
  await Pub.runAsync('coverage', script: 'collect_coverage', arguments: [
    '--out=var/coverage.json',
    '--resume-isolates',
    '--uri=${await _profileTest(getFile('test/all.dart'))}',
    '--wait-paused'
  ]);

  return Pub.runAsync('coverage', script: 'format_coverage', arguments: [
    '--in=var/coverage.json',
    '--lcov',
    '--out=var/lcov.info',
    '--packages=.packages',
    '--report-on=${libDir.path}'
  ]);
}

@Task('Upgrades the project to the latest revision')
void upgrade() {
  run('git', arguments: ['reset', '--hard']);
  run('git', arguments: ['fetch', '--all', '--prune']);
  run('git', arguments: ['pull', '--rebase']);
  Pub.upgrade();
}

@Task('Watches for file changes')
void watch() => Pub.run('build_runner', arguments: ['watch', '--delete-conflicting-outputs']);

/// Profiles the execution of the specified test file.
/// Returns the URI of the Observatory profiler.
Future<Uri> _profileTest(File testFile) async {
  final completer = Completer<Uri>();
  final process = await Process.start('dart', ['--enable-vm-service', '--pause-isolates-on-exit', testFile.path]);

  var counter = 0;
  process.stdout.transform(utf8.decoder).listen((data) {
    final output = data.trim();
    print(output);

    if (++counter == 1) {
      final match = RegExp(r'^Observatory listening on (.*)$').firstMatch(output);
      final uri = match != null ? match[1] : 'http://127.0.0.1:8181/';
      completer.complete(Uri.parse(uri));
    }
  });

  return completer.future;
}
