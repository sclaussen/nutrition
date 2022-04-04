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
                      .foregroundColor(Color("Black"))
                      .if (!description.isEmpty) { view in
                          view.offset(x: -2, y: -7)
                      }

                    // TEXT/TEXTFIELD controls
                    if control == .text {
                        if !edit {
                            // TEXT control for text values (VIEW)
                            Text(value.formattedString(precision))
                              .value(geo, wideValue, unit)
                              .foregroundColor(Color("Black"))
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
                          .foregroundColor(Color("Blue"))
                          .toggleStyle(CheckmarkToggleStyle())
                    }

                    // PICKER control for lists (EDIT)
                    if control == .picker {
                        Picker("", selection: $value) {
                            ForEach(options, id: \.self) {
                                Text($0.formattedString(-1)).tag($0)
                                  .value(geo, false, .none)
                                  .accentColor(Color("Blue"))
                            }
                        }
                          .value(geo, false, .none)
                          .labelsHidden()
                          .pickerStyle(MenuPickerStyle())
                          .accentColor(Color("Blue"))
                    }

                    // DATE control for date values (EDIT)
                    if control == .date {
                        DatePicker("", selection: Binding(get: { $value.wrappedValue as! Date }, set: { $value.wrappedValue = $0 as! T }), in: ...Date(), displayedComponents: [.date])
                          .value(geo, false, .none)
                          .labelsHidden()
                          .foregroundColor(Color("Blue"))
                          .colorMultiply(Color("Blue"))
                    }

                    // Unit
                    if unit != .none {
                        if value.singular() {
                            AnyView(Text(unit.singularForm)
                                      .unit(geo)
                                      .if (edit) { view in
                                          view.foregroundColor(Color("BlueLight"))
                                      }
                                      .if (!edit) { view in
                                          view.foregroundColor(Color("BlackLight"))
                                      }
                                      .if (!description.isEmpty) { view in
                                          view.offset(x: -2)
                                      }
                            )
                        } else {
                            AnyView(Text(unit.pluralForm)
                                      .unit(geo)
                                      .if (edit) { view in
                                          view.foregroundColor(Color("BlueLight"))
                                      }
                                      .if (!edit) { view in
                                          view.foregroundColor(Color("BlackLight"))
                                      }
                                      .if (!description.isEmpty) { view in
                                          view.offset(x: -2)
                                      }
                            )
                        }
                    }
                }

                // Description
                if !description.isEmpty {
                    AnyView(Text(description)
                              .description(geo)
                              .foregroundColor(Color("BlackLight"))
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

        // TextField(name, text: Binding(get: {
        //     if isEditing {
        //         return editingString
        //     }
        //     return $value.wrappedValue.formattedString(precision)
        // },
        //                               set: { string in
        //     editingString = string
        //     if valueScalerType == .double {
        //         if let string = Double(string) {
        //             $value.wrappedValue = string as! T
        //         }
        //     } else if valueScalerType == .int {
        //         if let string = Int(string) {
        //             $value.wrappedValue = string as! T
        //         }
        //     } else {
        //         $value.wrappedValue = string as! T
        //     }

        //     print("\nSet:")
        //     print("editingString", editingString)
        //     print("value.wrappedValue", $value.wrappedValue)
        // }),
        //           onEditingChanged: { isEditing in
        //               self.isEditing = isEditing
        //     editingString = $value.wrappedValue.formattedString(precision)
        //               print("\nonEditingChanged:")
        //               print("editingString", editingString)
        //     print("value.wrappedValue", $value.wrappedValue)
        //           })
        //   .overlay(ZStack {
        //                image(systemname: "xmark")
        //                  .foregroundcolor(.red)
        //                  .opacity(validator ? 0.0 : 0.8)
        //                image(systemname: "checkmark")
        //                  .foregroundcolor(.green)
        //                  .opacity(validator ? 0.8 : 0.0)
        //            }
        //              .font(.title)
        //              .padding(.trailing)
        //           , alignment: .trailing)
        //   .onsubmit {
        //       print("\nonsubmit:")
        //       print($value.wrappedvalue)
        //   }

        // TEXTFIELD control for text values (EDIT)
        TextField(description.count > 0 ? description : name, text: $valueString
//                  onEditingChanged: { isEditing in
//                      self.isEditing = isEditing
//            editingString = $value.wrappedValue.formattedString(precision)
//                      print("\nonEditingChanged:")
//                      print("editingString", editingString)
//            print("value.wrappedValue", $value.wrappedValue)
//                  })
                  )
          .value(geo, valueString.count > 7, unit)
          .autocapitalization(UITextAutocapitalizationType.words)
          .foregroundColor(Color("Blue"))
          .keyboardType(keyboard)
          .onChange(of: valueString) { (newValue) in
              print(valueScalerType)
              if valueScalerType == .int {
                  print("\nConvering int")
                  if let convertedValue = Int(newValue) {
                      value = convertedValue as! T
                      valueString = value.formattedString(precision)
                      print(valueString)
                  } else {
                      print("Error...")
                  }
              } else if valueScalerType == .double {
                  print("\nConvering double")
                  if let convertedValue = Double(newValue) {
                      value = convertedValue as! T
                      valueString = value.formattedString(precision)
                      print(valueString)
                  } else {
                      print("Error...")
                  }
              } else {
                  print("\nConvering string")
                  value = newValue as! T
                  valueString = value.formattedString(precision)
                  print(valueString)
              }
          }
    }
}
