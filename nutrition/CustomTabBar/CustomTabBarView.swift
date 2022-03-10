import SwiftUI

struct CustomTabBarView: View {
    let tabs: [TabBarItem]
    @Binding var selection: TabBarItem
    @Namespace private var namespace
    @State var localSelection: TabBarItem

    var body: some View {
        tabBar
          .onChange(of: selection,
                    perform: { value in
                        withAnimation(.easeInOut) {
                            localSelection = value
                        }
                    })
    }
}

struct CustomTabBarView_Previews: PreviewProvider {
    static let tabs: [TabBarItem] = [
      .base, .adjustments, .meal, .ingredients, .profile
    ]

    static var previews: some View {
        VStack {
            Spacer()
            CustomTabBarView(tabs: tabs, selection: .constant(tabs.first!), localSelection: tabs.first!)
        }
    }
}

extension CustomTabBarView {
    private var tabBar: some View {
        HStack {
            ForEach(tabs, id: \.self) { tab in
                tabItem(tab: tab)
                  .onTapGesture {
                      switchToTab(tab: tab)
                  }
            }
        }
          .padding(6)
          .background(Color.white.ignoresSafeArea(edges: .bottom))
          .cornerRadius(10)
          .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
          .padding(.horizontal)
    }

    private func tabItem(tab: TabBarItem) -> some View {
        VStack {
            Image(systemName: tab.iconName)
              .font(.subheadline)
            Text(tab.title)
              .font(.system(size: 10, weight: .semibold, design: .rounded))
        }
          .foregroundColor(localSelection == tab ? tab.color : Color.gray)
          .padding(.vertical, 8)
          .frame(maxWidth: .infinity)
          .background(
            ZStack {
                if localSelection == tab {
                    RoundedRectangle(cornerRadius: 10)
                      .fill(tab.color.opacity(0.2))
                      .matchedGeometryEffect(id: "background_rectangle", in: namespace)
                }
            }
          )
    }
}
