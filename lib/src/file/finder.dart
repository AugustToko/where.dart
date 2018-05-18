part of where.file;

/// Finds the instances of an executable in the system path.
class Finder {

  /// Creates a new finder from the following parameters:
  /// - [extensions]: A string, or a list of strings, specifying the executable file extensions. Defaults to the `PATHEXT` environment variable.
  /// - [path]: A string, or a list of strings, specifying the system path. Defaults to the `PATH` environment variable.
  /// - [pathSeparator]: The character used to separate paths in the system path. Defaults to the platform path separator.
  Finder({extensions = '', path = '', this.pathSeparator = ''}) {
    if (pathSeparator.isEmpty) pathSeparator = isWindows ? ';' : ':';

    if (path is! List<String>) path = path.toString().split(pathSeparator)..retainWhere((item) => item.isNotEmpty);
    if (path.isEmpty) {
      var pathEnv = platform.environment['PATH'] ?? '';
      if (pathEnv.isNotEmpty) path = pathEnv.split(pathSeparator);
    }

    if (extensions is! List<String>) extensions = extensions.toString().split(pathSeparator)..retainWhere((item) => item.isNotEmpty);
    if (extensions.isEmpty && isWindows) {
      var pathExt = platform.environment['PATHEXT'] ?? '';
      extensions = pathExt.isNotEmpty ? pathExt.split(pathSeparator) : ['.exe', '.cmd', '.bat', '.com'];
    }

    this.extensions.addAll(extensions.map((extension) => extension.toLowerCase()));
    this.path.addAll(path.map((directory) => directory.replaceAll(new RegExp(r'^"+|"+$'), '')));
  }

  /// The list of executable file extensions.
  final List<String> extensions = [];

  /// Value indicating whether the current platform is Windows.
  static bool get isWindows {
    if (platform.isWindows) return true;
    return platform.environment['OSTYPE'] == 'cygwin' || platform.environment['OSTYPE'] == 'msys';
  }

  /// The list of system paths.
  final List<String> path = [];

  /// The character used to separate paths in the system path.
  String pathSeparator;

  /// Finds the instances of the specified [command] in the system path.
  Stream<String> find(String command) async* {
    for (var directory in path) yield* _findExecutables(directory, command);
  }

  /// Gets a value indicating whether the specified [file] is executable.
  Future<bool> isExecutable(String file) async {
    var type = await fileSystem.type(file);
    if (type != FileSystemEntityType.file && type != FileSystemEntityType.link) return false;
    return isWindows ? _checkFileExtension(file) : _checkFilePermissions(await getFileStats(file));
  }

  /// Checks that the specified [file] is executable according to the executable file extensions.
  bool _checkFileExtension(String file) =>
    extensions.contains(fileSystem.path.extension(file).toLowerCase()) || extensions.contains(file.toLowerCase());

  /// Checks that the file referenced by the specified [fileStats] is executable according to its permissions.
  Future<bool> _checkFilePermissions(FileStats fileStats) async {
    // Others.
    var perms = fileStats.mode;
    if (perms & int.parse('001', radix: 8) != 0) return true;

    // Group.
    var execByGroup = int.parse('010', radix: 8);
    if (perms & execByGroup != 0) return fileStats.gid == await processGid;

    // Owner.
    var execByOwner = int.parse('100', radix: 8);
    var userId = await processUid;
    if (perms & execByOwner != 0) return fileStats.uid == userId;

    // Root.
    return (perms & (execByOwner | execByGroup) != 0) && userId == 0;
  }

  /// Finds the instances of a [command] in the specified [directory].
  Stream<String> _findExecutables(String directory, String command) async* {
    final path = fileSystem.path;
    for (var extension in ['']..addAll(extensions)) {
      var resolvedPath = path.canonicalize('${path.join(directory, command)}${extension.toLowerCase()}');
      if (await isExecutable(resolvedPath)) yield resolvedPath;
    }
  }
}

/// An exception caused by a [Finder] in a command lookup.
class FinderException implements IOException {

  /// Creates a new finder exception.
  FinderException(this.command, this.finder, [this.message = '']);

  /// The looked up command.
  final String command;

  /// The finder used to lookup the command.
  final Finder finder;

  /// A message describing the error.
  final String message;

  /// Returns a string representation of this object.
  @override
  String toString() {
    var buffer = new StringBuffer('FinderException("$command"');
    if (finder.path.isNotEmpty) buffer.write(', finder: "${finder.path.join(finder.pathSeparator)}"');
    if (message.isNotEmpty) buffer.write(', message: "$message"');
    buffer.write(')');
    return buffer.toString();
  }
}
