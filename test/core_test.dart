import 'package:test/test.dart';
import 'package:where/src/core.dart';

/// Tests the features of the `where.core` library.
void main() => group('FileStats', () {
  group('.toString()', () {
    var data = new FileStats(uid: 2000, gid: 1000, mode: int.parse('755', radix: 8)).toString();

    test('should start with the class name', () {
      expect(data, contains('FileStats {'));
    });

    test('should contain the instance properties', () {
      expect(data, contains('uid: 2000'));
      expect(data, contains('gid: 1000'));
      expect(data, contains('mode: 0755'));
    });
  });
});
