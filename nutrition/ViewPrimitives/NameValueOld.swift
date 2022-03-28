
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
