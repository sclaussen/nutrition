import SwiftUI

struct Tabs: View {

    @EnvironmentObject var profileMgr: ProfileMgr

    @State var tab: String = "Meal"

    var body: some View {

        return TabView(selection: $tab) {


            NavigationView {
                MealView()
                  // .navigationTitle("Meal")
            }
              .tabItem {
                  Image(systemName: "fork.knife.circle")
                  Text("Meal")
              }
              .tag("Meal")


            NavigationView {
                BaseList()
                  .navigationTitle("Base Meal")
            }
              .tabItem {
                  Image(systemName: "list.triangle")
                  Text("Base")
              }
              .tag("Base")


            NavigationView {
                AdjustmentList()
                  .navigationTitle("Adjustments")
            }
              .tabItem {
                  Image(systemName: "plus.circle")
                  Text("Adjustments")
              }
              .tag("Adds")


            NavigationView {
                IngredientList()
                  .navigationTitle("Ingredients")
            }
              .tabItem {
                  Image(systemName: "cart.fill")
                  Text("Ingredients")
              }
              .tag("Ingredients")


            NavigationView {
                ProfileEdit()
                    .navigationTitle("Profile")
            }
              .tabItem {
                  Image(systemName: "person")
                  Text("Profile")
              }
              .tag("Profile")
        }
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
