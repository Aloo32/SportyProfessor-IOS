import SwiftUI

struct SocialView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Social")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Text("Add friends and compete")
                    .font(.body)
                    .foregroundColor(.secondary)

                Spacer()
            }
            .navigationTitle("Social")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SocialView()
}