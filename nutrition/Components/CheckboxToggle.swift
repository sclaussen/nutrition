import SwiftUI

struct CheckboxToggle: View {
    @State var text: String = ""
    @Binding var status: Bool

    var body: some View {
        Toggle(isOn: $status) {
            Text(text)
        }.toggleStyle(CheckboxToggleStyle())
    }
}

struct CheckboxToggle_Previews: PreviewProvider {
    @State static var status: Bool = true
    static var previews: some View {
        Group {
            CheckboxToggle(text: "Checkbox", status: $status)
              .previewLayout(.sizeThatFits)
            CheckboxToggle(text: "Checkbox", status: $status)
              .previewLayout(.sizeThatFits)
              .preferredColorScheme(.dark)
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: configuration.isOn ? "checkmark.square" : "square")
          .resizable()
          .frame(width: 20, height: 20)
          .onTapGesture { configuration.isOn.toggle() }
    }
}

