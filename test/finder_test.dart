import "dart:io";
import "package:test/test.dart";
import "package:where/where.dart";

/// Tests the features of the [Finder] class.
void main() => group("Finder", () {
	final delimiter = Finder.isWindows ? ";" : ":";

	group("constructor", () {
		test("should set the `path` property to the value of the `PATH` environment variable by default", () {
			final pathEnv = Platform.environment["PATH"] ?? "";
			final path = pathEnv.isEmpty ? <String>[] : pathEnv.split(delimiter);
			expect(Finder().path, orderedEquals(path));
		});

		test("should split the input path using the path separator", () {
			final path = ["/usr/local/bin", "/usr/bin"];
			expect(Finder(path: path.join(delimiter)).path, orderedEquals(path));
		});

		test("should set the `extensions` property to the value of the `PATHEXT` environment variable by default", () {
			final pathExt = Platform.environment["PATHEXT"] ?? "";
			final extensions = pathExt.isEmpty ? <String>[] : pathExt.split(delimiter).map((item) => item.toLowerCase());
			expect(Finder().extensions, orderedEquals(extensions));
		});

		test("should split the extension list using the path separator", () {
			final extensions = [".EXE", ".CMD", ".BAT"];
			expect(Finder(extensions: extensions.join(delimiter)).extensions, orderedEquals([".exe", ".cmd", ".bat"]));
		});

		test("should set the `pathSeparator` property to the value of the platform path separator by default", () {
			expect(Finder().pathSeparator, delimiter);
		});

		test("should properly set the path separator", () {
			expect(Finder(pathSeparator: "#").pathSeparator, "#");
		});
	});

	group(".find()", () {
		test("should return the path of the `executable.cmd` file on Windows", () async {
			final executables = await Finder(path: "test/fixtures").find("executable").toList();
			expect(executables.length, Finder.isWindows ? 1 : 0);
			if (Finder.isWindows) expect(executables.first.path, endsWith(r"\test\fixtures\executable.cmd"));
		});

		test("should return the path of the `executable.sh` file on POSIX", () async {
			final executables = await Finder(path: "test/fixtures").find("executable.sh").toList();
			expect(executables.length, Finder.isWindows ? 0 : 1);
			if (!Finder.isWindows) expect(executables.first.path, endsWith("/test/fixtures/executable.sh"));
		});
	});

	group(".isExecutable()", () {
		test("should return `false` for a non-executable file", () async {
			expect(await Finder().isExecutable("test/where_test.dart"), isFalse);
		});

		test("should return `false` for a POSIX executable, when test is run on Windows", () async {
			expect(await Finder().isExecutable("test/fixtures/executable.sh"), isNot(Finder.isWindows));
		});

		test("should return `false` for a Windows executable, when test is run on POSIX", () async {
			expect(await Finder().isExecutable("test/fixtures/executable.cmd"), Finder.isWindows);
		});
	});
});
