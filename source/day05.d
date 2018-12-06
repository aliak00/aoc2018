module day05;
import common;

import std.math: abs;
import std.conv: to;

auto reactsTo(int a, int b) {
    return (a - b).abs == 32;
}

template solveA(string data) {
    auto solveA() {
        auto a = data.fold!((m, a) {
            m ~= a.to!string;
            if (m.length > 1 && m[$-1].reactsTo(m[$-2])) {
                return m[0 .. $-2];
            } 
            return m;
        })("");
        return a.length;
    }
}

template solveB(string data) {
    auto solveB() {
        return "b";
    }
}