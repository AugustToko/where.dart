part of where;

/// Finds the instances of an executable in the system path.
class Finder {

  /// Value indicating whether the current platform is Windows.
  static final bool isWindows = _isWindows;

  /// Creates a new finder from the following parameters:
  /// - [paths]: the list of system paths.
  /// - [pathExtensions]: the list of executable file extensions.
  /// - [pathSeparator]: the character used to separate paths in the system path.
  Finder({List<String> paths, List<String> pathExtensions, this.pathSeparator = ''}): path = paths ?? [], extensions = pathExtensions ?? [] {
    if (pathSeparator.isEmpty) pathSeparator = isWindows ? ';' : Platform.pathSeparator;

    if (path.isEmpty && Platform.environment.containsKey('PATH')) {
      var pathEnv = Platform.environment['PATH'];
      if (pathEnv.isNotEmpty) path.addAll(pathEnv.split(pathSeparator).map((directory) => directory.replaceAll(new RegExp(r'^"+|"+$'), '')));
    }

    if (extensions.isEmpty && isWindows) {
      var pathExt = Platform.environment.containsKey('PATHEXT') ? Platform.environment['PATHEXT'] : '';
      var fileExtensions = pathExt.isNotEmpty ? pathExt.split(pathSeparator) : ['.exe', '.cmd', '.bat', '.com'];
      extensions.addAll(fileExtensions.map((extension) => extension.toUpperCase()));
    }
  }

  /// The list of executable file extensions.
  final List<String> extensions;

  /// The list of system paths.
  final List<String> path;

  /// The character used to separate paths in the system path.
  String pathSeparator;

  /// Finds the instances of the specified [command] in the system path.
  /// An [all] value indicates whether to return all the instances found, or only the first one.
  Future<List<String>> find(String command, {bool all = true}) async {
    var paths = [];
    for (var directory in path) {
      paths.addAll(await _findExecutables(directory, command, all: all));
      if (!all) break;
    }

    return paths;
  }

  /// Gets a value indicating whether the specified [file] is executable.
  Future<bool> isExecutable(String file) async {
    if (!await FileSystemEntity.isFile(file)) return false;
    return isWindows ? _checkFileExtension(file) : _checkFilePermissions(file);
  }

  /// Checks that the specified [file] is executable according to the executable file extensions.
  bool _checkFileExtension(String file) =>
    extensions.contains(p.extension(file).toUpperCase()) || extensions.contains(file.toUpperCase());

  /// Checks that the specified [file] is executable according to its permissions.
  Future<bool> _checkFilePermissions(String file) async {
    await syscall.loadLibrary();
    var fileStats = syscall.stat(file);

    // Others.
    var perms = fileStats.mode;
    if (perms & syscall.FileModes.EXECUTE_BY_OTHERS != 0) return true;

    // Group.
    var gid = isWindows ? -1 : syscall.getGroupId();
    if (perms & syscall.FileModes.EXECUTE_BY_GROUP != 0) return gid == fileStats.gid;

    // Owner.
    var uid = isWindows ? -1 : syscall.getUserId();
    if (perms & syscall.FileModes.EXECUTE_BY_OWNER != 0) return uid == fileStats.uid;

    // Root.
    return perms & (syscall.FileModes.EXECUTE_BY_OWNER | syscall.FileModes.EXECUTE_BY_GROUP) != 0 ? uid == 0 : false;
  }

  /// Finds the instances of a [command] in the specified [directory].
  /// An [all] value indicates whether to return all the instances found, or only the first one.
  Future<List<String>> _findExecutables(String directory, String command, {bool all = true}) async {
    var paths = [];
    for (var extension in ['']..addAll(extensions)) {
      var resolvedPath = p.canonicalize('${p.join(directory, command)}${extension.toLowerCase()}');
      if (await isExecutable(resolvedPath)) {
        paths.add(resolvedPath);
        if (!all) break;
      }
    }

    return paths;
  }
}
