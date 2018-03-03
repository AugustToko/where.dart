import 'package:test/test.dart';
import 'package:where/src/io.dart'
  if (dart.library.io) 'package:where/src/io/vm.dart'
  if (node) 'package:where/src/io/node.dart';

/// Tests the features of the `where.io` library.
void main() => group('getFileStats()', () {
  test('should return a numeric identity greater than or equal to 0 for the file owner', () async {
    var fileStats = await getFileStats('test/io_test.dart');
    expect(fileStats.uid, greaterThanOrEqualTo(0));
  });

  test('should return a numeric identity greater than or equal to 0 for the file group', () async {
    var fileStats = await getFileStats('test/io_test.dart');
    expect(fileStats.gid, greaterThanOrEqualTo(0));
  });

  test('should return a mode greater than 0 for the file permissions', () async {
    var fileStats = await getFileStats('test/io_test.dart');
    expect(fileStats.mode, anyOf(equals(int.parse('664', radix: 8)), equals(int.parse('644', radix: 8))));
  });
}, testOn: 'posix');
