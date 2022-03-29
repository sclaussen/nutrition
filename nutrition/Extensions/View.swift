import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // https://www.avanderlee.com/swiftui/conditional-view-modifier/#:~:text=Conditional%20View%20Modifier%20creation%20in,different%20configurations%20to%20your%20views.
    //
    // Applies the given transform if the given condition evaluates to `true`.
    // - Parameters:
    //   - condition: The condition to evaluate.
    //   - transform: The transform to apply to the source `View`.
    // - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    //
    // Usage example:
    //
    // struct ContentView: View {
    //
    //     private var shouldApplyBackground: Bool {
    //         guard #available(iOS 14, *) else {
    //             return true
    //         }
    //         return false
    //     }
    //
    //     var body: some View {
    //         Text("Hello, world!")
    //             .padding()
    //             .if(shouldApplyBackground) { view in
    //                 // We only apply this background color if shouldApplyBackground is true
    //                 view.background(Color.red)
    //             }
    //     }
    // }
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
