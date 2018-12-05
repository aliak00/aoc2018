module day04;
import common;

import std.datetime;

enum Type {
    guard,
    sleeps,
    wakes
}

alias ParsedLine = Tuple!(SysTime, "time", Type, "type", int, "id");

auto parse(string line) {
    static import dateparser;
    auto parts = line.splitter!(a => "# []".canFind(a)).array;
    auto time = dateparser.parse(parts[1..3].join(" "));
    Type type;
    final switch (parts[4]) {
    case "Guard": type = Type.guard; break;
    case "wakes": type = Type.wakes; break;
    case "falls": type = Type.sleeps; break;
    }
    int guardId;
    if (type == Type.guard) {
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
        case Type.guard:
            currentId = row.id;
            break;
        case Type.sleeps:
            timeFellAsleep = row.time.minute;
            break;
        case Type.wakes:
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

template solveA(string data) {
    auto solveA() {
        auto sleepiestGuard = parseGuards!data
            .byKeyValue
            .maxElement!"a.value.totalSleepTime"
            .value;
        
        auto frequencies =  sleepiestGuard.sleepTimes
            .fold!((freqs, a) {
                foreach (t; a.start .. a.end) {
                    freqs[t]++;
                }
                return freqs;
            })((int[int]).init);
        
        return frequencies
            .byKeyValue
            .maxElement!"a.value"
            .key * sleepiestGuard.id;
    }
}

template solveB(string data) {
    auto solveB() {
        alias GuardData = Tuple!(int, "id", int, "minute", int, "frequency");
        auto guard = parseGuards!data
            .byKeyValue
            .map!((guard) {
                auto mf = guard.value.highestMinuteFrequency;
                return GuardData(guard.key, mf.minute, mf.frequency);
            })
            .maxElement!"a.frequency";

        return guard.id * guard.minute;
    }
}