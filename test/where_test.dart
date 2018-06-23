import 'dart:io';
import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the `where` function.
void main() => group('where()', () {
  test('should return the path of the `executable.cmd` file on Windows', () async {
    try {
      var executable = await where('executable', all: false, path: 'test/fixtures');
      if (!Platform.isWindows) fail('Exception not thrown');
      else expect(executable, allOf(const TypeMatcher<String>(), endsWith(r'\test\fixtures\executable.cmd')));
    }

    on Exception catch (err) {
      if (Platform.isWindows) fail(err.toString());
      else expect(err, const TypeMatcher<FinderException>());
    }
  });

  test('should return all the paths of the `executable.cmd` file on Windows', () async {
    try {
      var executables = await where('executable', all: true, path: 'test/fixtures');
      if (!Platform.isWindows) fail('Exception not thrown');
      else {
        expect(executables, allOf(isList, hasLength(1)));
        expect(executables.first, allOf(const TypeMatcher<String>(), endsWith(r'\test\fixtures\executable.cmd')));
      }
    }

    on Exception catch (err) {
      if (Platform.isWindows) fail(err.toString());
      else expect(err, const TypeMatcher<FinderException>());
    }
  });

  test('should return the path of the `executable.sh` file on POSIX', () async {
    try {
      var executable = await where('executable.sh', all: false, path: 'test/fixtures');
      if (Platform.isWindows) fail('Exception not thrown');
      else expect(executable, allOf(const TypeMatcher<String>(), endsWith('/test/fixtures/executable.sh')));
    }

    on Exception catch (err) {
      if (!Platform.isWindows) fail(err.toString());
      else expect(err, const TypeMatcher<FinderException>());
    }
  });

  test('should return all the paths of the `executable.sh` file on POSIX', () async {
    try {
      var executables = await where('executable.sh', all: true, path: 'test/fixtures');
      if (Platform.isWindows) fail('Exception not thrown');
      else {
        expect(executables, allOf(isList, hasLength(1)));
        expect(executables.first, allOf(const TypeMatcher<String>(), endsWith('/test/fixtures/executable.sh')));
      }
    }

    on Exception catch (err) {
      if (!Platform.isWindows) fail(err.toString());
      else expect(err, const TypeMatcher<FinderException>());
    }
  });

  test('should return the value of the `onError` handler', () async {
    var executable = await where('executable', all: false, onError: (_) => 'foo', path: 'test/fixtures');
    if (!Platform.isWindows) expect(executable, equals('foo'));

    var executables = await where('executable.sh', all: true, onError: (_) => ['foo'], path: 'test/fixtures');
    if (Platform.isWindows) {
      expect(executables, allOf(isList, hasLength(1)));
      expect(executables.first, equals('foo'));
    }
  });
});
