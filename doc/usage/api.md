---
path: src/branch/main
source: lib/src/io/where.dart
---

# Application programming interface
This package provides a single function, `where()`, allowing to locate a command in the system path:

``` dart
import "package:where/where.dart";

Future<void> main() async {
	try {
		// `path` is the absolute path to the executable.
		final path = await where("foobar");
		print("The command 'foobar' is located at: $path");
	}

	on FinderException catch (err) {
		print("The command '${err.command}' is not found");
	}
}
```

The function returns a [`Future<String>`](https://api.dart.dev/stable/dart-async/Future-class.html) that completes with the absolute path of the first instance of the executables found. If the command could not be located, the future completes with a `FinderException`.

## Options
The behavior of the `where()` function can be customized using the following optional named parameters.

### bool **all**
A value indicating whether to return all executables found, instead of just the first one.

If you pass `true` as parameter value, the function will return a `Future<List<String>>` providing all paths found, instead of a `Future<String>`:

``` dart
import "package:where/where.dart";

Future<void> main() async {
	final paths = await where("foobar", all: true);
	print("The command 'foobar' was found at these locations:");
	for (final path in paths) print(path);
}
```

### String | List&lt;String&gt; **extensions**
The executable file extensions, provided as a string or a list of file extensions. Defaults to the list of extensions provided by the `PATHEXT` environment variable.

``` dart
where("foobar", extensions: ".FOO;.EXE;.CMD");
where("foobar", extensions: [".foo", ".exe", ".cmd"]);
```

!!! tip
	The `extensions` option is only meaningful on the Windows platform,
	where the executability of a file is determined from its extension.

### dynamic **onError**(String command)
By default, when the specified command cannot be located, a `FinderException` is thrown. You can disable this exception by providing your own error handler:

``` dart
import "package:where/where.dart";

Future<void> main() async {
	final path = await where("foobar", onError: (command) => "");
	if (path.isEmpty) print("The command 'foobar' was not found");
	else print("The command 'foobar' is located at: $path");
}
```

When an `onError` handler is provided, it is called with the command as argument, and its return value is used instead. This is preferable to throwing and then immediately catching the `FinderException`.

### String | List&lt;String&gt; **path**
The system path, provided as a string or a list of directories. Defaults to the list of paths provided by the `PATH` environment variable.

``` dart
where("foobar", path: "/usr/local/bin:/usr/bin");
where("foobar", path: ["/usr/local/bin", "/usr/bin"]);
```
