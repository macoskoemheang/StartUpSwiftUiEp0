import SwiftUI

struct AuthScreenContainer<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        ZStack {
            AuthBackground()

            ScrollView(showsIndicators: false) {
                content
                    .padding()
                    .frame(maxWidth: 480)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
            }
        }
    }
}
