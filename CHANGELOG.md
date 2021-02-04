# Changelog

## Version [8.0.0](https://github.com/cedx/where.dart/compare/v7.0.0...v8.0.0)
- Breaking change: removed the `Finder.pathSeparator` property.
- Breaking change: the `extensions` and `path` arguments don't accept strings anymore.
- Replaced the build system based on [Grinder](https://pub.dev/packages/grinder) by [PowerShell](https://docs.microsoft.com/en-us/powershell) scripts.
- Updated the package dependencies.

## Version [7.0.0](https://github.com/cedx/where.dart/compare/v6.6.0...v6.7.0)
- Breaking change: the `Finder.find()` method now returns [`File`](https://api.dart.dev/stable/dart-io/File-class.html) instances instead of strings.
- Updated the documentation.
- Updated the package dependencies.

## Version [6.6.0](https://github.com/cedx/where.dart/compare/v6.5.0...v6.6.0)
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [6.5.0](https://github.com/cedx/where.dart/compare/v6.4.0...v6.5.0)
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [6.4.0](https://github.com/cedx/where.dart/compare/v6.3.0...v6.4.0)
- Fixed the [issue #5](https://github.com/cedx/where.dart/issues/5): the `FileStat` class does too many I/O calls.
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [6.3.0](https://github.com/cedx/where.dart/compare/v6.2.0...v6.3.0)
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Using new language features: collection if and spread operator.
- Updated the package dependencies.

## Version [6.2.0](https://github.com/cedx/where.dart/compare/v6.1.0...v6.2.0)
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [6.1.0](https://github.com/cedx/where.dart/compare/v6.0.0...v6.1.0)
- Updated the package dependencies.
- Updated the URL of the Git repository.

## Version [6.0.0](https://github.com/cedx/where.dart/compare/v5.1.0...v6.0.0)
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [5.1.0](https://github.com/cedx/where.dart/compare/v5.0.0...v5.1.0)
- Updated the package dependencies.

## Version [5.0.0](https://github.com/cedx/where.dart/compare/v4.4.0...v5.0.0)
- Breaking change: renamed the `FileStats` class to `FileStat`.
- Breaking change: the `FileStat` class now implements the `FileStat` class from `dart:io`.
- Updated the package dependencies.

## Version [4.4.0](https://github.com/cedx/where.dart/compare/v4.3.1...v4.4.0)
- Updated the package dependencies.

## Version [4.3.1](https://github.com/cedx/where.dart/compare/v4.3.0...v4.3.1)
- Fixed a packaging issue.

## Version [4.3.0](https://github.com/cedx/where.dart/compare/v4.2.0...v4.3.0)
- Added the `Options` class, used by the command line interface.
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [4.2.0](https://github.com/cedx/where.dart/compare/v4.1.0...v4.2.0)
- Added an example code.
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Updated the package dependencies.

## Version [4.1.0](https://github.com/cedx/where.dart/compare/v4.0.0...v4.1.0)
- Dropped support of [Node.js](https://nodejs.org) platform.
- Raised the [Dart SDK](https://dart.dev/tools/sdk) constraint.
- Using optional `const` and `new`.
- Updated the package dependencies.

## Version [4.0.0](https://github.com/cedx/where.dart/compare/v3.0.0...v4.0.0)
- Breaking change: starting to use and support the [Dart 2 SDK](https://dart.dev/tools/sdk).
- Added a user guide based on [MkDocs](http://www.mkdocs.org).
- Added the `FinderException` class.
- Updated the package dependencies.

## Version [3.0.0](https://github.com/cedx/where.dart/compare/v2.2.0...v3.0.0)
- Added support for [Node.js](https://nodejs.org) platform.
- Breaking change: removed the `FileStat.stat()` method.
- Breaking change: renamed the `FileStat` class to `FileStats`.
- Added the `fileSystem`, `platform` and `processManager` constants.
- Added the `getFileStats()` function.
- Added the `arguments` and `exitCode` properties.

## Version [2.2.0](https://github.com/cedx/where.dart/compare/v2.1.1...v2.2.0)
- Updated the package dependencies.

## Version [2.1.1](https://github.com/cedx/where.dart/compare/v2.1.0...v2.1.1)
- Fixed a bug: the CLI script doesn't run when using the `pub global run` command.

## Version [2.1.0](https://github.com/cedx/where.dart/compare/v2.0.0...v2.1.0)
- Changed the signature of the `FileStat` class constructor.

## Version [2.0.0](https://github.com/cedx/where.dart/compare/v1.1.0...v2.0.0)
- Breaking change: changed the signature of the `Finder` class constructor.
- Breaking change: removed the `Application` class.
- Breaking change: the `version` property is now private.
- Converted the constructor of the `FileStat` class to a constant one.
- Updated the package dependencies.

## Version [1.1.0](https://github.com/cedx/where.dart/compare/v1.0.0...v1.1.0)
- Changed licensing for the [MIT License](https://opensource.org/licenses/MIT).

## Version [1.0.0](https://github.com/cedx/where.dart/compare/v0.1.0...v1.0.0)
- Added a command line interface.
- Added new unit tests.

## Version 0.1.0
- Initial release.
