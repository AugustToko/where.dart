import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the `where` function.
void main() => group('where()', () {
  test('should return the path of the `executable.cmd` file on Windows', () async {
    try {
      final executable = await where('executable', all: false, path: 'test/fixtures');
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
      final executables = await where('executable', all: true, path: 'test/fixtures');
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
      final executable = await where('executable.sh', all: false, path: 'test/fixtures');
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
      final executables = await where('executable.sh', all: true, path: 'test/fixtures');
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
    final executable = await where('executable', all: false, onError: (_) => 'foo', path: 'test/fixtures');
    if (!Finder.isWindows) expect(executable, 'foo');

    final executables = await where('executable.sh', all: true, onError: (_) => ['foo'], path: 'test/fixtures');
    if (Finder.isWindows) {
      expect(executables, allOf(isList, hasLength(1)));
      expect(executables.first, 'foo');
    }
  });
});
