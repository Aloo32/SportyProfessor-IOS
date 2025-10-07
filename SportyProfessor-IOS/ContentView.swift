
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        if appState.isAuthenticated {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }

                PracticeView()
                    .tabItem {
                        Label("Practice", systemImage: "figure.run")
                    }

                SocialView()
                    .tabItem {
                        Label("Social", systemImage: "message.fill")
                    }

                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.fill")
                    }
            }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
