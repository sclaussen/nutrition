import SwiftUI

struct NameViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
          .lineLimit(1)
          .frame(minWidth: 200, minHeight: 20, alignment: .bottomLeading)
          .border(Color.black, width: 0)
    }
}

struct ValueViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
          .lineLimit(1)
          .frame(minWidth: 100, minHeight: 20, alignment: .bottomTrailing)
          .fixedSize(horizontal: false, vertical: true)
          .multilineTextAlignment(.trailing)
          .border(Color.black, width: 0)
    }
}

struct UnitViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
          .lineLimit(1)
          .font(.caption2)
          .frame(minWidth: 35, minHeight: 20, alignment: .bottomLeading)
          .border(Color.black, width: 0)
    }
}

struct DescriptionViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
          .lineLimit(1)
          .frame(minWidth: 345, minHeight: 10, alignment: .bottomLeading)
          .border(Color.black, width: 0)
          .font(.system(size: 9))
          .opacity(0.8)
    }
}

extension View {
    func name() -> some View {
        return self.modifier(NameViewModifier())
    }

    func description() -> some View {
        return self.modifier(DescriptionViewModifier())
    }

    func value() -> some View {
        return self.modifier(ValueViewModifier())
    }

    func unit() -> some View {
        return self.modifier(UnitViewModifier())
    }
}


struct CheckmarkToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
              .foregroundColor(configuration.isOn ? .green : .gray)
              .frame(width: 51, height: 20, alignment: .center)
              .overlay(
                Circle()
                  .foregroundColor(.white)
                  .padding(.all, 3)
                  .overlay(
                    Image(systemName: configuration.isOn ? "checkmark" : "xmark")
                      .resizable()
                      .aspectRatio(contentMode: .fit)
                      .font(Font.title.weight(.black))
                      .frame(width: 8, height: 8, alignment: .center)
                      .foregroundColor(configuration.isOn ? .green : .gray)
                  )
                  .offset(x: configuration.isOn ? 11 : -11, y: 0)
//                  .animation(Animation.linear(duration: 0.1))

              ).cornerRadius(20)
              .onTapGesture { configuration.isOn.toggle() }
        }
    }
}
