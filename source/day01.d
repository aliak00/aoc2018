module day01;
import common;

auto solve(string input)() {
    enum ints = byLine!input
        .map!(to!int);

    auto A = ints.sum;

    bool[int] set;
    auto B = ints
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
