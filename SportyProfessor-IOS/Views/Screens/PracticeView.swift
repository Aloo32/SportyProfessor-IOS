import SwiftUI

struct PracticeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Practice")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()

                Spacer()
            }
            .navigationTitle("Practice")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    PracticeView()
}