import SwiftUI

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
}()

struct NVString: View {
    var text: String
    var value: String

    init(_ text: String, _ value: String) {
        self.text = text
        self.value = value
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            Spacer()
            Text(value).myValueLabel()
            Text("").myUnitLabel()
        }
    }
}

struct NVStringEdit: View {
    var text: String
    @Binding var value: String

    init(_ text: String, _ value: Binding<String>) {
        self.text = text
        self._value = value
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            TextField(text, text: $value).myValue()
            Text("").myUnitValue()
        }
    }
}

struct NVInt: View {
    var text: String
    var value: Int
    var unit: Unit

    init(_ text: String, _ value: Int, _ unit: Unit = Unit.none) {
        self.text = text
        self.value = value
        self.unit = unit
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            Spacer()
            Text("\(value)").myValueLabel()
            Text(value == 1 ? unit.singular : unit.plural).myUnitLabel()
        }
    }
}

struct NVIntEdit: View {
    var text: String
    @Binding var value: Int
    var unit: Unit

    init(_ text: String, _ value: Binding<Int>, _ unit: Unit = Unit.none) {
        self.text = text
        self._value = value
        self.unit = unit
    }

    var body: some View {
        HStack(alignment: .bottom) {
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

struct NVDouble: View {
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
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            Spacer()
            Text("\(value.fractionDigits(max: self.precision))").myValueLabel()
            Text(value == 1 ? unit.singular : unit.plural).myUnitLabel()
        }
    }
}

struct NVDoubleEdit: View {
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
        HStack(alignment: .bottom) {
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

struct NVPickerEdit: View {
    var text: String
    @Binding var value: String
    var options: [String]

    init(_ text: String, _ value: Binding<String>, options: [String]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .bottom) {
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

struct NVPickerUnitEdit: View {
    var text: String
    @Binding var value: Unit
    var options: [Unit]

    init(_ text: String, _ value: Binding<Unit>, options: [Unit]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .bottom) {
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

struct NVPickerGenderEdit: View {
    var text: String
    @Binding var value: Gender
    var options: [Gender]

    init(_ text: String, _ value: Binding<Gender>, options: [Gender]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .bottom) {
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

struct NVPickerNVIntEdit: View {
    var text: String
    @Binding var value: Int
    var options: [String]

    init(_ text: String, _ value: Binding<Int>, options: [String]) {
        self.text = text
        self._value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            Spacer()
            Picker("", selection: $value) {
                ForEach(0..<options.count, id: \.self) {
                    Text(options[$0]).myValue()
                }
            }.offset(x: 21)
            Text("").myUnitValue()
        }
    }
}

struct NVToggleEdit: View {
    var text: String
    @Binding var value: Bool

    init(_ text: String, _ value: Binding<Bool>) {
        self.text = text
        self._value = value
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            Spacer()
            Toggle("", isOn: $value)
              .toggleStyle(CheckmarkToggleStyle())
              .border(Color.black, width: 0)
            Text("").myUnitValue()
        }
    }
}

struct NVDateEdit: View {
    var text: String
    @Binding var value: Date

    init(_ text: String, _ value: Binding<Date>) {
        self.text = text
        self._value = value
    }

    var body: some View {
        HStack(alignment: .bottom) {
            Text(text).myNameLabel()
            DatePicker("", selection: $value, in: ...Date(), displayedComponents: [.date])
              .myValue()
              .colorInvert()
              .colorMultiply(Color.blue).offset(x: 5)
              // .datePickerStyle(WheelDatePickerStyle())

            Text("").myUnitValue()
        }
    }
}
