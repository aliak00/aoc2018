module day02;
import common;

template process(string data) {
    enum process = data
        .strip
        .splitter("\n")
        .array;
}

template solveA(string data) {

    alias sort = (a) => std.algorithm.sort(a.array);

    auto solveA() {
        int sum2s = 0;
        int sum3s = 0;
        foreach (line; process!data.map!sort) {
            auto grouped = line.group;
            
            if (!grouped.filter!(tup => tup[1] == 2).empty) {
                sum3s++;
            }

            if (!grouped.filter!(tup => tup[1] == 3).empty) {
                sum2s++;
            }
        }
        return sum2s * sum3s;
    }
}

template solveB(string data) {

    bool differsInOnePlace(string str1, string str2) {
        if (str1.length != str2.length) return false;
        return zip(str1, str2)
            .count!(tup => tup[0] != tup[1]) == 1;
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

    auto solveB() {
        return process!data
            .sort
            .slide(2)
            .filter!(pair => pair[0].differsInOnePlace(pair[1]))
            .front
            .array
            .pluckCommon;
    }
}