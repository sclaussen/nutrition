import SwiftUI

enum Control {
    case text
    case toggle
    case date
    case picker
}

enum ValueType {
    case int
    case float
    case string
    case bool
    case date
}

// Credit: https://betterprogramming.pub/generic-text-field-in-swiftui-aca764ac93d4
struct NameValue<T: CustomStringConvertible & Singular & Fmt>: View {
    var name: String
    var description: String
    @Binding var value: T
    @State var valueString: String
    var unit: Unit
    var precision: Int
    var keyboard: UIKeyboardType = .default
    var valueType: ValueType = .string
    var control: Control = .text
    var edit: Bool
    let nameWidth: Float
    let valueWidth: Float


    init(_ name: String,
         description: String = "",
         _ value: Binding<T>,
         _ unit: Unit = Unit.gram,
         precision: Int = 0,
         negative: Bool = false,
         control: Control = .text,
         edit: Bool = false) {

        self.name = name
        self.description = description
        self._value = value
        self._valueString = State(initialValue: value.wrappedValue.description.toStr(precision))
        self.precision = precision

        if type(of: value.wrappedValue) == Int.self {
            valueType = .int
            self.keyboard = negative ? .default : .numberPad
        } else if type(of: value.wrappedValue) == Float.self {
            valueType = .float
            self.keyboard = negative ? .default : .decimalPad
        } else if type(of: value.wrappedValue) == Bool.self {
            valueType = .bool
        } else if type(of: value.wrappedValue) == Date.self {
            valueType = .date
        }

        self.unit = (control == .text && valueType != .string) ? unit : .none
        self.control = control
        self.edit = (control == .text) ? edit : true

        self.nameWidth  = 300 * 0.66
        self.valueWidth = 300 * 0.33
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom) {


                // Name
                Text(name)
                  .lineLimit(1)
                  .frame(minWidth: CGFloat(nameWidth), minHeight: 20, alignment: .leading)
                  .border(Color.black, width: 0)


                // Value
                if control == .text {

                    if !edit {

                        // TEXT control for text values (LABEL)
                        Text(value.toStr(precision))
                          .lineLimit(1)
                          .frame(minWidth: CGFloat(valueWidth), minHeight: 20, alignment: .trailing)
                          .border(Color.black, width: 0)



                    } else {

                        // TEXTFIELD control for text values (EDIT)
                        TextField(description.count > 0 ? description : name, text: $valueString)
                          .myValue()
                          .keyboardType(keyboard)
                          .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
                              if let textEdit = obj.object as? UITextField {
                                  textEdit.selectedTextRange = textEdit.textRange(from: textEdit.beginningOfDocument, to: textEdit.endOfDocument)
                              }
                          }
                          .onChange(of: valueString) { (newValue) in
                              print(valueType)
                              if valueType == .int {
                                  if let convertedValue = Int(newValue) {
                                      value = convertedValue as! T
                                  } else {
                                      print("Error...")
                                  }
                              } else if valueType == .float {
                                  if let convertedValue = Float(newValue) {
                                      value = convertedValue as! T
                                  } else {
                                      print("Error...")
                                  }
                              } else {
                                  value = newValue as! T
                              }
                          }
                    }


                } else if control == .toggle {

                    // TOGGLE control for boolean values (EDIT)
                    Toggle("", isOn: Binding(get: { $value.wrappedValue as! Bool },
                                             set: { $value.wrappedValue = $0 as! T }))
                      .myValue()
                      .toggleStyle(CheckmarkToggleStyle())
                      .border(Color.black, width: 0)



                } else if control == .date {

                    // TOGGLE control for date values (EDIT)
                    DatePicker("",
                               selection: Binding(get: { $value.wrappedValue as! Date },
                                                  set: { $value.wrappedValue = $0 as! T }),
                               in: ...Date(), displayedComponents: [.date])
                      .myValue()
                      .colorInvert()
                      .colorMultiply(Color.blue)
                      .offset(x: 5)
                }


                // Unit
                if value.singular() {
                    AnyView(Text(unit.singular)
                              .font(.caption2)
                              .frame(minWidth: 35, minHeight: 20, alignment: .leading)
                              .border(Color.black, width: 0))
                } else {
                    AnyView(Text(unit.plural)
                              .font(.caption2)
                              .frame(minWidth: 35, minHeight: 20, alignment: .leading)
                              .border(Color.black, width: 0))
                }
            }

            // Description
            if description.count > 0 {
                AnyView(Text(description)
                          .lineLimit(1)
                          .frame(minWidth: 050, minHeight: 10, alignment: .leading)
                          .border(Color.black, width: 0)
                          .font(.system(size: 9)))
            }
        }
    }
}

extension String.StringInterpolation {
    mutating func appendInterpolation(_ value: Unit) {
        appendInterpolation("My name is shane")
    }
}

struct NVPicker<T: MyEnum>: View {
    var name: String
    var value: Binding<T>
    let options: [T]

    init(_ name: String, _ value: Binding<T>, options: [T]) {
        self.name = name
        self.value = value
        self.options = options
    }

    var body: some View {
        HStack(alignment: .bottom) {
            NVName(name)
            Picker("", selection: value) {
                ForEach(options, id: \.self) {
                    Text($0.displayName).tag($0)
                }
            }
              .pickerStyle(MenuPickerStyle())
              .myValue()
            NVUnit(value: Int(0), Unit.none)
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
                NVName(name)
                Picker("", selection: $value) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
                  .offset(x: 20)
                  .myValue()
                NVUnit(value: Int(0), Unit.none)
            }
            NVDescription(description)
        }
    }
}

struct NVName: View {
    var name: String
    var widthPercentage: Float = 0.66

    init(_ name: String) {
        self.name = name
    }

    var body: some View {
        let width = 300 * widthPercentage
        Text(name)
          .lineLimit(1)
          .frame(minWidth: CGFloat(width), minHeight: 20, alignment: .leading)
          .border(Color.black, width: 0)
    }
}

struct NVUnit<T: Singular>: View {
    var value: T
    var unit: Unit

    init(value: T, _ unit: Unit) {
        self.value = value
        self.unit = unit
    }

    var body: some View {
        if unit == Unit.none {
            return AnyView(Text("")
                             .frame(minWidth: 35, minHeight: 20)
                             .border(Color.black, width: 0))
        }

        if value.singular() {
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

    init(_ description: String) {
        self.description = description
    }

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
