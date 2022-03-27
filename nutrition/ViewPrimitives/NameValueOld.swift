
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
