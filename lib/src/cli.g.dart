// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cli.dart';

// **************************************************************************
// CliGenerator
// **************************************************************************

Options _$parseOptionsResult(ArgResults result) => Options()
  ..all = result['all'] as bool
  ..help = result['help'] as bool
  ..rest = result.rest
  ..silent = result['silent'] as bool
  ..version = result['version'] as bool;

ArgParser _$populateOptionsParser(ArgParser parser) => parser
  ..addFlag('all',
      abbr: 'a',
      help:
          'List all instances of executables found (instead of just the first one).',
      negatable: false)
  ..addFlag('help',
      abbr: 'h', help: 'Output usage information.', negatable: false)
  ..addFlag('silent',
      abbr: 's',
      help:
          'Silence the output, just return the exit code (0 if any executable is found, otherwise 1).',
      negatable: false)
  ..addFlag('version',
      abbr: 'v', help: 'Output the version number.', negatable: false);

final _$parserForOptions = _$populateOptionsParser(ArgParser());

Options parseOptions(List<String> args) {
  final result = _$parserForOptions.parse(args);
  return _$parseOptionsResult(result);
}
