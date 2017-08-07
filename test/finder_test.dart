import 'dart:async';
import 'dart:io';
import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the [Finder] class.
void main() => group('Finder', () {
  /*
  group('constructor', () {
    test('should set the `path` property to the value of the `PATH` environment variable by default', () {
      var pathEnv = Platform.environment.containsKey('PATH') ? Platform.environment['PATH'] : '';
      var paths = pathEnv.isEmpty ? [] : pathEnv.split(Platform.pathSeparator);
      expect(new Finder().path).to.have.ordered.members(paths);
    });

    test('should split the input path using the path separator', () {
      var paths = ['/usr/local/bin', '/usr/bin'];
      var finder = new Finder(paths.join(Platform.pathSeparator));
      expect(finder.path).to.have.ordered.members(paths);
    });

    test('should set the `extensions` property to the value of the `PATHEXT` environment variable by default', () {
      var pathExt = Platform.environment.containsKey('PATHEXT') ? Platform.environment['PATHEXT'] : '';
      var extensions = pathExt.length ? pathExt.split(Platform.pathSeparator) : [];
      expect(new Finder().extensions).to.have.ordered.members(extensions);
    });

    test('should split the extension list using the path separator', () {
      var extensions = ['.EXE', '.CMD', '.BAT'];
      var finder = new Finder('', extensions.join(Platform.pathSeparator));
      expect(finder.extensions).to.have.ordered.members(extensions);
    });

    test('should set the `pathSeparator` property to the value of the `Platform.pathSeparator` constant by default', () {
      expect(new Finder().pathSeparator).to.equal(Platform.pathSeparator);
    });

    test('should properly set the path separator', () {
      var finder = new Finder('', '', '#');
      expect(finder.pathSeparator).to.equal('#');
    });
  });*/

  group('.find()', () {
    test('should return the path of the `executable.cmd` file on Windows', () async {
      var executables = await new Finder(path: ['test/fixtures']).find('executable').toList();
      expect(executables.length, equals(Finder.isWindows ? 1 : 0));
      if (Finder.isWindows) expect(executables.first, endsWith(r'\test\fixtures\executable.cmd'));
    });

    test('should return the path of the `executable.sh` file on POSIX', () async {
      var executables = await new Finder(path: ['test/fixtures']).find('executable.sh').toList();
      expect(executables.length, equals(Finder.isWindows ? 0 : 1));
      if (!Finder.isWindows) expect(executables.first, endsWith('/test/fixtures/executable.sh'));
    });
  });

  group('.isExecutable()', () {
    test('should return `false` for a non-executable file', () async {
      expect(await new Finder().isExecutable('test/finder_test.dart'), isFalse);
    });

    test('should return `false` for a POSIX executable, when test is run on Windows', () async {
      expect(await new Finder().isExecutable('test/fixtures/executable.sh'), isNot(equals(Finder.isWindows)));
    });

    test('should return `false` for a Windows executable, when test is run on POSIX', () async {
      expect(await new Finder().isExecutable('test/fixtures/executable.cmd'), equals(Finder.isWindows));
    });
  });
});
