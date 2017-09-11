import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the [FileStat] class.
void main() => group('FileStat', () {
  group('.stat()', () {
    test('should return a numeric identity greater than or equal to 0 for the file owner', () async {
      var fileStats = await FileStat.stat('test/file_stat_test.dart');
      expect(fileStats.uid, greaterThanOrEqualTo(0));
    });

    test('should return a numeric identity greater than or equal to 0 for the file group', () async {
      var fileStats = await FileStat.stat('test/file_stat_test.dart');
      expect(fileStats.gid, greaterThanOrEqualTo(0));
    });

    test('should return a mode greater than 0 for the file permissions', () async {
      var fileStats = await FileStat.stat('test/file_stat_test.dart');
      expect(fileStats.mode, greaterThan(0));
    });
  }, onPlatform: {
    'windows': const Skip('Not supported on the Windows platform.')
  });

  group('.toString()', () {
    var data = new FileStat(uid: 2000, gid: 1000, mode: int.parse('755', radix: 8)).toString();

    test('should start with the class name', () {
      expect(data, contains('FileStat {'));
    });

    test('should contain the instance properties', () {
      expect(data, contains('uid: 2000'));
      expect(data, contains('gid: 1000'));
      expect(data, contains('mode: 0755'));
    });
  });
});
