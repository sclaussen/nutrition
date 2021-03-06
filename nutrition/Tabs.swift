import SwiftUI

struct Tabs: View {
    @State var tab: String = "Meal"

    init() {
        // UITabBar.appearance().backgroundColor = UIColor(Color("Tab"))
        // UITabBar.appearance().barTintColor = UIColor(Color.green.opacity(0.5))
    }

    var body: some View {

        TabView(selection: $tab) {


            NavigationView {
                MealList()
                  .hiddenNavigationBarStyle()
            }.tabItem {
                Image(systemName: "fork.knife.circle")
                Text("Meal")
            }.tag("Meal")
              .navigationViewStyle(StackNavigationViewStyle())


            NavigationView {
                AdjustmentList()
                  .hiddenNavigationBarStyle()
                  // .navigationTitle("Adjustments")
            }.tabItem {
                Image(systemName: "plus.circle")
                Text("Adjustments")
            }.tag("Adds")
              .navigationViewStyle(StackNavigationViewStyle())


            NavigationView {
                IngredientList()
                  .hiddenNavigationBarStyle()
                  // .navigationTitle("Ingredients")
            }.tabItem {
                Image(systemName: "cart.fill")
                Text("Ingredients")
            }.tag("Ingredients")
              .navigationViewStyle(StackNavigationViewStyle())


            NavigationView {
                ProfileEdit(tab: $tab)
                  .hiddenNavigationBarStyle()
                  // .navigationTitle("Profile")
            }.tabItem {
                Image(systemName: "person")
                Text("Profile")
            }.tag("Profile")
              .navigationViewStyle(StackNavigationViewStyle())
        }
          .accentColor(Color.theme.blueYellow)
    }
}

// struct ContentView_Previews: PreviewProvider {
//     @StateObject static var ingredientMgr: IngredientMgr = IngredientMgr()
//     @StateObject static var profileMgr: ProfileMgr = ProfileMgr()

//     static var previews: some View {
//         Tabs(profile: profileMgr.profile!)
//             .environmentObject(ingredientMgr)
//     }
// }
