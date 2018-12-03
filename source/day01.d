module day01;
import common;

auto process(string data)() {
    return data
        .strip
        .splitter("\n")
        .map!(to!int);
}

template solveA(string data) {
    enum solveA = process!data.sum;
}

template solveB(string data) {
    auto solveB() {
        bool[int] set;
        int sum = 0;
        foreach (i; process!data.cycle) {
            sum += i;
            if (sum in set) {
                return sum;
            }
            set[sum] = true;
        }
    }
}