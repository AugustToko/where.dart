part of "../cli.dart";

/// The parsed command line arguments.
@CliOptions()
class Options {

	/// Value indicating whether to list all instances of executables found, instead of just the first one.
	@CliOption(abbr: "a", help: "List all instances of executables found (instead of just the first one).", negatable: false)
	bool all = false;

	/// Value indicating whether to output usage information.
	@CliOption(abbr: "h", help: "Output usage information.", negatable: false)
	bool help = false;

	/// The remaining command-line arguments that were not parsed as options or flags.
	List<String> rest = <String>[];

	/// Value indicating whether to silence the output, and just return the exit code.
	@CliOption(abbr: "s", help: "Silence the output, just return the exit code (0 if any executable is found, otherwise 1).", negatable: false)
	bool silent = false;

	/// Value indicating whether to output the version number.
	@CliOption(abbr: "v", help: "Output the version number.", negatable: false)
	bool version = false;
}
