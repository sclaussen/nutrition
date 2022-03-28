// struct NVPicker<T: PickerType>: View {
//     var name: String
//     @Binding var value: T
//     let options: [T]

//     init(_ name: String, _ value: Binding<T>, options: [T]) {
//         self.name = name
//         self._value = value
//         self.options = options
//     }

//     var body: some View {
//         HStack(alignment: .bottom) {
//             NVName(name)
//             Picker("", selection: $value) {
//                 ForEach(options, id: \.self) {
//                     Text($0.displayName).tag($0)
//                 }
//             }
//               .pickerStyle(MenuPickerStyle())
//               .myValue()
//             NVUnit(value: Int(0), Unit.none)
//         }
//     }
// }

// struct NVToggleEdit: View {
//     var name: String
//     var description: String
//     @Binding var value: Bool

//     init(_ name: String, description: String = "", _ value: Binding<Bool>) {
//         self.name = name
//         self.description = description
//         self._value = value
//     }

//     var body: some View {
//         VStack(alignment: .leading, spacing: 0) {
//             HStack(alignment: .bottom) {
//                 NVName(name)
//                 Toggle("", isOn: $value)
//                   .myValue()
//                   .toggleStyle(CheckmarkToggleStyle())
//                   .border(Color.black, width: 0)
//                 NVUnit(value: Int(0), Unit.none)
//             }
//             NVDescription(description)
//         }
//     }
// }

// struct NVValue<T: Fmt>: View {
//     var value: T
//     var precision: Int
//     var widthPercentage: Float = 0.33

//     init(_ value: T, precision: Int = 0) {
//         self.value = value
//         self.precision = precision
//     }

//     var body: some View {
//         let width = 300 * widthPercentage
//         return HStack {
//             Text(value.toStr(precision))
//               .lineLimit(1)
//               .frame(minWidth: CGFloat(width), minHeight: 20, alignment: .trailing)
//               .border(Color.black, width: 0)
//         }
//     }
// }


// struct NVDateEdit: View {
//     var name: String
//     var description: String
//     @Binding var value: Date

//     init(_ name: String, description: String = "", _ value: Binding<Date>) {
//         self.name = name
//         self.description = description
//         self._value = value
//     }

//     var body: some View {
//         VStack(alignment: .leading, spacing: 0) {
//             HStack(alignment: .bottom) {
//                 NVName(name)
//                 DatePicker("", selection: $value, in: ...Date(), displayedComponents: [.date])
//                   .myValue()
//                   .colorInvert()
//                   .colorMultiply(Color.blue)
//                   .offset(x: 5)
//                 NVUnit(value: Int(0), Unit.none)
//             }
//             NVDescription(description)
//         }
//     }
// }


// struct NVPickerIntEdit: View {
//     var name: String
//     var description: String
//     @Binding var value: Int
//     var options: [String]

//     init(_ name: String, description: String = "", _ value: Binding<Int>, options: [String]) {
//         self.name = name
//         self.description = description
//         self._value = value
//         self.options = options
//     }

//     var body: some View {
//         VStack(alignment: .leading, spacing: 0) {
//             HStack(alignment: .bottom) {
//                 NVName(name)

//                 // Value
//                 Picker("", selection: $value) {
//                     ForEach(0..<options.count, id: \.self) {
//                         Text(options[$0])
//                     }
//                 }
//                   .offset(x: 20)
//                   .myValue()

//                 NVUnit(value: Int(0), Unit.none)
//             }
//             NVDescription(description)
//         }
//     }
// }

//struct NVPickerUnitEdit: View {
//    var name: String
//    var description: String
//    @Binding var value: Unit
//    var options: [Unit]
//
//    init(_ name: String, description: String = "", _ value: Binding<Unit>, options: [Unit]) {
//        self.name = name
//        self.description = description
//        self._value = value
//        self.options = options
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(alignment: .bottom) {
//                NVName(name)
//                Picker("", selection: $value) {
//                    ForEach(options, id: \.self) {
//                        Text($0.rawValue)
//                          .tag($0)
//                    }
//                }
//                  .pickerStyle(MenuPickerStyle())
//                  .offset(x: 20)
//                  .myValue()
//                NVUnit(value: Int(0), Unit.none)
//            }
//            NVDescription(description)
//        }
//    }
//}
//
//struct NVPickerGenderEdit: View {
//    var name: String
//    var description: String
//    @Binding var value: Gender
//    var options: [Gender]
//
//    init(_ name: String, description: String = "", _ value: Binding<Gender>, options: [Gender]) {
//        self.name = name
//        self.description = description
//        self._value = value
//        self.options = options
//    }
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            HStack(alignment: .bottom) {
//                NVName(name)
//                Picker("", selection: $value) {
//                    ForEach(options, id: \.self) {
//                        Text($0.rawValue)
//                          .tag($0)
//                    }
//                }
//                  .offset(x: 20)
//                  .myValue()
//                NVUnit(value: Int(0), Unit.none)
//            }
//            NVDescription(description)
//        }
//    }
//}

// struct NVPickerEdit: View {
//     var name: String
//     var description: String
//     @Binding var value: String
//     var options: [String]

//     init(_ name: String, description: String = "", _ value: Binding<String>, options: [String]) {
//         self.name = name
//         self.description = description
//         self._value = value
//         self.options = options
//     }

//     var body: some View {
//         VStack(alignment: .leading, spacing: 0) {
//             HStack(alignment: .bottom) {
//                 NVName(name)
//                 Picker("", selection: $value) {
//                     ForEach(options, id: \.self) {
//                         Text($0)
//                     }
//                 }
//                   .offset(x: 20)
//                   .myValue()
//                 NVUnit(value: Int(0), Unit.none)
//             }
//             NVDescription(description)
//         }
//     }
// }



// extension String.StringInterpolation {
//     mutating func appendInterpolation(_ value: Unit) {
//         appendInterpolation("My name is shane")
//     }
// }


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

// struct NVUnit<T: Singular>: View {
//     var value: T
//     var unit: Unit

//     init(value: T, _ unit: Unit) {
//         self.value = value
//         self.unit = unit
//     }

//     var body: some View {
v//         if unit == Unit.none {
//             return AnyView(Text("")
//                              .frame(minWidth: 35, minHeight: 20)
//                              .border(Color.black, width: 0))
//         }

//         if value.singular() {
//             return AnyView(Text(unit.singularForm)
//                              .font(.caption2)
//                              .frame(minWidth: 35, minHeight: 20, alignment: .leading)
//                              .border(Color.black, width: 0))
//         }

//         return AnyView(Text(unit.pluralForm)
//                          .font(.caption2)
//                          .frame(minWidth: 35, minHeight: 20, alignment: .leading)
//                          .border(Color.black, width: 0))
//     }
// }

// struct NVDescription: View {
//     var description: String

//     init(_ description: String) {
//         self.description = description
//     }

//     var body: some View {
//         if description.count > 0 {
//             return AnyView(Text(description)
//                              .lineLimit(1)
//                              .frame(minWidth: 050, minHeight: 10, alignment: .leading)
//                              .border(Color.black, width: 0)
//                              .font(.system(size: 9)))
//         }

//         return AnyView(EmptyView())
//     }
// }
