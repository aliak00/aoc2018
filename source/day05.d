module day05;
import common;

import std.math: abs;
import std.conv: to;

auto reactsTo(int a, int b) {
    return (a - b).abs == 32;
}

alias react = (string data) {
    return data.fold!((m, a) {
        if (!m.empty && m.back.reactsTo(a)) {
            return m.dropBack(1);
        } else {
            return m ~ a.to!string;
        }
    })(data[0..0]);
};

template solveA(string data) {
    auto solveA() {
        return data.react.length;
    }
}

template solveB(string data) {
    auto solveB() {
        return 'a'.iota('z')
            .map!(l => data
                .filter!(a => a != l && a != (l - 32))
                .to!string
                .react
                .length
            )
            .fold!min;
    }
}