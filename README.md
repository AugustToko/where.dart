# Where.dart
![Runtime](https://img.shields.io/badge/dart-%3E%3D1.24-brightgreen.svg) ![Release](https://img.shields.io/pub/v/where.svg) ![License](https://img.shields.io/badge/license-MIT-blue.svg) ![Coverage](https://coveralls.io/repos/github/cedx/where.dart/badge.svg) ![Build](https://travis-ci.org/cedx/where.dart.svg)

Find the instances of an executable in the system path, implemented in in [Dart](https://www.dartlang.org).

## Requirements
The latest [Dart SDK](https://www.dartlang.org) and [Pub](https://pub.dartlang.org) versions.
If you plan to play with the sources, you will also need the latest [Grinder](http://google.github.io/grinder.dart) version.

## Installing via [Pub](https://pub.dartlang.org)

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  file: *
  where: *
```

### 2. Install it
Install this package and its dependencies from a command prompt:

```shell
$ pub get
```

### 3. Import it
Now in your [Dart](https://www.dartlang.org) code, you can use:

```dart
import 'package:file/file.dart' show FileSystemException;
import 'package:where/where.dart' show where;
```

## Usage
This package provides a single function, `where()`, allowing to locate a command in the system path:

```dart
try {
  // "path" is the absolute path to the executable.
  var path = await where('foobar');
  print('The "foobar" command is located at: $path');
}

on FileSystemException {
  // The command was not found on the system path.
  print('The "foobar" command is not found.');
}
```

The function returns a [`Future<String>`](https://api.dartlang.org/stable/dart-async/Future-class.html) specifying the path of the first instance of the executables found. If the command could not be located, a [`FileSystemException`](https://api.dartlang.org/stable/dart-io/FileSystemException-class.html) is thrown.

## Options
The behavior of the `where()` function can be customized using the following optional named parameters.

### `bool all = false`
A value indicating whether to return all executables found, instead of just the first one.

If you pass `true` as parameter value, the function will return a `Future<List<String>>` providing all paths found, instead of a `Future<String>`:

```dart
var paths = await where('foobar', all: true);

print('The "foobar" command was found at these locations:');
for (var path in paths) print(path);
```

### `String|List<String> extensions = ""`
The executable file extensions, provided as a string or a list of file extensions. Defaults to the list of extensions provided by the `PATHEXT` environment variable.

The `extensions` option is only meaningful on the Windows platform, where the executability of a file is determined from its extension:

```dart
where('foobar', extensions: '.FOO;.EXE;.CMD');
```

### `dynamic onError(String command)`
By default, when the specified command cannot be located, a `FileSystemException` is thrown. You can disable this exception by providing your own error handler:

```dart
var path = await where('foobar', onError: (_) => '');

if (path.isEmpty) print('The "foobar" command is not found.');
else print('The "foobar" command is located at: $path');
```

When an `onError` handler is provided, it is called with the command as argument, and its return value is used instead. This is preferable to throwing and then immediately catching the `FileSystemException`.

### `String|List<String> path = ""`
The system path, provided as a string or a list of directories. Defaults to the list of paths provided by the `PATH` environment variable.

```dart
where('foobar', path: ['/usr/local/bin', '/usr/bin']);
```

### `String pathSeparator = ""`
The character used to separate paths in the system path. Defaults to the platform path separator (e.g. `";"` on Windows, `":"` on other platforms).

```dart
where('foobar', pathSeparator: '#');
```

## Command line interface
From a command prompt, install the `where` executable:

```shell
$ pub global activate where
```

> Consider adding the [`pub global`](https://www.dartlang.org/tools/pub/cmd/pub-global) executables directory to your system path.

Then use it to find the instances of an executable:

```shell
$ where --help

Find the instances of an executable in the system path.

Usage:
where [options] <command>

Options:
-a, --all        list all instances of executables found (instead of just the first one)
-s, --silent     silence the output, just return the exit code (0 if any executable is found, otherwise 1)
-h, --help       output usage information
-v, --version    output the version number
```

For example:

```shell
$ where --all dart
```

### Node.js support
This package supports the [Node.js](https://nodejs.org) platform.
A JavaScript executable can be generated using the following [Grinder](http://google.github.io/grinder.dart) command:

```shell
$ grind
```

This command will build a `where.js` file in the `bin` folder of this package.
The generated executable has the same features as the [Dart](https://www.dartlang.org) command line:

```shell
$ node bin/where.js --help
$ node bin/where.js --all dart
```

## See also
- [API reference](https://cedx.github.io/where.dart)
- [Code coverage](https://coveralls.io/github/cedx/where.dart)
- [Continuous integration](https://travis-ci.org/cedx/where.dart)

## License
[Where.dart](https://github.com/cedx/where.dart) is distributed under the MIT License.
