module day05;
import common;

auto react(string data) {
    import std.math: abs;
    import std.conv: to;
    return data.fold!((m, a) {
        if (!m.empty && (cast(int)m.back - cast(int)a).abs == 32) {
            return m.dropBack(1);
        } else {
            return m ~ a.to!string;
        }
    })(data[0..0]);
};

auto solve(string input)() {
    auto A = input
        .react
        .length;

    auto B = 'a'.iota('z')
        .map!(l => input
            .filter!(a => a != l && a != (l - 32))
            .to!string
            .react
            .length
        )
        .fold!min;

    return tuple(
        A,
        B,
    );
}