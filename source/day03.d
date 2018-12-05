module day03;
import common;

struct Claim {
    int id;
    int left;
    int top;
    int width;
    int height;
    this(string data) {
        import std.regex;
        auto parts = data
            .matchAll(regex(`#(\d+) @ (\d+),(\d+): (\d+)x(\d+)`))
            .front;
        id = parts[1].to!int;
        left = parts[2].to!int;
        top = parts[3].to!int;
        width = parts[4].to!int;
        height = parts[5].to!int;
    }
}

template claims(string data) {
    enum claims = data
        .strip
        .splitter("\n")
        .array
        .map!(s => Claim(s));
}

template solveA(string data) {
    auto solveA() {
        int[string] grid;
        foreach (claim; claims!data) {
            for (int i = claim.left; i < (claim.left + claim.width); ++i) {
                for (int j = claim.top; j < (claim.top + claim.height); ++j) {
                    grid[i.to!string ~ "x" ~ j.to!string]++;
                }
            }
        }
        return grid.byValue.filter!(v => v > 1).array.length;
    }
}

struct Data {
    int[] ids;
    int count;
}

template solveB(string data) {
    auto solveB() {
        Data[string] grid;
        bool[int] ids;
        foreach (claim; claims!data) {
            ids[claim.id] = true;
            for (int i = claim.left; i < (claim.left + claim.width); ++i) {
                for (int j = claim.top; j < (claim.top + claim.height); ++j) {
                    auto key = i.to!string ~ "x" ~ j.to!string;
                    auto value = (key in grid);
                    if (value !is null) {
                        value.count++;
                        value.ids ~= claim.id;
                        foreach (id; value.ids) {
                            ids[id] = false;
                        }
                    } else {
                        grid[key] = Data([claim.id], 1);
                    }
                }
            }
        }
        return ids.byKeyValue.filter!(tup => tup.value).front.key;
    }
}