part of where;

/// Finds the first instance of a [command] in the system path.
/// An [all] value indicates whether to return a list of all executables found, instead of just the first one.
///
/// Throws a [FileSystemException] if
/// Optional parameters allow to customize the behavior:
/// - [path]: A string, or a list of strings, specifying the system path. Defaults to the `PATH` environment variable.
/// - [extensions]: A string, or a list of strings, specifying the executable file extensions. Defaults to the `PATHEXT` environment variable.
/// - [pathSeparator]: The character used to separate paths in the system path. Defaults to the platform path separator.
Future where(String command, {bool all = true, path = '', extensions = '', String pathSeparator = ''}) async {
  var list = [];
  await for (var executable in new Finder(path, extensions, pathSeparator).find(command)) {
    if (!all) return executable;
    list.add(executable);
  }

  if (list.isEmpty) throw new FileSystemException('Command not found.', command);
  return all ? list : list.first;

  /* TODO ???
  try {
    var executables = new Finder(path, extensions, pathSeparator).find(command);
    return all ? executables.toList() : executables.first;
  }

  on Exception {
    throw new FileSystemException('Command not found.', command);
  }
  */
}
