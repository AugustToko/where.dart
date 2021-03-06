part of "../io.dart";

/// Finds the first instance of a [command] in the system path.
/// An [all] value indicates whether to return a [List] of all executables found, instead of just the first one.
///
/// Completes with a [FinderException] if the specified command was not found on the system path.
/// If a [onError] handler is provided, it is called with the [command] as argument, and its return value is used instead.
///
/// Optional parameters allow to customize the function behavior:
/// - [path]: A list of strings specifying the system path. Defaults to the `PATH` environment variable.
/// - [extensions]: A list of strings specifying the executable file extensions. Defaults to the `PATHEXT` environment variable.
Future where(String command, {bool all = false, List<String>? extensions, Function(String command)? onError, List<String>? path}) async {
	final finder = Finder(extensions: extensions, path: path);
	final list = <String>[];

	await for (final executable in finder.find(command)) {
		if (!all) return executable.path;
		list.add(executable.path);
	}

	if (list.isEmpty) {
		if (onError != null) return onError(command);
		throw FinderException(command, finder, "Command '$command' not found");
	}

	return Set<String>.from(list).toList();
}
