part of where;

///
Future where(String command, {bool all = true, path = '', extensions = '', String pathSeparator = ''}) async {
  var finder = new Finder(pathSeparator: pathSeparator);
  if (path is String && path.isNotEmpty) {

  }

  if (extensions is String) extensions = extensions.isEmpty ? [] : extensions.split();

  var paths = await finder.find(command, all: all);
  return all ? paths : paths.first;
}
