import SwiftUI

protocol ValueType: Codable, Hashable, CaseIterable where AllCases: RandomAccessCollection {
    func formattedString(_ max: Int) -> String
    func singular() -> Bool
}

//extension ValueType {
//    func formattedString(_ max: Int = -1) -> String {
//        return formattedString(max)
//    }
//}

enum Control {
    case text
    case toggle
    case date
    case picker
}

enum ScalerType {
    case int
    case double
    case bool
    case date
    case string
}

struct NameValue<T: ValueType>: View {
    var name: String
    var description: String
    @Binding var value: T
    var unit: Unit
    var precision: Int
    var options: [T]
    var control: Control
    var validator: Bool
    var edit: Bool

    var keyboard: UIKeyboardType = .default
    var valueScalerType: ScalerType = .string
    var wideValue: Bool = false


    init(_ name: String,
         description: String = "",
         _ value: Binding<T>,
         _ unit: Unit = Unit.gram,
         precision: Int = 0,
         negative: Bool = false,
         options: [T] = [],
         control: Control = .text,
         validator: Bool = true,
         edit: Bool = false) {

        self.name = name
        self.description = description
        self._value = value
        self.precision = precision

        self.unit = (control == .text && type(of: value.wrappedValue) != String.self) ? unit : .none
        self.options = options
        self.control = control
        self.validator = validator
        self.edit = (control == .text) ? edit : true

        self.valueScalerType = getValueScalerType(value.wrappedValue)
        self.keyboard = getKeyboard(valueScalerType, negative)

        self.wideValue = control == .text && $value.wrappedValue.formattedString(precision).count > 7
    }

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {

                HStack(spacing: 0) {

                    // Name
                    Text(name)
                      .name(geo, wideValue)
                      .foregroundColor(Color.theme.blackWhite)
                      .if (!description.isEmpty) { view in
                          view.offset(x: -2, y: -7)
                      }

                    // TEXT/TEXTFIELD controls
                    if control == .text {
                        if !edit {
                            // TEXT control for text values (VIEW)
                            Text(value.formattedString(precision))
                              .value(geo, wideValue, unit)
                              .foregroundColor(Color.theme.blackWhite)
                              .if (!description.isEmpty) { view in
                                  view.offset(x: -2)
                              }
                        } else {
                            // TEXTFIELD control for text values (EDIT)
                            NVTextField(geo: geo,
                                        name: name,
                                        description: description,
                                        value: _value,
                                        unit: unit,
                                        precision: precision,
                                        validator: validator,
                                        valueScalerType: valueScalerType,
                                        keyboard: keyboard)
                              .if (!description.isEmpty) { view in
                                  view.offset(x: -2)
                              }
                        }
                    }

                    // TOGGLE control for boolean values (EDIT)
                    if control == .toggle {
                        Toggle("", isOn: Binding(get: { $value.wrappedValue as! Bool }, set: { $value.wrappedValue = $0 as! T }))
                          .value(geo, false, .none)
                          .foregroundColor(Color.theme.blueYellow)
                          .toggleStyle(CheckmarkToggleStyle())
                    }

                    // PICKER control for lists (EDIT)
                    if control == .picker {
                        Picker("", selection: $value) {
                            ForEach(options, id: \.self) {
                                Text($0.formattedString(-1)).tag($0)
                                  .value(geo, false, .none)
                                  .accentColor(Color.theme.blueYellow)
                            }
                        }
                          .value(geo, false, .none)
                          .labelsHidden()
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color.theme.blueYellow)
                    }

                    // DATE control for date values (EDIT)
                    if control == .date {
                        DatePicker("", selection: Binding(get: { $value.wrappedValue as! Date }, set: { $value.wrappedValue = $0 as! T }), in: ...Date(), displayedComponents: [.date])
                          .value(geo, false, .none)
                          .labelsHidden()
                          .foregroundColor(Color.theme.blueYellow)
                          .colorMultiply(Color.theme.blueYellow)
                    }

                    // Unit
                    if unit != .none {
                        if value.singular() {
                            AnyView(Text(unit.singularForm)
                                      .unit(geo)
                                      .if (edit) { view in
                                          view.foregroundColor(Color.theme.blueYellowSecondary)
                                      }
                                      .if (!edit) { view in
                                          view.foregroundColor(Color.theme.blackWhiteSecondary)
                                      }
                                      .if (!description.isEmpty) { view in
                                          view.offset(x: -2)
                                      }
                            )
                        } else {
                            AnyView(Text(unit.pluralForm)
                                      .unit(geo)
                                      .if (edit) { view in
                                          view.foregroundColor(Color.theme.blueYellowSecondary)
                                      }
                                      .if (!edit) { view in
                                          view.foregroundColor(Color.theme.blackWhiteSecondary)
                                      }
                                      .if (!description.isEmpty) { view in
                                          view.offset(x: -2)
                                      }
                            // .overlay(ZStack {
                            //     Image(systemName: "xmark")
                            //         .foregroundColor(.red)
                            //         .opacity(validator ? 0.0 : 0.8)
                            //     Image(systemName: "checkmark")
                            //         .foregroundColor(.green)
                            //         .opacity(validator ? 0.8 : 0.0)
                            // }                            .font(.title)
                            //     .padding(.trailing)
                            //          , alignment: .trailing)
                            )
                        }
                    }
                }

