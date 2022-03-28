import SwiftUI

enum Control {
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
struct NameValue<T: PickerType & Singular & Fmt>: View {
    var name: String
    var description: String
    @Binding var value: T
    @State var valueString: String
    var unit: Unit
    var precision: Int
    var options: [T]
    var control: Control = .text
    var edit: Bool

    let nameWidth: Float
    let valueWidth: Float
    var keyboard: UIKeyboardType = .default
    var valueType: NVValueType = .string

    init(_ name: String,
         description: String = "",
         _ value: Binding<T>,
         _ unit: Unit = Unit.gram,
         precision: Int = 0,
         negative: Bool = false,
         options: [T] = [],
         control: Control = .text,
         edit: Bool = false) {

        self.name = name
        self.description = description
        self._value = value
        self._valueString = State(initialValue: value.wrappedValue.displayName.toStr(precision))
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



                } else if control == .picker {

                    // PICKER control for lists (EDIT)
                    Picker("", selection: $value) {
                        ForEach(options, id: \.self) {
                            Text($0.displayName).tag($0)
                        }
                    }
                      .pickerStyle(MenuPickerStyle())
                      .myValue()



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
                    AnyView(Text(unit.singularForm)
                              .font(.caption2)
                              .frame(minWidth: 35, minHeight: 20, alignment: .leading)
                              .border(Color.black, width: 0))
                } else {
                    AnyView(Text(unit.pluralForm)
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
