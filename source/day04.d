module day04;
import common;

import std.datetime;
import std.uni: toLower;

auto solve(string input)() {
    auto guards = parseGuards!input.byKeyValue;

    auto sleepiestGuard = guards
        .maxElement!"a.value.totalSleepTime"
        .value;

    auto frequencies = sleepiestGuard.sleepTimes
        .fold!((freqs, a) {
            foreach (t; a.start .. a.end) {
                freqs[t]++;
            }
            return freqs;
        })((int[int]).init);

    auto A = frequencies
        .byKeyValue
        .maxElement!"a.value"
        .key * sleepiestGuard.id;

    alias GuardData = Tuple!(int, "id", int, "minute", int, "frequency");

    auto guard = guards
        .map!((guard) {
            auto mf = guard.value.highestMinuteFrequency;
            return GuardData(guard.key, mf.minute, mf.frequency);
        })
        .maxElement!"a.frequency";

    auto B = guard.id * guard.minute;

    return tuple(
        A,
        B,
    );
}

alias ParsedLine = Tuple!(SysTime, "time", string, "type", int, "id");

auto parse(string line) {
    static import dateparser;
    auto parts = line.splitter!(a => "# []".canFind(a)).array;
    auto time = dateparser.parse(parts[1..3].join(" "));
    string type = parts[4].toLower;
    int guardId;
    if (type == "guard") {
        guardId = parts[6].to!int;
    }
    return ParsedLine(time, type, guardId);
}

struct SleepyTime {
    int start;
    int end;
}

struct Guard {
    int id;
    int totalSleepTime;
    SleepyTime[] sleepTimes;
    
    @property auto highestMinuteFrequency() {
        auto frequencies = sleepTimes.fold!((freqs, a) {
            foreach (t; a.start .. a.end) {
                freqs[t]++;
            }
            return freqs;
        })((int[int]).init);

        auto max = frequencies
            .byKeyValue
            .maxElement!"a.value";

        return Tuple!(int, "minute", int, "frequency")(max.key, max.value);
    }
}

Guard[int] parseGuards(string data)() {
    auto lines = data
        .strip
        .splitter("\n")
        .array;

    auto rows = lines
        .map!parse
        .array
        .sort!((a, b) => a.time < b.time)
        .array;

    Guard[int] guards;
    int currentId;
    int timeFellAsleep;
    for (int i = 0; i < rows.length; ++i) {
        auto row = rows[i];
        final switch (row.type) {
        case "guard":
            currentId = row.id;
            break;
        case "falls":
            timeFellAsleep = row.time.minute;
            break;
        case "wakes":
            auto sleepyTime = SleepyTime(timeFellAsleep, row.time.minute);
            guards.update(currentId, {
                return Guard(
                    currentId, 
                    row.time.minute - timeFellAsleep,
                    [SleepyTime(timeFellAsleep, row.time.minute)],
                );
            }, (ref Guard value) {
                value.totalSleepTime += row.time.minute - timeFellAsleep;
                value.sleepTimes ~= SleepyTime(timeFellAsleep, row.time.minute);
                return value;
            });
            break;
        }
    }
    return guards;
}