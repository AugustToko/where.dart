# Command line interface
From a command prompt, install the `where` executable:

```shell
pub global activate where
```

!!! tip
    Consider adding the [`pub global`](https://www.dartlang.org/tools/pub/cmd/pub-global) executables directory to your system path.

Then use it to find the instances of an executable command:

```shell
where --help

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
where --all dart
# /usr/bin/dart
```

### Node.js support
This package supports the [Node.js](https://nodejs.org) platform.
A JavaScript executable can be generated using the following [Grinder](http://google.github.io/grinder.dart) command:

```shell
pub run grinder
```

This command will build a `where.js` file in the `bin` folder of this package.
The generated executable has the same features as the [Dart](https://www.dartlang.org) command line:

```shell
node bin/where.js --help
node bin/where.js --all dart
```

!!! info
    Node.js support is provided through the [`nodejs_interop`](https://pub.dartlang.org/packages/nodejs_interop) library.
