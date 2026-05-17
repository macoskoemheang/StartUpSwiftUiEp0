import SwiftUI

struct AuthBackground: View {
    @State private var isAnimating = false

    var body: some View {
        ZStack {
            AppTheme.background
                .ignoresSafeArea()

            Circle()
                .fill(Color.white.opacity(0.12))
                .frame(width: 260)
                .blur(radius: 4)
                .offset(
                    x: isAnimating ? 145 : 105,
                    y: isAnimating ? -230 : -275
                )
                .scaleEffect(isAnimating ? 1.12 : 0.94)

            Circle()
                .fill(AppTheme.accent.opacity(0.24))
                .frame(width: 220)
                .blur(radius: 10)
                .offset(
                    x: isAnimating ? -105 : -145,
                    y: isAnimating ? 215 : 255
                )
                .scaleEffect(isAnimating ? 0.9 : 1.1)

            Circle()
                .fill(Color.purple.opacity(0.18))
                .frame(width: 170)
                .blur(radius: 18)
                .offset(
                    x: isAnimating ? -90 : -40,
                    y: isAnimating ? -150 : -110
                )
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 5)
                .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

struct AuthCard<Content: View>: View {
    @ViewBuilder let content: Content

    var body: some View {
        VStack(spacing: 20) {content}
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppTheme.card)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(AppTheme.border, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 20, y: 14)
    }
}

struct AuthTextField: View {
    let title: String
    let systemImage: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var isSecure = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .foregroundStyle(.white.opacity(0.65))
                .frame(width: 18)

            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .keyboardType(keyboardType)
            .foregroundStyle(.white)
        }
        .padding()
        .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

struct PrimaryAuthButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.black)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundStyle(.black)
            .background(
                LinearGradient(
                    colors: [Color.white, AppTheme.accent],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 16, style: .continuous)
            )
        }
        .disabled(isLoading)
    }
}
#Preview {
    AuthBackground()
}
