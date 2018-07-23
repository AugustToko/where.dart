part of where.io;

/// Finds the first instance of a [command] in the system path.
/// An [all] value indicates whether to return a [List] of all executables found, instead of just the first one.
///
/// Completes with a [FinderException] if the specified command was not found on the system path.
/// If a [onError] handler is provided, it is called with the [command] as argument, and its return value is used instead.
///
/// Optional parameters allow to customize the function behavior:
/// - [path]: A string, or a list of strings, specifying the system path. Defaults to the `PATH` environment variable.
/// - [extensions]: A string, or a list of strings, specifying the executable file extensions. Defaults to the `PATHEXT` environment variable.
/// - [pathSeparator]: The character used to separate paths in the system path. Defaults to the platform path separator.
Future where(String command, {bool all = false, Object extensions = '', onError(String command), Object path = '', String pathSeparator = ''}) async {
  var finder = Finder(extensions: extensions, path: path, pathSeparator: pathSeparator);
  var list = <String>[];

  await for (var executable in finder.find(command)) {
    if (!all) return executable;
    list.add(executable);
  }

  if (list.isEmpty) {
    if (onError != null) return onError(command);
    throw FinderException(command, finder, 'Command "$command" not found');
  }

  return all ? Set<String>.from(list).toList() : list.first;
}
