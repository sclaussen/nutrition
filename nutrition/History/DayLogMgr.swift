import Foundation


// History store for daily snapshots. Unlike the other managers
// (which use UserDefaults), this history is unbounded so it lives
// in a JSON file in the app's Documents directory. Still Codable,
// still the ObservableObject + @Published + serialize() pattern.
//
// Low coupling by design: logToday(...) is handed the
// already-computed snapshot values from DailySummary. The snapshot
// math is therefore identical to what DailySummary already shows —
// this manager never recomputes macros, cost, or V&M.
class DayLogMgr: ObservableObject {


    @Published var logs: [DayLog]


    // Documents/daylog.json — chosen over UserDefaults because the
    // history grows without bound.
    private static var fileURL: URL {
        let docs = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
        return docs.appendingPathComponent("daylog.json")
    }


    // Stable calendar-day key ("yyyy-MM-dd") used as DayLog.id so
    // a second log on the same day overwrites rather than dupes.
    private static let dayKeyFormatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar.current
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()


    static func dayKey(for date: Date) -> String {
        return dayKeyFormatter.string(from: date)
    }


    init() {
        if let data = try? Data(contentsOf: DayLogMgr.fileURL),
           let logs = try? JSONDecoder().decode([DayLog].self, from: data) {
            self.logs = logs.sorted { $0.date > $1.date }
            return
        }
        self.logs = []
    }


    // Build today's snapshot from values already computed by
    // DailySummary and upsert it by calendar day (replace any
    // existing log for the same day), newest first.
    func logToday(entries: [DayLogEntry],
                  totals: DayLogTotals,
                  vitamins: [DayLogVM],
                  body: DayLogBody) {

        let now = Date()
        let key = DayLogMgr.dayKey(for: now)

        let log = DayLog(id: key,
                         date: now,
                         entries: entries,
                         totals: totals,
                         vitamins: vitamins,
                         body: body)

        var updated = logs.filter { $0.id != key }
        updated.append(log)
        self.logs = updated.sorted { $0.date > $1.date }

        serialize()
    }


    func serialize() {
        guard let data = try? JSONEncoder().encode(logs) else {
            print("Failed to encode day log history")
            return
        }
        do {
            try data.write(to: DayLogMgr.fileURL, options: .atomic)
        } catch {
            print("Failed to write day log history: \(error)")
        }
    }
}
