import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the `FileStats` class.
void main() => group('FileStats', () {
  group('stat()', () {
    test('should return a numeric identity greater than or equal to 0 for the file owner', () async {
      final fileStats = await FileStats.stat('test/file_stats_test.dart');
      expect(fileStats.uid, greaterThanOrEqualTo(0));
    });

    test('should return a numeric identity greater than or equal to 0 for the file group', () async {
      final fileStats = await FileStats.stat('test/file_stats_test.dart');
      expect(fileStats.gid, greaterThanOrEqualTo(0));
    });

    test('should return a mode greater than 0 for the file permissions', () async {
      final fileStats = await FileStats.stat('test/file_stats_test.dart');
      expect(fileStats.mode, greaterThanOrEqualTo(0));
    });
  }, testOn: 'posix');

  group('.toString()', () {
    final data = FileStats(uid: 2000, gid: 1000, mode: int.parse('755', radix: 8)).toString();

    test('should start with the class name', () {
      expect(data, contains('FileStats {'));
    });

    test('should contain the instance properties', () {
      expect(data, allOf(
        contains('uid: 2000'),
        contains('gid: 1000'),
        contains('mode: 0755')
      ));
    });
  });
});
