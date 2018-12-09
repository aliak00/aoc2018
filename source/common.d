module common;

public {
    import std.string;
    import std.algorithm;
    import std.conv;
    import std.range;
    import std.stdio;
    import std.typecons;
}

auto byLine(string input)() {
    return input
        .strip
        .splitter("\n")
        .array;
}
