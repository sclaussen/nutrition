import SwiftUI

struct DismissKeyboard: View {
    var body: some View {
        Spacer()
        Button {
            self.hideKeyboard()
        } label: {
            Label("Keyboard Down", systemImage: "keyboard.chevron.compact.down")
        }
    }
}

struct DismissKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        DismissKeyboard()
    }
}
