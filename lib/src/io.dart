/// Provides the I/O support.
library where.io;

export 'io/vm.dart'
  if (dart.library.js) 'io/node.dart';
