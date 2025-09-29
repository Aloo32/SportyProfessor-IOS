import SwiftUI

struct HomeView: View {
    @StateObject private var sportViewModel = SportViewModel()
    @StateObject private var progressViewModel = ProgressViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Constants.Spacing.md) {
                    headerSection
                    sportsSection
                }
                .padding(Constants.Spacing.md)
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.large)
            .background(Constants.Colors.backgroundPrimary)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: Constants.Spacing.sm) {
            Text("Choose Your Sport")
                .font(Constants.Fonts.title)
                .foregroundColor(Constants.Colors.textPrimary)

            Text("Start your journey to becoming a sports expert")
                .font(Constants.Fonts.body)
                .foregroundColor(Constants.Colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var sportsSection: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: Constants.Spacing.md) {
            ForEach(sportViewModel.sports) { sport in
                SportCard(sport: sport) {
                    sportViewModel.selectSport(sport)
                }
            }
        }
        .loading(sportViewModel.isLoading)
    }
}

#Preview {
    HomeView()
}
