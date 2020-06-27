part of "../io.dart";

/// Finds the instances of an executable in the system path.
class Finder {

	/// Creates a new finder from the following parameters:
	/// - [extensions]: A string, or a list of strings, specifying the executable file extensions. Defaults to the `PATHEXT` environment variable.
	/// - [path]: A string, or a list of strings, specifying the system path. Defaults to the `PATH` environment variable.
	Finder({List<String> extensions, List<String> path}) {
		final pathSeparator = isWindows ? ";" : ":";

		if (path is! List) path = path.toString().split(pathSeparator)..retainWhere((item) => item.isNotEmpty);
		if (path.isEmpty) {
			final pathEnv = io.Platform.environment["PATH"] ?? "";
			if (pathEnv.isNotEmpty) path = pathEnv.split(pathSeparator);
		}

		if (extensions is! List) extensions = extensions.toString().split(pathSeparator)..retainWhere((item) => item.isNotEmpty);
		if (extensions.isEmpty && isWindows) {
			final pathExt = io.Platform.environment["PATHEXT"] ?? "";
			extensions = pathExt.isNotEmpty ? pathExt.split(pathSeparator) : [".exe", ".cmd", ".bat", ".com"];
		}

		this.extensions.addAll(List<String>.from(extensions.map((extension) => extension.toLowerCase())));
		this.path.addAll(List<String>.from(path.map((directory) => directory.replaceAll(RegExp(r'^"+|"+$'), ""))));
	}

	/// The list of executable file extensions.
	final List<String> extensions = <String>[];

	/// Value indicating whether the current platform is Windows.
	static bool get isWindows {
		if (io.Platform.isWindows) return true;
		return io.Platform.environment["OSTYPE"] == "cygwin" || io.Platform.environment["OSTYPE"] == "msys";
	}

	/// The list of system paths.
	final List<String> path = <String>[];

	/// Finds the instances of the specified [command] in the system path.
	Stream<io.File> find(String command) async* {
		for (final directory in path) yield* _findExecutables(directory, command);
	}

	/// Gets a value indicating whether the specified [file] is executable.
	Future<bool> isExecutable(String file) async {
		final type = io.FileSystemEntity.typeSync(file);
		if (type != io.FileSystemEntityType.file && type != io.FileSystemEntityType.link) return false;
		return isWindows ? _checkFileExtension(file) : _checkFilePermissions(await FileStat.stat(file));
	}

	/// Checks that the specified [file] is executable according to the executable file extensions.
	bool _checkFileExtension(String file) =>
		extensions.contains(p.extension(file).toLowerCase()) || extensions.contains(file.toLowerCase());

	/// Checks that the file referenced by the specified [fileStats] is executable according to its permissions.
	Future<bool> _checkFilePermissions(FileStat fileStats) async {
		// Others.
		final perms = fileStats.mode;
		if (perms & int.parse("001", radix: 8) != 0) return true;

		// Group.
		final execByGroup = int.parse("010", radix: 8);
		if (perms & execByGroup != 0) return fileStats.gid == await _getProcessId("g");

		// Owner.
		final execByOwner = int.parse("100", radix: 8);
		final userId = await _getProcessId("u");
		if (perms & execByOwner != 0) return fileStats.uid == userId;

		// Root.
		return (perms & (execByOwner | execByGroup) != 0) && userId == 0;
	}

	/// Finds the instances of a [command] in the specified [directory].
	Stream<io.File> _findExecutables(String directory, String command) async* {
		for (final extension in ["", ...extensions]) {
			final resolvedPath = p.canonicalize("${p.join(directory, command)}${extension.toLowerCase()}");
			if (await isExecutable(resolvedPath)) yield io.File(resolvedPath);
		}
	}

	/// Gets a numeric [identity] of the process.
	Future<int> _getProcessId(String identity) async {
		if (isWindows) return -1;
		final result = await io.Process.run("id", ["-$identity"]);
		return result.exitCode != 0 ? -1 : int.tryParse(result.stdout.trim(), radix: 10) ?? -1;
	}
}

/// An exception caused by a [Finder] in a command lookup.
class FinderException implements io.IOException {

	/// Creates a new finder exception.
	FinderException(this.command, this.finder, [String message]):
		message = message ?? "Command '$command' not found.";

	/// The looked up command.
	final String command;

	/// The finder used to lookup the command.
	final Finder finder;

	/// A message describing the error.
	final String message;
}
