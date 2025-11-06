import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // Primera pestaña: Pokédex
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
