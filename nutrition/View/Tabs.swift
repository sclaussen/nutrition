import SwiftUI

struct Tabs: View {

    @EnvironmentObject var profileMgr: ProfileMgr

    @State var tab: String = "Today"

    var body: some View {

        return TabView(selection: $tab) {


            NavigationView {
                Today()
                  .navigationTitle("Today")
            }
              .tabItem {
                  Image(systemName: "play.fill")
                  Text("Today")
              }
              .tag("Today")


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
