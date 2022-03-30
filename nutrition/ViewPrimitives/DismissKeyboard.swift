import SwiftUI

struct DismissKeyboard: View {
    var body: some View {
        Button {
            self.hideKeyboard()
        } label: {
            Label("Keyboard Down", systemImage: "keyboard.chevron.compact.down")
        }
          .foregroundColor(Color("Blue"))
    }
}

struct DismissKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        DismissKeyboard()
    }
}
