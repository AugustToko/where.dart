import "package:test/test.dart";
import "package:where/where.dart";

/// Tests the features of the [Finder] class.
void main() => group("Finder", () {
	group(".find()", () {
		test("should return the path of the `executable.cmd` file on Windows", () async {
			final executables = await Finder(path: ["test/fixtures"]).find("executable").toList();
			expect(executables.length, Finder.isWindows ? 1 : 0);
			if (Finder.isWindows) expect(executables.first.path, endsWith(r"\test\fixtures\executable.cmd"));
		});

		test("should return the path of the `executable.sh` file on POSIX", () async {
			final executables = await Finder(path: ["test/fixtures"]).find("executable.sh").toList();
			expect(executables.length, Finder.isWindows ? 0 : 1);
			if (!Finder.isWindows) expect(executables.first.path, endsWith("/test/fixtures/executable.sh"));
		});
	});

	group(".isExecutable()", () {
		test("should return `false` for a non-existent file", () async {
			expect(await Finder().isExecutable("foo/doesNotExist.bar"), isFalse);
		});

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
