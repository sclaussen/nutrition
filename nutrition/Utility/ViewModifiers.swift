import SwiftUI

struct NameViewModifier: ViewModifier {
    var geo: GeometryProxy
    var wideValue: Bool

    func body(content: Content) -> some View {
        let width = geo.size.width * (wideValue ? 0.3 : 0.6)
        return content
          .lineLimit(1)
          .font(.callout)
          .frame(minWidth: width, minHeight: 32, alignment: .leading)
          .border(Color.red, width: 0)
    }
}

struct ValueViewModifier: ViewModifier {
    var geo: GeometryProxy
    var wideValue: Bool

    func body(content: Content) -> some View {
        let width = geo.size.width * (wideValue ? 0.6 : 0.3)
        return content
          .lineLimit(1)
          .font(.callout)
          .multilineTextAlignment(.trailing)
          .frame(minWidth: width, minHeight: 32, alignment: .trailing)
          .border(Color.red, width: 0)
    }
}

struct UnitViewModifier: ViewModifier {
    var geo: GeometryProxy

    func body(content: Content) -> some View {
        content
          .lineLimit(1)
          .font(.caption2)
          .frame(minWidth: geo.size.width * 0.10, minHeight: 32, alignment: .leading)
          .border(Color.red, width: 0)
          .offset(x: 4, y: 2)
    }
}

struct DescriptionViewModifier: ViewModifier {
    var geo: GeometryProxy

    func body(content: Content) -> some View {
        content
          .lineLimit(1)
          .font(.caption2)
          .frame(minWidth: geo.size.width * 1 + 5, minHeight: 10, alignment: .leading)
          .border(Color.red, width: 0)
    }
}

extension View {
    func name(_ geo: GeometryProxy, _ wideValue: Bool) -> some View {
        return self.modifier(NameViewModifier(geo: geo, wideValue: wideValue))
    }

    func value(_ geo: GeometryProxy, _ wideValue: Bool) -> some View {
        return self.modifier(ValueViewModifier(geo: geo, wideValue: wideValue))
    }

    func unit(_ geo: GeometryProxy) -> some View {
        return self.modifier(UnitViewModifier(geo: geo))
    }

    func description(_ geo: GeometryProxy) -> some View {
        return self.modifier(DescriptionViewModifier(geo: geo))
    }
}

struct CheckmarkToggleStyle: ToggleStyle {

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Rectangle()
              .foregroundColor(configuration.isOn ? .green : .gray)
              .frame(width: 51, alignment: .center)
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
