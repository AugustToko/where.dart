part of where.core;

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

  /// Returns a [String] representation of this object.
  @override
  String toString() => 'FileStats {uid: $uid, gid: $gid, mode: 0${mode.toRadixString(8)}}';
}
