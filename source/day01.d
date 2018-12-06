module day01;
import common;

auto solve(string input)() {
    auto lines = input
        .strip
        .splitter("\n")
        .map!(to!int);

    auto A = lines.sum;

    bool[int] set;
    auto B = lines
        .cycle
        .cumulativeFold!"a + b"
        .tee!(a => set[a] = true)
        .filter!(a => a in set)
        .front;

    return tuple(
        A,
        B,
    );
}
