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

struct Data {
    int[] ids;
    int count;
}

auto solve(string input)() {
    enum claims = byLine!input
        .map!(s => Claim(s));

    int[string] frequencyGrid;
    foreach (claim; claims) {
        for (int i = claim.left; i < (claim.left + claim.width); ++i) {
            for (int j = claim.top; j < (claim.top + claim.height); ++j) {
                frequencyGrid[i.to!string ~ "x" ~ j.to!string]++;
            }
        }
    }

    auto A = frequencyGrid.byValue.filter!(v => v > 1).array.length;

    Data[string] grid;
    bool[int] ids;
    foreach (claim; claims) {
        ids[claim.id] = true;
        for (int i = claim.left; i < (claim.left + claim.width); ++i) {
            for (int j = claim.top; j < (claim.top + claim.height); ++j) {
                auto key = i.to!string ~ "x" ~ j.to!string;
                grid.update(key, {
                    return Data([claim.id], 1);
                }, (ref Data value) {
                    value.count++;
                    value.ids ~= claim.id;
                    foreach (id; value.ids) {
                        ids[id] = false;
                    }
                    return value;
                });
            }
        }
    }
    auto B = ids.byKeyValue.filter!(tup => tup.value).front.key;

    return tuple(
        A,
        B,
    );
}