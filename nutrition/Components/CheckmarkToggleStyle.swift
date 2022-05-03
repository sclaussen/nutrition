import Foundation
import SwiftUI

struct ToggleView: View {
    @State var value: Bool = true
    var body: some View {
        Toggle("", isOn: $value)
            .toggleStyle(CheckmarkToggleStyle())
            .frame(width: 100, height: 35)
    }
}

struct ToggleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ToggleView()
                .previewLayout(.sizeThatFits)
            ToggleView()
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}

struct CheckmarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
                .foregroundColor(configuration.isOn ? Color.theme.blueYellow : Color.theme.blackWhiteSecondary)
                .frame(width: 51, alignment: .center)
                .overlay(
                    Circle()
                        .foregroundColor(.white)
                        .padding(.all, 3)
                        .overlay(
                            Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(Font.title.weight(.bold))
                                .frame(width: 8, height: 8, alignment: .center)
                                .foregroundColor(configuration.isOn ? Color.theme.black : Color.theme.black)
                        )
                        .offset(x: configuration.isOn ? 11 : -11, y: 0)
                ).cornerRadius(25)
                .onTapGesture {
                    withAnimation(.linear(duration: 0.1)) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
