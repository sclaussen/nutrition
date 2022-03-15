import SwiftUI

struct MyButton: ViewModifier {

    let font: Font

    init(font: Font = .headline) {
        self.font = font
    }

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
    }
}

struct MyNameLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
          .frame(minHeight: 20, alignment: .leading)
          .border(Color.black, width: 1)
    }
}

struct MyValueLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
          .frame(minHeight: 20, alignment: .trailing)
          .border(Color.black, width: 1)
    }
}

struct MyValue: ViewModifier {
    func body(content: Content) -> some View {
        content
          .foregroundColor(.blue)
          .frame(minHeight: 20, alignment: .trailing)
          .multilineTextAlignment(.trailing)
          .disableAutocorrection(true)
          .border(Color.black, width: 1)
    }
}

struct MyUnitLabel: ViewModifier {
    func body(content: Content) -> some View {
        content
          .font(.caption2)
          .frame(minWidth: 35, minHeight: 20, alignment: .leading)
          .border(Color.black, width: 1)
    }
}

struct MyUnitValue: ViewModifier {
    func body(content: Content) -> some View {
        content
          .font(.caption2)
          .frame(minWidth: 35, minHeight: 20, alignment: .leading)
          .foregroundColor(.blue)
          .border(Color.black, width: 1)
    }
}

extension View {
    func myNameLabel() -> some View {
        return self.modifier(MyNameLabel())
    }

    func myValueLabel() -> some View {
        return self.modifier(MyValueLabel())
    }

    func myValue() -> some View {
        return self.modifier(MyValue())
    }

    func myUnitLabel() -> some View {
        return self.modifier(MyUnitLabel())
    }

    func myUnitValue() -> some View {
        return self.modifier(MyUnitValue())
    }
}
