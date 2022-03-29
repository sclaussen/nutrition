import SwiftUI

protocol NVValueTypeProtocol: Codable, Hashable, CaseIterable where AllCases: RandomAccessCollection {
    func string(_ max: Int) -> String
    func singular() -> Bool
}

extension NVValueTypeProtocol {
    func string(_ max: Int = -1) -> String {
        return string(max)
    }
}

enum NVControl {
    case text
    case toggle
    case date
    case picker
}

enum NVValueType {
    case int
    case float
    case string
    case bool
    case date
}

// Credit: https://betterprogramming.pub/generic-text-field-in-swiftui-aca764ac93d4
struct NameValue<T: NVValueTypeProtocol>: View {
    var name: String
    var description: String
    @Binding var value: T
    @State var valueString: String
    var unit: Unit
    var precision: Int
    var options: [T]
    var control: NVControl
    // var pickerStyle: PickerStyle
    var edit: Bool

    var keyboard: UIKeyboardType = .default
    var valueType: NVValueType = .string

    init(_ name: String,
         description: String = "",
         _ value: Binding<T>,
         _ unit: Unit = Unit.gram,
         precision: Int = 0,
         negative: Bool = false,
         options: [T] = [],
         control: NVControl = .text,
         // pickerStyle: PickerStyle = MenuPickerStyle()
         edit: Bool = false) {

        self.name = name
        self.description = description
        self._value = value
        self._valueString = State(initialValue: value.wrappedValue.string(precision))
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
        self.options = options
        self.control = control
        // self.pickerStyle = pickerStyle
        self.edit = (control == .text) ? edit : true
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .bottom, spacing: 5) {


                // Name
                Text(name)
                  .tracking(-0.6)
                  .name()


                // Value
                if control == .text {

                    if !edit {

                        // TEXT control for text values (LABEL)
                        Text(value.string(precision))
                          .value()


                    } else {

                        // TEXTFIELD control for text values (EDIT)
                        TextField(description.count > 0 ? description : name, text: $valueString)
                          .value()
                          .foregroundColor(.blue)
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
                      .value()
                      .foregroundColor(.blue)
                      .toggleStyle(CheckmarkToggleStyle())


                } else if control == .picker {

                    // PICKER control for lists (EDIT)
                    Picker("", selection: $value) {
                        ForEach(options, id: \.self) {
                            Text($0.string()).tag($0)
                              .value()
                              .foregroundColor(.blue)
                        }
                    }
                      .value()
                      .offset(x: 7)
                      .foregroundColor(.blue)
                      .labelsHidden()
                      .pickerStyle(MenuPickerStyle())


                } else if control == .date {

                    // TOGGLE control for date values (EDIT)
                    DatePicker("",
                               selection: Binding(get: { $value.wrappedValue as! Date },
                                                  set: { $value.wrappedValue = $0 as! T }),
                               in: ...Date(), displayedComponents: [.date])
                      .value()
                      .foregroundColor(.blue)
                      .colorInvert()
                      .colorMultiply(Color.blue)
                }


                // Unit
                if value.singular() {
                    AnyView(Text(unit.singularForm)
                              .unit())
                } else {
                    AnyView(Text(unit.pluralForm)
                              .unit())
                }
            }

            // Description
            if description.count > 0 {
                AnyView(Text(description)
                          .description())
            }
        }
    }
}
