import 'package:file/testing.dart';
import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the [where] function.
void main() => group('where()', () {
  test('should return the path of the `executable.cmd` file on Windows', () async {
    try {
      var executable = await where('executable', all: false, path: 'test/fixtures');
      if (!Finder.isWindows) fail('Exception not thrown.');
      else expect(executable, allOf(const isInstanceOf<String>(), endsWith(r'\test\fixtures\executable.cmd')));
    }

    on Exception catch (err) {
      if (Finder.isWindows) fail('Exception should not be thrown.');
      else expect(err, isFileSystemException());
    }
  });

  test('should return all the paths of the `executable.cmd` file on Windows', () async {
    try {
      var executables = await where('executable', all: true, path: 'test/fixtures');
      if (!Finder.isWindows) fail('Exception not thrown.');
      else {
        expect(executables, allOf(isList, hasLength(1)));
        expect(executables.first, allOf(const isInstanceOf<String>(), endsWith(r'\test\fixtures\executable.cmd')));
      }
    }

    on Exception catch (err) {
      if (Finder.isWindows) fail('Exception should not be thrown.');
      else expect(err, isFileSystemException());
    }
  });

  test('should return the path of the `executable.sh` file on POSIX', () async {
    try {
      var executable = await where('executable.sh', all: false, path: 'test/fixtures');
      if (Finder.isWindows) fail('Exception not thrown.');
      else expect(executable, allOf(const isInstanceOf<String>(), endsWith('/test/fixtures/executable.sh')));
    }

    on Exception catch (err) {
      if (!Finder.isWindows) fail('Exception should not be thrown.');
      else expect(err, isFileSystemException());
    }
  });

  test('should return all the paths of the `executable.sh` file on POSIX', () async {
    try {
      var executables = await where('executable.sh', all: true, path: 'test/fixtures');
      if (Finder.isWindows) fail('Exception not thrown.');
      else {
        expect(executables, allOf(isList, hasLength(1)));
        expect(executables.first, allOf(const isInstanceOf<String>(), endsWith('/test/fixtures/executable.sh')));
      }
    }

    on Exception catch (err) {
      if (!Finder.isWindows) fail('Exception should not be thrown.');
      else expect(err, isFileSystemException());
    }
  });

  test('should return the value of the `onError` handler', () async {
    var executable = await where('executable', all: false, path: 'test/fixtures', onError: (_) => 'foo');
    if (!Finder.isWindows) expect(executable, equals('foo'));

    var executables = await where('executable.sh', all: true, path: 'test/fixtures', onError: (_) => ['foo']);
    if (Finder.isWindows) {
      expect(executables, allOf(isList, hasLength(1)));
      expect(executables.first, equals('foo'));
    }
  });
});
