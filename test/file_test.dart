import 'package:test/test.dart';
import 'package:where/src/file.dart';
import 'package:where/src/io.dart';

/// Tests the features of the `where` library.
void main() {
  group('Finder', () {
    var delimiter = Finder.isWindows ? ';' : ':';

    group('constructor', () {
      test('should set the `path` property to the value of the `PATH` environment variable by default', () {
        var pathEnv = platform.environment['PATH'] ?? '';
        var path = pathEnv.isEmpty ? <String>[] : pathEnv.split(delimiter);
        expect(Finder().path, orderedEquals(path));
      });

      test('should split the input path using the path separator', () {
        var path = ['/usr/local/bin', '/usr/bin'];
        expect(Finder(path: path.join(delimiter)).path, orderedEquals(path));
      });

      test('should set the `extensions` property to the value of the `PATHEXT` environment variable by default', () {
        var pathExt = platform.environment['PATHEXT'] ?? '';
        var extensions = pathExt.isEmpty ? <String>[] : pathExt.split(delimiter).map((item) => item.toLowerCase());
        expect(Finder().extensions, orderedEquals(extensions));
      });

      test('should split the extension list using the path separator', () {
        var extensions = ['.EXE', '.CMD', '.BAT'];
        expect(Finder(extensions: extensions.join(delimiter)).extensions, orderedEquals(['.exe', '.cmd', '.bat']));
      });

      test('should set the `pathSeparator` property to the value of the platform path separator by default', () {
        expect(Finder().pathSeparator, equals(delimiter));
      });

      test('should properly set the path separator', () {
        expect(Finder(pathSeparator: '#').pathSeparator, equals('#'));
      });
    });

    group('.find()', () {
      test('should return the path of the `executable.cmd` file on Windows', () async {
        var executables = await Finder(path: 'test/fixtures').find('executable').toList();
        expect(executables.length, equals(Finder.isWindows ? 1 : 0));
        if (Finder.isWindows) expect(executables.first, endsWith(r'\test\fixtures\executable.cmd'));
      });

      test('should return the path of the `executable.sh` file on POSIX', () async {
        var executables = await Finder(path: 'test/fixtures').find('executable.sh').toList();
        expect(executables.length, equals(Finder.isWindows ? 0 : 1));
        if (!Finder.isWindows) expect(executables.first, endsWith('/test/fixtures/executable.sh'));
      });
    });

    group('.isExecutable()', () {
      test('should return `false` for a non-executable file', () async {
        expect(await Finder().isExecutable('test/where_test.dart'), isFalse);
      });

      test('should return `false` for a POSIX executable, when test is run on Windows', () async {
        expect(await Finder().isExecutable('test/fixtures/executable.sh'), isNot(equals(Finder.isWindows)));
      });

      test('should return `false` for a Windows executable, when test is run on POSIX', () async {
        expect(await Finder().isExecutable('test/fixtures/executable.cmd'), equals(Finder.isWindows));
      });
    });
  });

  group('where()', () {
    test('should return the path of the `executable.cmd` file on Windows', () async {
      try {
        var executable = await where('executable', all: false, path: 'test/fixtures');
        if (!Finder.isWindows) fail('Exception not thrown');
        else expect(executable, allOf(const TypeMatcher<String>(), endsWith(r'\test\fixtures\executable.cmd')));
      }

      on Exception catch (err) {
        if (Finder.isWindows) fail(err.toString());
        else expect(err, const TypeMatcher<FinderException>());
      }
    });

    test('should return all the paths of the `executable.cmd` file on Windows', () async {
      try {
        var executables = await where('executable', all: true, path: 'test/fixtures');
        if (!Finder.isWindows) fail('Exception not thrown');
        else {
          expect(executables, allOf(isList, hasLength(1)));
          expect(executables.first, allOf(const TypeMatcher<String>(), endsWith(r'\test\fixtures\executable.cmd')));
        }
      }

      on Exception catch (err) {
        if (Finder.isWindows) fail(err.toString());
        else expect(err, const TypeMatcher<FinderException>());
      }
    });

    test('should return the path of the `executable.sh` file on POSIX', () async {
      try {
        var executable = await where('executable.sh', all: false, path: 'test/fixtures');
        if (Finder.isWindows) fail('Exception not thrown');
        else expect(executable, allOf(const TypeMatcher<String>(), endsWith('/test/fixtures/executable.sh')));
      }

      on Exception catch (err) {
        if (!Finder.isWindows) fail(err.toString());
        else expect(err, const TypeMatcher<FinderException>());
      }
    });

    test('should return all the paths of the `executable.sh` file on POSIX', () async {
      try {
        var executables = await where('executable.sh', all: true, path: 'test/fixtures');
        if (Finder.isWindows) fail('Exception not thrown');
        else {
          expect(executables, allOf(isList, hasLength(1)));
          expect(executables.first, allOf(const TypeMatcher<String>(), endsWith('/test/fixtures/executable.sh')));
        }
      }

      on Exception catch (err) {
        if (!Finder.isWindows) fail(err.toString());
        else expect(err, const TypeMatcher<FinderException>());
      }
    });

    test('should return the value of the `onError` handler', () async {
      var executable = await where('executable', all: false, onError: (_) => 'foo', path: 'test/fixtures');
      if (!Finder.isWindows) expect(executable, equals('foo'));

      var executables = await where('executable.sh', all: true, onError: (_) => ['foo'], path: 'test/fixtures');
      if (Finder.isWindows) {
        expect(executables, allOf(isList, hasLength(1)));
        expect(executables.first, equals('foo'));
      }
    });
  });
}
