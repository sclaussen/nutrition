import SwiftUI

struct MyTabBarContainer<Content:View>: View {
    @Binding var selection: TabBarItem
    let content: Content
    @State private var tabs: [TabBarItem] = []

    init(selection: Binding<TabBarItem>, @ViewBuilder content: () -> Content) {
        self._selection = selection
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()

            MyTabBar(tabs: tabs, selection: $selection, localSelection: selection)

        }
        .onPreferenceChange(TabBarItemsPreferenceKey.self, perform: { value in
            self.tabs = value
        })
    }
}

struct MyTabBarContainer_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
      .base, .adjustments, .meal, .ingredients, .profile
    ]

    static var previews: some View {
        MyTabBarContainer(selection: .constant(tabs.first!)) {
            Color.red
        }
    }
}
