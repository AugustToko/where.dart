part of where;

/// Finds the instances of an executable in the system path.
class Finder {

  /// Creates a new finder from the following parameters:
  /// - [path]: the list of system paths.
  /// - [extensions]: the list of executable file extensions.
  /// - [pathSeparator]: the character used to separate paths in the system path.
  Finder({List<String> path, List<String> extensions, this.pathSeparator = ''}): path = path ?? [], extensions = extensions ?? [] {
    if (pathSeparator.isEmpty) pathSeparator = isWindows ? ';' : Platform.pathSeparator;

    if (this.path.isEmpty && Platform.environment.containsKey('PATH')) {
      var pathEnv = Platform.environment['PATH'];
      if (pathEnv.isNotEmpty) this.path.addAll(pathEnv.split(pathSeparator).map((directory) => directory.replaceAll(new RegExp(r'^"+|"+$'), '')));
    }

    if (this.extensions.isEmpty && isWindows) {
      var pathExt = Platform.environment.containsKey('PATHEXT') ? Platform.environment['PATHEXT'] : '';
      var fileExtensions = pathExt.isNotEmpty ? pathExt.split(pathSeparator) : ['.exe', '.cmd', '.bat', '.com'];
      this.extensions.addAll(fileExtensions.map((extension) => extension.toUpperCase()));
    }
  }

  /// The list of executable file extensions.
  final List<String> extensions;

  /// Value indicating whether the current platform is Windows.
  static bool get isWindows {
    if (Platform.isWindows) return true;
    return Platform.environment['OSTYPE'] == 'cygwin' || Platform.environment['OSTYPE'] == 'msys';
  }

  /// The list of system paths.
  final List<String> path;

  /// The character used to separate paths in the system path.
  String pathSeparator;

  /// TODO
  int _processGid = -1;

  /// TODO
  int _processUid = -1;

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
    print('isExecutable: "$file"');
    return isWindows ? _checkFileExtension(file) : _checkFilePermissions(await FileStat.stat(file));
  }

  /// Checks that the specified [file] is executable according to the executable file extensions.
  bool _checkFileExtension(String file) =>
    extensions.contains(p.extension(file).toUpperCase()) || extensions.contains(file.toUpperCase());

  /// Checks that the file referenced by the specified [fileStats] is executable according to its permissions.
  Future<bool> _checkFilePermissions(FileStat fileStats) async {
    print('fileStats: $fileStats');

    // Others.
    var perms = fileStats.mode;
    if (perms & int.parse('001', radix: 8) != 0) return true;

    // Group.
    var execByGroup = int.parse('010', radix: 8);
    if (_processGid < 0) _processGid = await _getProcessGid();
    if (perms & execByGroup != 0) return _processGid == fileStats.gid;

    // Owner.
    var execByOwner = int.parse('100', radix: 8);
    if (_processUid < 0) _processUid = await _getProcessUid();
    if (perms & execByOwner != 0) return _processUid == fileStats.uid;

    // Root.
    return perms & (execByOwner | execByGroup) != 0 ? _processUid == 0 : false;
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

  /// Returns the numeric identity of the process's group, or `-1` if an error occurred.
  Future<int> _getProcessGid() async {
    if (isWindows) return -1;

    var result = await Process.run('id', ['-g']);
    return result.exitCode != 0 ? -1 : int.parse(result.stdout.trim(), radix: 10, onError: (_) => -1);
  }

  /// Returns the numeric identity of the process's owner, or `-1` if an error occurred.
  Future<int> _getProcessUid() async {
    if (isWindows) return -1;

    var result = await Process.run('id', ['-u']);
    return result.exitCode != 0 ? -1 : int.parse(result.stdout.trim(), radix: 10, onError: (_) => -1);
  }
}
