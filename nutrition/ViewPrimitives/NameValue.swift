import SwiftUI

let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 3
    return formatter
}()

struct NVString: View {
    var name: String
    var description: String
    var value: String

    init(_ name: String, description: String = "",  _ value: String) {
        self.name = name
        self.description = description
        self.value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                NVValue(value: value)
                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVStringEdit: View {
    var name: String
    var description: String
    @Binding var value: String

    init(_ name: String, description: String = "", _ value: Binding<String>) {
        self.name = name
        self.description = description
        self._value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                TextField(name, text: $value)
                  .myValue()
                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVInt: View {
    var name: String
    var description: String
    var value: Int
    var unit: Unit

    init(_ name: String, description: String = "", _ value: Int, _ unit: Unit = Unit.none) {
        self.name = name
        self.description = description
        self.value = value
        self.unit = unit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                NVValue(value: value)
                NVUnit(value: value, unit: unit)
            }
            NVDescription(description: description)
        }
    }
}

struct NVIntEdit: View {
    var name: String
    var description: String
    @Binding var value: Int
    var unit: Unit

    init(_ name: String, description: String = "", _ value: Binding<Int>, _ unit: Unit = Unit.none) {
        self.name = name
        self._value = value
        self.description = description
        self.unit = unit
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)

                // Value
                TextField(name, value: $value, formatter: NumberFormatter(), prompt: Text("Required"))
                  .myValue()
                  .keyboardType(.numberPad)
                  .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                      if let textEdit = obj.object as? UITextField {
                          textEdit.selectedTextRange = textEdit.textRange(from: textEdit.beginningOfDocument, to: textEdit.endOfDocument)
                      }
                  }

                NVUnit(value: value, unit: unit)
            }
            NVDescription(description: description)
        }
    }
}

struct NVDouble: View {
    var name: String
    var description: String
    var value: Double
    var unit: Unit
    var precision: Int

    init(_ name: String, description: String = "", _ value: Double, _ unit: Unit = Unit.none, precision: Int = 0) {
        self.name = name
        self.description = description
        self.value = value
        self.unit = unit
        self.precision = precision
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                NVValue(value: value, precision: precision)
                NVUnit(value: Int(value), unit: unit)
            }
            NVDescription(description: description)
        }
    }
}

struct NVDoubleEdit: View {
    var name: String
    var description: String
    @Binding var value: Double
    var unit: Unit
    var precision: Int
    var negative: Bool

    init(_ name: String, description: String = "", _ value: Binding<Double>, _ unit: Unit = Unit.none, precision: Int = 2, negative: Bool = false) {
        self.name = name
        self.description = description
        self._value = value
        self.unit = unit
        self.precision = precision
        self.negative = negative
    }

    var body: some View {
        let formatter2: NumberFormatter = {
            let formatter2 = NumberFormatter()
            formatter2.numberStyle = .decimal
            formatter2.maximumFractionDigits = self.precision
            return formatter2
        }()

        return
          VStack(alignment: .leading, spacing: 0) {
              HStack(alignment: .bottom) {
                  NVName(name: name)

                  // Value
                  TextField(name, value: $value, formatter: formatter2)
                    .myValue()
                    .keyboardType(negative ? .numbersAndPunctuation : .decimalPad)
                    .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                        if let textEdit = obj.object as? UITextField {
                            textEdit.selectedTextRange = textEdit.textRange(from: textEdit.beginningOfDocument, to: textEdit.endOfDocument)
                        }
                    }

                  NVUnit(value: Int(value), unit: unit)
              }
              NVDescription(description: description)
          }
    }
}

struct NVPickerEdit: View {
    var name: String
    var description: String
    @Binding var value: String
    var options: [String]

