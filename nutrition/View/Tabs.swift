import SwiftUI

struct Tabs: View {

    @State var tab: String = "Profile"

    var body: some View {

        TabView(selection: $tab) {


            NavigationView {
                MealList()
            }.tabItem {
                Image(systemName: "fork.knife.circle")
                Text("Meal")
            }.tag("Meal")


            NavigationView {
                AdjustmentList()
                  .navigationTitle("Adjustments")
            }.tabItem {
                Image(systemName: "plus.circle")
                Text("Adjustments")
            }.tag("Adds")


            NavigationView {
                IngredientList()
                  .navigationTitle("Ingredients")
            }.tabItem {
                Image(systemName: "cart.fill")
                Text("Ingredients")
            }.tag("Ingredients")


            NavigationView {
                ProfileEdit(tab: $tab)
                    .navigationTitle("Profile")
            }.tabItem {
                Image(systemName: "person")
                Text("Profile")
            }.tag("Profile")
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
