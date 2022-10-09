import SwiftUI


struct VitaminMineralList: View {

    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var profileMgr: ProfileMgr


    var body: some View {
        List {

            VitaminMineralRowHeader()
              .listRowInsets(EdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10))

            ForEach(vitaminMineralMgr.getAll(age: profileMgr.profile.age, gender: profileMgr.profile.gender)) { vitaminMineral in
                VitaminMineralRow(name: vitaminMineral.name,
                                  min: vitaminMineral.min,
                                  max: vitaminMineral.max,
                                  unit: Unit.gram)
            }
        }
    }
}
