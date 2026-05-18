import SwiftUI


// History sub-app: a scrollable list of every logged day plus
// numeric trend summaries. Tap a day to drill into its full
// snapshot (DayLogDetail).
//
// NOTE ON CHARTS: this project's iOS deployment target is 15.3.
// Swift Charts (`import Charts`) requires iOS 16+, so per the
// task's instruction we deliver numeric trend stats here (and a
// note) rather than hand-rolling chart drawing. Bump
// IPHONEOS_DEPLOYMENT_TARGET to 16.0 to enable a Swift Charts
// section.
struct HistoryView: View {

    @EnvironmentObject var dayLogMgr: DayLogMgr

    private var sortedLogs: [DayLog] {
        dayLogMgr.logs.sorted { $0.date > $1.date }
    }

    private func dateLabel(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .none
        return f.string(from: date)
    }

    var body: some View {
        Group {
            if sortedLogs.isEmpty {
                emptyState
            } else {
                List {
                    Section {
                        TrendSummary(logs: sortedLogs)
                    } header: {
                        Text("Trends")
                    }

                    Section {
                        ForEach(sortedLogs) { log in
                            NavigationLink(destination: DayLogDetail(log: log)) {
                                DayLogRow(log: log, dateLabel: dateLabel(log.date))
                            }
                        }
                    } header: {
                        Text("Logged Days (\(sortedLogs.count))")
                    } footer: {
                        Text("Charts (weight / calories / cost / macros over time) require iOS 16+ Swift Charts; this build targets iOS 15.3. Numeric trends shown above.")
                          .font(.caption2)
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    }
                }
                  .listStyle(InsetGroupedListStyle())
            }
        }
          .navigationTitle("History")
          .navigationBarTitleDisplayMode(.inline)
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "chart.xyaxis.line")
              .font(.system(size: 44))
              .foregroundColor(Color.theme.blackWhiteSecondary)
            Text("No history yet")
              .font(.headline)
              .foregroundColor(Color.theme.blackWhite)
            Text("Open the meal summary and tap \"Log Today\" to capture a daily snapshot. Logged days appear here.")
              .font(.callout)
              .multilineTextAlignment(.center)
              .foregroundColor(Color.theme.blackWhiteSecondary)
              .padding(.horizontal, 32)
        }
          .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// A single day's at-a-glance row: date, calories, cost, weight.
struct DayLogRow: View {
    let log: DayLog
    let dateLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(dateLabel)
              .font(.callout)
              .foregroundColor(Color.theme.blackWhite)
            HStack(spacing: 14) {
                metric("\(log.totals.calories.formattedString(0)) cal")
                metric("$\(log.totals.cost.formattedString(2))")
                if let w = log.body.weightLbs {
                    metric("\(w.formattedString(1)) lbs")
                }
            }
        }
          .padding(.vertical, 2)
    }

    private func metric(_ s: String) -> some View {
        Text(s)
          .font(.caption)
          .foregroundColor(Color.theme.blueYellow)
    }
}


// Numeric trend block (oldest → newest deltas). Replaces charts on
// the iOS 15 target; gives weight / calories / cost / protein
// movement at a glance.
struct TrendSummary: View {
    let logs: [DayLog]   // newest first

    private var oldest: DayLog? { logs.last }
    private var newest: DayLog? { logs.first }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if logs.count < 2 {
                Text("Log a second day to see trends.")
                  .font(.caption)
                  .foregroundColor(Color.theme.blackWhiteSecondary)
            } else if let o = oldest, let n = newest {
                trendRow("Weight",
                         from: o.body.weightLbs,
                         to: n.body.weightLbs,
                         unit: "lbs", precision: 1)
                trendRow("Calories",
                         from: o.totals.calories,
                         to: n.totals.calories,
                         unit: "cal", precision: 0)
                trendRow("Cost",
                         from: o.totals.cost,
                         to: n.totals.cost,
                         unit: "$", precision: 2, dollarPrefix: true)
                trendRow("Protein",
                         from: o.totals.protein,
                         to: n.totals.protein,
                         unit: "g", precision: 0)
                trendRow("Net Carbs",
                         from: o.totals.netCarbs,
                         to: n.totals.netCarbs,
                         unit: "g", precision: 0)
            }
        }
          .padding(.vertical, 4)
    }

    @ViewBuilder
    private func trendRow(_ name: String,
                          from: Double?,
                          to: Double?,
                          unit: String,
                          precision: Int,
                          dollarPrefix: Bool = false) -> some View {
        if let a = from, let b = to {
            let delta = b - a
            let arrow = delta > 0 ? "arrow.up" : (delta < 0 ? "arrow.down" : "minus")
            HStack {
                Text(name)
                  .font(.caption)
                  .foregroundColor(Color.theme.blackWhite)
                Spacer()
                Text(format(b, precision, dollarPrefix, unit))
                  .font(.caption)
                  .foregroundColor(Color.theme.blackWhite)
                HStack(spacing: 2) {
                    Image(systemName: arrow)
                      .font(.caption2)
                    Text(format(abs(delta), precision, dollarPrefix, unit))
                      .font(.caption2)
                }
                  .foregroundColor(Color.theme.blueYellow)
                  .frame(width: 86, alignment: .trailing)
            }
        }
    }

    private func format(_ v: Double, _ p: Int, _ dollar: Bool, _ unit: String) -> String {
        if dollar { return "$" + v.formattedString(p) }
        return v.formattedString(p) + " " + unit
    }
}