    init(_ name: String, description: String = "", _ value: Binding<String>, options: [String]) {
        self.name = name
        self.description = description
        self._value = value
        self.options = options
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                Picker("", selection: $value) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
                  .offset(x: 20)
                  .myValue()
                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVPickerUnitEdit: View {
    var name: String
    var description: String
    @Binding var value: Unit
    var options: [Unit]

    init(_ name: String, description: String = "", _ value: Binding<Unit>, options: [Unit]) {
        self.name = name
        self.description = description
        self._value = value
        self.options = options
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                Picker("", selection: $value) {
                    ForEach(options, id: \.self) {
                        Text($0.rawValue)
                          .tag($0)
                    }
                }
                  .offset(x: 20)
                  .myValue()
                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVPickerGenderEdit: View {
    var name: String
    var description: String
    @Binding var value: Gender
    var options: [Gender]

    init(_ name: String, description: String = "", _ value: Binding<Gender>, options: [Gender]) {
        self.name = name
        self.description = description
        self._value = value
        self.options = options
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)
                Picker("", selection: $value) {
                    ForEach(options, id: \.self) {
                        Text($0.rawValue)
                          .tag($0)
                    }
                }
                  .offset(x: 20)
                  .myValue()
                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVPickerIntEdit: View {
    var name: String
    var description: String
    @Binding var value: Int
    var options: [String]

    init(_ name: String, description: String = "", _ value: Binding<Int>, options: [String]) {
        self.name = name
        self.description = description
        self._value = value
        self.options = options
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)

                // Value
                Picker("", selection: $value) {
                    ForEach(0..<options.count, id: \.self) {
                        Text(options[$0])
                    }
                }
                  .offset(x: 20)
                  .myValue()

                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVToggleEdit: View {
    var name: String
    var description: String
    @Binding var value: Bool

    init(_ name: String, description: String = "", _ value: Binding<Bool>) {
        self.name = name
        self.description = description
        self._value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)

                // Value
                Toggle("", isOn: $value)
                  .myValue()
                  .toggleStyle(CheckmarkToggleStyle())
                  .border(Color.black, width: 0)

                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVDateEdit: View {
    var name: String
    var description: String
    @Binding var value: Date

    init(_ name: String, description: String = "", _ value: Binding<Date>) {
        self.name = name
        self.description = description
        self._value = value
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {
                NVName(name: name)

                // Value
                DatePicker("", selection: $value, in: ...Date(), displayedComponents: [.date])
                  .myValue()
                  .colorInvert()
                  .colorMultiply(Color.blue)
                  .offset(x: 5)

                NVUnit(unit: Unit.none)
            }
            NVDescription(description: description)
        }
    }
}

struct NVName: View {
    var name: String
    var widthPercentage: Double = 0.66
    var body: some View {
        let width = 300 * widthPercentage
        Text(name)
          .lineLimit(1)
          .frame(minWidth: width, minHeight: 20, alignment: .leading)
          .border(Color.black, width: 0)
    }
}

struct NVValue<T>: View {
    var value: T
    var widthPercentage: Double = 0.33
    var precision: Int = 0

    var body: some View {
        let width = 300 * widthPercentage

        if let value = value as? Int {
            return AnyView(HStack {
                               Text(String(value))
                                 .lineLimit(1)
                                 .frame(minWidth: width, minHeight: 20, alignment: .trailing)
                                 .border(Color.black, width: 0)
                           })
        }

        if let value = value as? Double {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = precision

            return AnyView(Text(formatter.string(from: value as NSNumber)!)
                             .lineLimit(1)
                             .frame(minWidth: width, minHeight: 20, alignment: .trailing)
                             .border(Color.black, width: 0))
        }

        return AnyView(Text((value as? String)!)
                         .lineLimit(1)
                         .frame(minWidth: width, minHeight: 20, alignment: .trailing)
                         .border(Color.black, width: 0))
    }
}

struct NVUnit: View {
    var value: Int = 0
    var unit: Unit

    var body: some View {
        if value == 1 {
            return AnyView(Text(unit.singular)
              .font(.caption2)
              .frame(minWidth: 35, minHeight: 20, alignment: .leading)
              .border(Color.black, width: 0))
        }

        return AnyView(Text(unit.plural)
          .font(.caption2)
          .frame(minWidth: 35, minHeight: 20, alignment: .leading)
          .border(Color.black, width: 0))
    }
}

struct NVDescription: View {
    var description: String

    var body: some View {
        if description.count > 0 {
            return AnyView(Text(description)
                             .lineLimit(1)
                             .frame(minWidth: 050, minHeight: 10, alignment: .leading)
                             .border(Color.black, width: 0)
                             .font(.system(size: 9)))
        }

        return AnyView(EmptyView())
    }
}
