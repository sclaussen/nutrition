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

enum NVControl: CaseIterable {
    case text
    case toggle
    case date
    case picker
}

enum NVValueType {
    case int
    case float
    case bool
    case date
    case string
}

struct NameValue<T: NVValueTypeProtocol>: View {
    var name: String
    var description: String
    @Binding var value: T
    var unit: Unit
    var precision: Int
    var options: [T]
    var control: NVControl
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
         edit: Bool = false) {

        self.name = name
        self.description = description
        self._value = value
        self.precision = precision

        self.unit = (control == .text && type(of: value.wrappedValue) != String.self) ? unit : .none
        self.options = options
        self.control = control
        self.edit = (control == .text) ? edit : true

        self.valueType = getValueType(value)
        self.keyboard = getKeyboard(valueType, negative)
    }

    var body: some View {
        GeometryReader { geo in
            // VStack(alignment: .leading, spacing: 0) {
            //     HStack(alignment: .bottom, spacing: 0) {
            VStack(spacing: 0) {

                HStack(spacing: 0) {

                    // Name
                    Text(name)
                      .name(geo)
                      .if (!description.isEmpty) { view in
                          view.offset(x: -2, y: -7)
                      }

                    // TEXT/TEXTFIELD controls
                    if control == .text {
                        if !edit {
                            // TEXT control for text values (VIEW)
                            Text(value.string(precision))
                              .value(geo)
                              .if (!description.isEmpty) { view in
                                  view.offset(x: -2)
                              }
                        } else {
                            // TEXTFIELD control for text values (EDIT)
                            NVTextField(geo: geo,
                                        name: name,
                                        description: description,
                                        value: _value,
                                        precision: precision,
                                        valueType: valueType,
                                        keyboard: keyboard)
                              .if (!description.isEmpty) { view in
                                  view.offset(x: -2)
                              }
                        }
                    }

                    // TOGGLE control for boolean values (EDIT)
                    if control == .toggle {
                        Toggle("", isOn: Binding(get: { $value.wrappedValue as! Bool }, set: { $value.wrappedValue = $0 as! T }))
                          .value(geo)
                          .foregroundColor(.blue)
                          .toggleStyle(CheckmarkToggleStyle())
                    }

                    // PICKER control for lists (EDIT)
                    if control == .picker {
                        Picker("", selection: $value) {
                            ForEach(options, id: \.self) {
                                Text($0.string()).tag($0)
                                  .value(geo)
                                  .foregroundColor(.blue)
                            }
                        }
                          .value(geo)
                          .foregroundColor(.blue)
                          .labelsHidden()
                          .pickerStyle(MenuPickerStyle())
                    }

                    // DATE control for date values (EDIT)
                    if control == .date {
                        DatePicker("", selection: Binding(get: { $value.wrappedValue as! Date }, set: { $value.wrappedValue = $0 as! T }), in: ...Date(), displayedComponents: [.date])
                          .value(geo)
                          .labelsHidden()
                          .foregroundColor(.blue)
                          .colorInvert()
                          .colorMultiply(Color.blue)
                    }

                    // Unit
                    if value.singular() {
                        AnyView(Text(unit.singularForm)
                                  .unit(geo)
                                  .if (edit) { view in
                                      view.foregroundColor(.blue)
                                  }
                                  .offset(x: 5)
                                  .if (!description.isEmpty) { view in
                                      view.offset(x: -2)
                                  }
                        )
                    } else {
                        AnyView(Text(unit.pluralForm)
                                  .unit(geo)
                                  .if (edit) { view in
                                      view.foregroundColor(.blue)
                                  }
                                  .offset(x: 5)
                                  .if (!description.isEmpty) { view in
                                      view.offset(x: -2)
                                  }
                        )
                    }
                }

                // Description
                if !description.isEmpty {
                    AnyView(Text(description)
                              .description(geo)
                              .offset(y: -13))
                }
            }
        }
    }

    func getValueType(_ value: Binding<T>) -> NVValueType {
        if type(of: value.wrappedValue) == Int.self {
            return .int
        }
        if type(of: value.wrappedValue) == Float.self {
            return .float
        }
        if type(of: value.wrappedValue) == Bool.self {
            return .bool
        }
        if type(of: value.wrappedValue) == Date.self {
            return .date
        }
        return .string
    }

    func getKeyboard(_ valueType: NVValueType, _ negative: Bool) -> UIKeyboardType {
        if valueType == .int {
            return negative ? .default : .numberPad
        }
        if valueType == .float {
            return negative ? .default : .decimalPad
        }
        return .default
    }
}

struct NVTextField<T: NVValueTypeProtocol>: View {
    var geo: GeometryProxy
    var name: String
    var description: String
    @Binding var value: T
    var valueType: NVValueType
    var keyboard: UIKeyboardType

    @State var valueString: String

    init(geo: GeometryProxy, name: String, description: String, value: Binding<T>, precision: Int, valueType: NVValueType, keyboard: UIKeyboardType) {
        self.geo = geo
        self.name = name
        self.description = description
        self._value = value
        self.valueType = valueType
        self.keyboard = keyboard

        self._valueString = State(initialValue: value.wrappedValue.string(precision))
    }

    var body: some View {

        // TEXTFIELD control for text values (EDIT)
        TextField(description.count > 0 ? description : name, text: $valueString)
          .value(geo)
          .autocapitalization(UITextAutocapitalizationType.words)
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
}
