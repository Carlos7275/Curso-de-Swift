import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Pokédex")
                }

        }
    }
}

#Preview {
    ContentView()
}
