import 'package:test/test.dart';
import 'package:where/where.dart';

/// Tests the features of the [Application] class.
void main() => group('Application', () {
  group('.run()', () {
    test('should return `0` if everything went fine', () async {
      expect(await new Application().run(['--silent', 'dart']), equals(0));
    });
  });
});
