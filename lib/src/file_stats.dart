part of where;

/// Provides statistics about a file system entity.
class FileStats {

  /// Creates a new file stats.
  const FileStats({this.uid = -1, this.gid = -1, this.mode = 0});

  /// The numeric identity of the file's group.
  final int gid;

  /// The file permissions.
  final int mode;

  /// The numeric identity of the file's owner.
  final int uid;

  /// Returns the statistics of the specified [file].
  static Future<FileStats> stat(String file) async {
    if (Platform.isWindows) throw UnsupportedError('Not supported by the Windows platform');

    var args = Platform.isMacOS ? ['-f', '%u:%g:%p', '-L'] : ['--dereference', '--format=%u:%g:%a'];
    var result = await Process.run('stat', args..add(file));
    if (result.exitCode != 0) throw ProcessException('stat', args);

    List<String> parts = result.stdout.trim().split(':');
    if (parts.length != 3) throw ProcessException('stat', args);

    return FileStats(
      uid: int.tryParse(parts.first, radix: 10) ?? -1,
      gid: int.tryParse(parts[1], radix: 10) ?? -1,
      mode: int.tryParse(parts.last, radix: 8) ?? 0
    );
  }

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'FileStats {uid: $uid, gid: $gid, mode: 0${mode.toRadixString(8)}}';
}
