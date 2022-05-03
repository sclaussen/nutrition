import SwiftUI

private class TextFieldObserver: NSObject {
    @objc
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
}

//private let textFieldObserver = TextFieldObserver()
//    var body: some View {
//            TextField(name, text: field )
//                .introspectTextField { textField in
//                                textField.addTarget(
//                                    self.textFieldObserver,
//                                    action: #selector(TextFieldObserver.textFieldDidBeginEditing),
//                                    for: .editingDidBegin
//                                )
//                            }
//        }
//    }
