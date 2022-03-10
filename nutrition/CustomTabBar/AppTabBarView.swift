import SwiftUI

struct AppTabBarView: View {
    @State private var selection: String = "meal"
    @State private var tabSelection: TabBarItem = .meal

    var body: some View {
        CustomTabBarContainerView(selection: $tabSelection) {
            TestTabView(text: "1")
                .tabBarItem(tab: .base, selection: $tabSelection)

            TestTabView(text: "2")
                .tabBarItem(tab: .adjustments, selection: $tabSelection)

            TestTabView(text: "3")
                .tabBarItem(tab: .meal, selection: $tabSelection)

            TestTabView(text: "4")
                .tabBarItem(tab: .ingredients, selection: $tabSelection)

            TestTabView(text: "5")
                .tabBarItem(tab: .profile, selection: $tabSelection)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

struct AppTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabBarView()
    }
}

extension AppTabBarView {
    private var defaultTabView: some View {
        TabView(selection: $selection) {
            Color.red
                .tabItem {
                    Image(systemName: "list.triangle")
                    Text("Base")
                }
            Color.blue
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Adjustments")
                }
            Color.orange
                .tabItem {
                    Image(systemName: "fork.knife.circle")
                    Text("Meal")
                }
            Color.blue
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Ingredients")
                }
            Color.blue
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}

struct TestTabView: View {
    let text: String
    @State private var textFieldText: String = ""

    init(text: String) {
        self.text = text
        print("INIT" + text)
    }

    var body: some View {
        VStack {
            Text(text)
                .onAppear {
                    print("ONAPPEAR" + text)
            }
            TextField("Type something...", text: $textFieldText)
                .disableAutocorrection(true)
        }
    }
}
