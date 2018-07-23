part of where.cli;

/// The parsed command line arguments.
@CliOptions()
class Options {

  /// Value indicating whether to list all instances of executables found, instead of just the first one.
  @CliOption(abbr: 'a', help: 'List all instances of executables found (instead of just the first one).', negatable: false)
  final bool all;

  /// Value indicating whether to output usage information.
  @CliOption(abbr: 'h', help: 'Output usage information.', negatable: false)
  final bool help;

  /// The remaining command-line arguments that were not parsed as options or flags.
  final List<String> rest;

  /// Value indicating whether to silence the output, and just return the exit code.
  @CliOption(abbr: 's', help: 'Silence the output, just return the exit code (0 if any executable is found, otherwise 1).', negatable: false)
  final bool silent;

  /// Value indicating whether to output the version number.
  @CliOption(abbr: 'v', help: 'Output the version number.', negatable: false)
  final bool version;

  /// Creates a new options object.
  Options({this.all, this.help, this.rest, this.silent, this.version});
}
