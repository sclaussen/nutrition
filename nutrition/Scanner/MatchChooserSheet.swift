import SwiftUI

// ============================================================
// MatchChooserSheet — shown when the LLM was uncertain whether
// the scan matches an existing ingredient. The user picks one
// of the candidate matches (which routes to IngredientEdit) or
// "Create new" (which routes to IngredientAdd).
//
// Both choices end with the host calling onResolve with a
// concrete ScanRoute (either .new or .update).
// ============================================================
struct MatchChooserSheet: View {

    @Environment(\.presentationMode) private var presentationMode

    let parsed: ParsedIngredient
    let candidates: [Ingredient]
    let onResolve: (ScanRoute) -> Void


    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Parsed name")) {
                    Text(parsed.name)
                      .font(.callout)
                }

                Section(header: Text("Looks similar to\u{2026}")) {
                    ForEach(candidates) { candidate in
                        Button {
                            chooseUpdate(candidate)
                        } label: {
                            HStack {
                                Text(candidate.name)
                                  .foregroundColor(Color.theme.blackWhite)
                                Spacer()
                                Image(systemName: "chevron.right")
                                  .font(.caption2)
                                  .foregroundColor(Color.theme.blackWhiteSecondary)
                            }
                        }
                    }
                }

                Section {
                    Button {
                        chooseNew()
                    } label: {
                        Label("Create new ingredient", systemImage: "plus.circle")
                          .foregroundColor(Color.theme.blueYellow)
                    }
                }
            }
              .navigationTitle("Is this a new one?")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .navigation) {
                      Button("Cancel") {
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
              }
        }
    }


    private func chooseNew() {
        presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onResolve(.new(parsed))
        }
    }


    private func chooseUpdate(_ existing: Ingredient) {
        let diff = ScanDiff.compute(existing: existing, parsed: parsed)
        presentationMode.wrappedValue.dismiss()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            onResolve(.update(existing: existing, parsed: parsed, diff: diff))
        }
    }
}
