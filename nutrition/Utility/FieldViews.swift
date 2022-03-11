import SwiftUI

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

struct StringView: View {
    var text: String
    var value: String

    init(_ text: String, _ value: String) {
        self.text = text
        self.value = value
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Text(value).myValueLabel()
            Text("").myUnitLabel()
        }
    }
}

struct StringEdit: View {
    var text: String
    @Binding var value: String

    init(_ text: String, _ value: Binding<String>) {
        self.text = text
        self._value = value
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            TextField(text, text: $value).myValue()
            Text("").myUnitValue()
        }
    }
}

struct IntView: View {
    var text: String
    var value: Int
    var unit: Unit

    init(_ text: String, _ value: Int, _ unit: Unit = Unit.none) {
        self.text = text
        self.value = value
        self.unit = unit
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Text("\(value)").myValueLabel()
            Text(value == 1 ? unit.singular : unit.plural).myUnitLabel()
        }
    }
}

struct IntEdit: View {
    var text: String
    @Binding var value: Int
    var unit: Unit

    init(_ text: String, _ value: Binding<Int>, _ unit: Unit = Unit.none) {
        self.text = text
        self._value = value
        self.unit = unit
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            TextField(text, value: $value, formatter: NumberFormatter(), prompt: Text("Required")).keyboardType(.numberPad).myValue()
              .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                  if let textEdit = obj.object as? UITextField {
                      textEdit.selectedTextRange = textEdit.textRange(from: textEdit.beginningOfDocument, to: textEdit.endOfDocument)
                  }
              }
            Text(value == 1 ? unit.singular : unit.plural).myUnitValue()
        }
    }
}

struct DoubleView: View {
    var text: String
    var value: Double
    var unit: Unit
    var precision: Int

    init(_ text: String, _ value: Double, _ unit: Unit = Unit.none, precision: Int = 2) {
        self.text = text
        self.value = value
        self.unit = unit
        self.precision = precision
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Text("\(value.fractionDigits(max: self.precision))").myValueLabel()
            Text(value == 1 ? unit.singular : unit.plural).myUnitLabel()
        }
    }
}

struct DoubleEdit: View {
    var text: String
    @Binding var value: Double
    var unit: Unit
    var precision: Int
    var negative: Bool

    init(_ text: String, _ value: Binding<Double>, _ unit: Unit = Unit.none, precision: Int = 2, negative: Bool = false) {
        self.text = text
        self._value = value
        self.unit = unit
        self.precision = precision
        self.negative = negative
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            TextField(text, value: $value, formatter: formatter)
              .myValue()
              .keyboardType(negative ? .numbersAndPunctuation : .decimalPad)
              .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                  if let textEdit = obj.object as? UITextField {
                      textEdit.selectedTextRange = textEdit.textRange(from: textEdit.beginningOfDocument, to: textEdit.endOfDocument)
                  }
              }
            Text(value == 1 ? unit.singular : unit.plural).myUnitValue()
        }
    }
}

struct PickerEdit: View {
    var text: String
    @Binding var value: String
    var options: [String]

    init(_ text: String, _ value: Binding<String>, options: [String]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Picker("", selection: $value) {
                ForEach(options, id: \.self) {
                    Text($0).myValue()
                }
            }.offset(x: 21)
            Text("").myUnitValue()
        }
    }
}

struct PickerUnitEdit: View {
    var text: String
    @Binding var value: Unit
    var options: [Unit]

    init(_ text: String, _ value: Binding<Unit>, options: [Unit]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Picker("", selection: $value) {
                ForEach(options, id: \.self) {
                    Text($0.rawValue).myValue().tag($0)
                }
            }.offset(x: 21)
            Text("").myUnitValue()
        }
    }
}

struct PickerGenderEdit: View {
    var text: String
    @Binding var value: Gender
    var options: [Gender]

    init(_ text: String, _ value: Binding<Gender>, options: [Gender]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Picker("", selection: $value) {
                ForEach(options, id: \.self) {
                    Text($0.rawValue).myValue().tag($0)
                }
            }.offset(x: 21)
            Text("").myUnitValue()
        }
    }
}

struct PickerIntEdit: View {
    var text: String
    @Binding var value: Int
    var options: [String]

    init(_ text: String, _ value: Binding<Int>, options: [String]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Picker("", selection: $value) {
                ForEach(0..<options.count) {
                    Text(options[$0]).myValue()
                }
            }.offset(x: 21)
            Text("").myUnitValue()
        }
    }
}

struct ToggleEdit: View {
    var text: String
    @Binding var value: Bool

    init(_ text: String, _ value: Binding<Bool>) {
        self.text = text
        self._value = value
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            Spacer()
            Toggle("", isOn: $value).myValue()
            Text("").myUnitValue()
        }
    }
}

struct DateEdit: View {
    var text: String
    @Binding var value: Date

    init(_ text: String, _ value: Binding<Date>) {
        self.text = text
        self._value = value
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(text).myNameLabel()
            DatePicker("", selection: $value, in: ...Date(), displayedComponents: [.date]).myValue().colorInvert().colorMultiply(Color.blue).offset(x: 5)
            Text("").myUnitValue()
        }
    }
}
