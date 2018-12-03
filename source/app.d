import std.stdio: writeln;
import std.format;

enum day = 3;
enum part = "B";

immutable input = import(day.format!"%02d.txt");

mixin("import day%02d;".format(day));

void main() {
	writeln(mixin("solve%s!input".format(part)));
}