                // Description
                if !description.isEmpty {
                    AnyView(Text(description)
                              .description(geo)
                              .foregroundColor(Color.theme.blackWhiteSecondary)
                              .offset(y: -13))
                }
            }
        }
    }

    func getValueScalerType(_ value: Any) -> ScalerType {
        if type(of: value) == Int.self {
            return .int
        }
        if type(of: value) == Double.self {
            return .double
        }
        if type(of: value) == Bool.self {
            return .bool
        }
        if type(of: value) == Date.self {
            return .date
        }
        return .string
    }

    func getKeyboard(_ valueScalerType: ScalerType, _ negative: Bool) -> UIKeyboardType {
        if valueScalerType == .int {
            return negative ? .default : .numberPad
        }
        if valueScalerType == .double {
            return negative ? .default : .decimalPad
        }
        return .default
    }
}

struct NVTextField<T: ValueType>: View {
    @State var isEditing: Bool = false
    @State var editingString: String = ""

    var geo: GeometryProxy
    var name: String
    var description: String
    @Binding var value: T
    var unit: Unit
    var precision: Int
    var validator: Bool
    var valueScalerType: ScalerType
    var keyboard: UIKeyboardType

    @State var valueString: String

    init(geo: GeometryProxy, name: String, description: String, value: Binding<T>, unit: Unit, precision: Int, validator: Bool, valueScalerType: ScalerType, keyboard: UIKeyboardType) {
        self.geo = geo
        self.name = name
        self.description = description
        self._value = value
        self.unit = unit
        self.precision = precision
        self.keyboard = keyboard
        self.valueScalerType = valueScalerType
        self.validator = validator

        self._valueString = State(initialValue: value.wrappedValue.formattedString(precision))
    }

    var body: some View {

        TextField(name, text: Binding(get: {
            if isEditing {
                return editingString
            }
            return $value.wrappedValue.formattedString(precision)
        },
                                      set: { string in
            editingString = string
            if valueScalerType == .double {
                if let string = Double(string) {
                    $value.wrappedValue = string as! T
                }
            } else if valueScalerType == .int {
                if let string = Int(string) {
                    $value.wrappedValue = string as! T
                }
            } else {
                $value.wrappedValue = string as! T
            }

            print("\nSet:")
            print("editingString", editingString)
            print("value.wrappedValue", $value.wrappedValue)
        }),
                  onEditingChanged: { isEditing in
                      self.isEditing = isEditing
                      editingString = $value.wrappedValue.formattedString(precision)
                      print("\nonEditingChanged:")
                      print("editingString", editingString)
                      print("value.wrappedValue", $value.wrappedValue)
                  })
          .value(geo, valueString.count > 7, unit)
          .onReceive(NotificationCenter.default.publisher(for: UITextField.textDidBeginEditingNotification)) { obj in
              if let textEdit = obj.object as? UITextField {
                  textEdit.selectedTextRange = textEdit.textRange(from: textEdit.beginningOfDocument, to: textEdit.endOfDocument)
              }
          }
          .autocapitalization(UITextAutocapitalizationType.words)
          .foregroundColor(Color.theme.blueYellow)
          .keyboardType(keyboard)
          .onSubmit {
              print("\nonSubmit:")
              print($value.wrappedValue)
          }
    }
}
