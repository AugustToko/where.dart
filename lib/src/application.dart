part of where;

/// Represents an application providing functionalities specific to console requests.
class Application {

  /// The command line arguments.
  final ArgParser _parser = new ArgParser()
    ..addFlag('all', abbr: 'a', help: 'list all instances of executables found (instead of just the first one)', negatable: false)
    ..addFlag('silent', abbr: 's', help: 'silence the output, just return the exit code (0 if any executable is found, otherwise 1)', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'output usage information', negatable: false)
    ..addFlag('version', abbr: 'v', help: 'output the version number', negatable: false);

  /// Prints the usage information.
  String get usage => (new StringBuffer()
    ..writeln('Find the instances of an executable in the system path.')
    ..writeln()
    ..writeln('Usage:')
    ..writeln('pub global run where [options] <command>')
    ..writeln()
    ..writeln('Options:')
    ..write(_parser.usage))
    .toString();

  /// Runs the application using the specified command line [arguments], and returns its exit code.
  Future<int> run(List<String> arguments) async {
    var results = _parser.parse(arguments);

    if (results['help']) {
      print(usage);
      return 0;
    }

    if (results['version']) {
      print(version);
      return 0;
    }

    if (results.rest.isEmpty) {
      print(usage);
      return 64;
    }

    var paths = await where(results.rest.first, all: results['all']);
    if (!results['silent']) {
      if (paths is! List<String>) paths = [paths];
      paths.forEach(print);
    }

    return 0;
  }
}
