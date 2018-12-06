import std.stdio: writeln;
import std.format;

enum day = 2;

immutable input = import(day.format!"%02d.txt");

mixin("import day%02d;".format(day));

void main() {
	solve!input.writeln;
}
