module day02;
import common;

bool differsInOnePlace(string str1, string str2) {
    return str1.length == str2.length
        && zip(str1, str2)
            .count!(pair => pair[0] != pair[1]) == 1;
}

string pluckCommon(string[] pair) {
    string ret;
    foreach (i, s; pair[0]) {
        if (s == pair[1][i]) {
            ret ~= s;
        }
    }
    return ret;
}

auto solve(string input)() {
    int sum2s = 0;
    int sum3s = 0;

    foreach (line; byLine!input.map!(a => a.array.sort)) {
        auto counts = line.group.map!"a[1]";
        if (counts.canFind!"a == 3") {
            sum3s++;
        }
        if (counts.canFind!"a == 2") {
            sum2s++;
        }
    }

    auto A = sum2s * sum3s;

    auto B = byLine!input
        .sort
        .slide(2)
        .filter!(pair => pair[0].differsInOnePlace(pair[1]))
        .front
        .array
        .pluckCommon;

    return tuple(
        A,
        B,
    );
}
