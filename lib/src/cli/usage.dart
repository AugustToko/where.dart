part of "../cli.dart";

/// The usage information.
final String usage = (StringBuffer()
	..writeln("Find the instances of an executable in the system path.")..writeln()
	..writeln("Usage: where [options] <command>")..writeln()
	..writeln("Options:")
	..write(argParser.usage))
	.toString();
