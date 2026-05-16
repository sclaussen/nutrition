import SwiftUI


// Sheet shown when the user long-presses a group row in the meal.
// Lists the group's member ingredients (the different brands) so
// they can pick which one is active for the meal. The pick is
// reported via onPick; the caller updates the meal row, recomputes
// macros/cost, and sets the group's new default.
struct FoodMemberPicker: View {

    @Environment(\.presentationMode) private var presentationMode

    let foodName: String
    let members: [Ingredient]      // ingredients whose foodName == foodName
    let selected: String           // currently selected member name
    let onPick: (String) -> Void


    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Which \(foodName)?")) {
                    if members.isEmpty {
                        Text("No members assigned to this group yet. Set an ingredient's Group to \"\(foodName)\" in its edit screen.")
                          .font(.caption)
                          .foregroundColor(Color.theme.blackWhiteSecondary)
                    } else {
                        ForEach(members) { member in
                            Button {
                                onPick(member.name)
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(member.name)
                                          .font(.callout)
                                          .foregroundColor(Color.theme.blackWhite)
                                        if !member.brand.isEmpty {
                                            Text(member.brand)
                                              .font(.caption2)
                                              .foregroundColor(Color.theme.blackWhiteSecondary)
                                        }
                                    }
                                    Spacer()
                                    if member.name == selected {
                                        Image(systemName: "checkmark")
                                          .foregroundColor(Color.theme.blueYellow)
                                    }
                                }
                            }
                        }
                    }
                }
            }
              .navigationTitle("Select member")
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
}
