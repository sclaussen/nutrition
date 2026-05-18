import SwiftUI


// Full snapshot for one logged day: macro/cost totals, every meal
// entry, the vitamin/mineral actuals, and the body params captured
// at log time. Read-only — history is never edited here.
struct DayLogDetail: View {

    let log: DayLog

    private var dateLabel: String {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .short
        return f.string(from: log.date)
    }

    var body: some View {
        List {

            Section {
                row("Calories", log.totals.calories.formattedString(0), "cal")
                row("Fat", log.totals.fat.formattedString(1), "g")
                row("Fiber", log.totals.fiber.formattedString(1), "g")
                row("Net Carbs", log.totals.netCarbs.formattedString(1), "g")
                row("Protein", log.totals.protein.formattedString(1), "g")
                row("Cost", "$" + log.totals.cost.formattedString(2), "")
            } header: {
                Text("Totals")
            }

            Section {
                if let w = log.body.weightLbs {
                    row("Weight", w.formattedString(1), "lbs")
                }
                if let a = log.body.age {
                    row("Age", a.formattedString(1), "yrs")
                }
                if let e = log.body.activeEnergy {
                    row("Active Energy", e.formattedString(0), "cal")
                }
            } header: {
                Text("Body")
            }

            Section {
                if log.entries.isEmpty {
                    Text("No meal entries recorded.")
                      .font(.caption)
                      .foregroundColor(Color.theme.blackWhiteSecondary)
                } else {
                    ForEach(log.entries) { e in
                        EntryRow(entry: e)
                    }
                }
            } header: {
                Text("Meal Entries (\(log.entries.count))")
            }

            Section {
                ForEach(log.vitamins) { vm in
                    HStack {
                        Text(vm.name)
                          .font(.caption)
                          .foregroundColor(Color.theme.blackWhite)
                        Spacer()
                        Text("\(vm.amount.formattedString(1)) \(vm.unit)")
                          .font(.caption)
                          .foregroundColor(Color.theme.blackWhite)
                        Text(vm.percentOfMin > 0
                             ? "\(vm.percentOfMin.formattedString(0))% min"
                             : "—")
                          .font(.caption2)
                          .foregroundColor(percentColor(vm.percentOfMin))
                          .frame(width: 78, alignment: .trailing)
                    }
                }
            } header: {
                Text("Vitamins & Minerals")
            }
        }
          .listStyle(InsetGroupedListStyle())
          .navigationTitle(dateLabel)
          .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ name: String, _ value: String, _ unit: String) -> some View {
        HStack {
            Text(name)
              .font(.callout)
              .foregroundColor(Color.theme.blackWhite)
            Spacer()
            Text(unit.isEmpty ? value : "\(value) \(unit)")
              .font(.callout)
              .foregroundColor(Color.theme.blueYellow)
        }
    }

    private func percentColor(_ pct: Double) -> Color {
        if pct <= 0 { return Color.theme.blackWhiteSecondary }
        return pct < 100 ? Color.theme.red : Color.theme.green
    }
}


struct EntryRow: View {
    let entry: DayLogEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            HStack {
                Text(entry.foodName)
                  .font(.callout)
                  .foregroundColor(Color.theme.blackWhite)
                Spacer()
                Text("\(entry.amount.formattedString(2)) \(entry.unit)")
                  .font(.caption)
                  .foregroundColor(Color.theme.blackWhiteSecondary)
            }
            if entry.resolvedName != entry.foodName && !entry.resolvedName.isEmpty {
                Text(entry.resolvedName)
                  .font(.caption2)
                  .foregroundColor(Color.theme.blackWhiteSecondary)
            }
            HStack(spacing: 12) {
                small("\(entry.calories.formattedString(0)) cal")
                small("F \(entry.fat.formattedString(1))")
                small("NC \(entry.netCarbs.formattedString(1))")
                small("P \(entry.protein.formattedString(1))")
                small("$\(entry.cost.formattedString(2))")
            }
        }
          .padding(.vertical, 2)
    }

    private func small(_ s: String) -> some View {
        Text(s)
          .font(.caption2)
          .foregroundColor(Color.theme.blueYellow)
    }
}
