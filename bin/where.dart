#!/usr/bin/env dart

// ignore_for_file: avoid_print
import "dart:io";
import "package:where/where.dart";
import "package:where/src/cli.dart";
import "package:where/src/version.dart";

/// Application entry point.
Future<void> main(List<String> args) async {
	// Parse the command line arguments.
	Options options;

	try {
		options = parseOptions(args);
		if (options.help) return print(usage);
		if (options.version) return print(packageVersion);
		if (options.rest.isEmpty) throw const FormatException("A command must be provided.");
	}

	on FormatException {
		print(usage);
		exitCode = 64;
		return;
	}

	// Run the program.
	try {
		var executables = await where(options.rest.first, all: options.all);
		if (!options.silent) {
			if (executables is String) executables = <String>[executables];
			executables.forEach(print);
		}
	}

	on FinderException catch (e) {
		if (!options.silent) print('No "${options.rest.first}" in (${e.finder.path.join(Finder.isWindows ? ";" : ":")}).');
		exitCode = 1;
	}

	on Exception catch (e) {
		print(e);
		exitCode = 2;
	}
}
