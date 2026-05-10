import SwiftUI


// A simple sheet for entering a numeric value.  Used by the Meal
// page row pill to let the user type an exact amount without
// navigating away.
//
// Caller provides:
//   - title: shown at the top of the sheet (e.g., "Coconut Oil (tbsps)")
//   - initialValue: pre-populated in the text field
//   - onSave: invoked with the parsed Double when the user taps Save
//
// Cancel dismisses without invoking onSave.
struct NumberEntrySheet: View {

    @Environment(\.presentationMode) var presentationMode
    @FocusState private var focused: Bool

    let title: String
    let initialValue: Double
    let onSave: (Double) -> Void

    @State private var text: String


    init(title: String, initialValue: Double, onSave: @escaping (Double) -> Void) {
        self.title = title
        self.initialValue = initialValue
        self.onSave = onSave
        _text = State(initialValue: formatNumber(initialValue))
    }


    var body: some View {
        NavigationView {
            Form {
                Section(header: Text(title)) {
                    TextField("Amount", text: $text)
                      .keyboardType(.decimalPad)
                      .focused($focused)
                }
            }
              .navigationTitle("Set Amount")
              .navigationBarTitleDisplayMode(.inline)
              .toolbar {
                  ToolbarItem(placement: .navigation) {
                      Button("Cancel") {
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
                  ToolbarItem(placement: .primaryAction) {
                      Button("Save") {
                          if let value = Double(text) {
                              onSave(value)
                          }
                          presentationMode.wrappedValue.dismiss()
                      }
                        .foregroundColor(Color.theme.blueYellow)
                  }
              }
              .onAppear {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                      focused = true
                  }
              }
        }
    }
}


// Format a number for display: omit decimals when it's a whole
// number, keep up to two decimals otherwise.
private func formatNumber(_ value: Double) -> String {
    if value == value.rounded() {
        return String(Int(value))
    }
    return String(value)
}
