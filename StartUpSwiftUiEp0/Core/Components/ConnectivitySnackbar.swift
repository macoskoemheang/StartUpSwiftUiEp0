import SwiftUI

struct ConnectivitySnackbar: View {
    let state: ConnectivityMonitor.State
    let waitingRequestCount: Int

    private var content: (title: String, subtitle: String, icon: String, color: Color)? {
        switch state {
        case .checking:
            return nil
        case .connected:
            return (
                title: "Back online",
                subtitle: "Connection restored",
                icon: "wifi",
                color: Color(red: 0.34, green: 0.88, blue: 0.62)
            )
        case .disconnected:
            return (
                title: "No internet connection",
                subtitle: waitingRequestCount > 0
                    ? "\(waitingRequestCount) request\(waitingRequestCount == 1 ? "" : "s") waiting to resume"
                    : "API actions will wait and resume automatically",
                icon: "wifi.slash",
                color: Color(red: 1.0, green: 0.47, blue: 0.47)
            )
        }
    }

    var body: some View {
        if let content {
            HStack(spacing: 14) {
                Image(systemName: content.icon)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 36, height: 36)
                    .foregroundStyle(.white)
                    .background(content.color.opacity(0.28), in: Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text(content.title)
                        .font(.subheadline.weight(.semibold))
                    Text(content.subtitle)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.72))
                }

                Spacer(minLength: 0)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.black.opacity(0.52))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.16), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.24), radius: 16, y: 10)
            .padding(.horizontal)
        }
    }
}
