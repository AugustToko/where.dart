path: blob/master
source: lib/src/cli/options.dart

# Command line interface
From a command prompt, install the `where` executable:

```shell
pub global activate where
```

!!! tip
    Consider adding the [`pub global`](https://dart.dev/tools/pub/cmd/pub-global) executables directory to your system path.

Then use it to find the instances of an executable command:

```shell
$ where --help

Find the instances of an executable in the system path.

Usage: where [options] <command>

Options:
-a, --all        List all instances of executables found (instead of just the first one)
-s, --silent     Silence the output, just return the exit code (0 if any executable is found, otherwise 1)
-h, --help       Output usage information
-v, --version    Output the version number
```

For example:

```shell
where --all dart
# /usr/bin/dart
```
