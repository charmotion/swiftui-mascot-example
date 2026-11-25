import SwiftUI

/// A tiny app whose state drives the mascot: tap a button, or run a fake save that goes
/// loading -> happy -> idle the way a real network call would.
struct ContentView: View {
    @State private var mood: KikoMood = .idle
    @State private var saving = false

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)

            KikoView(mood: mood)
                .frame(maxWidth: 320)

            Text(caption)
                .font(.headline)
                .foregroundStyle(.secondary)
                .animation(.default, value: mood)

            HStack(spacing: 12) {
                moodButton("Wave", .wave, "hand.wave")
                moodButton("Loading", .loading, "arrow.triangle.2.circlepath")
                moodButton("Happy", .happy, "face.smiling")
            }

            Button {
                Task { await fakeSave() }
            } label: {
                Label(saving ? "Saving..." : "Simulate a save", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(saving)

            Button("Back to idle") { mood = .idle }
                .font(.footnote)
                .disabled(mood == .idle || saving)

            Spacer(minLength: 0)

            Link("Animate your own character at charmotion.app", destination: URL(string: "https://charmotion.app/app-mascot-animation")!)
                .font(.footnote)
        }
        .padding(24)
        .background(Color(red: 1, green: 0.957, blue: 0.91).ignoresSafeArea())
    }

    private var caption: String {
        switch mood {
        case .idle: return "Idle: breathing and blinking"
        case .happy: return "Happy: good news"
        case .wave: return "Wave: hello!"
        case .loading: return "Loading: working on it"
        }
    }

    private func moodButton(_ title: String, _ value: KikoMood, _ icon: String) -> some View {
        Button {
            mood = value
        } label: {
            Label(title, systemImage: icon)
                .labelStyle(.titleAndIcon)
                .font(.subheadline.weight(.semibold))
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
        .tint(mood == value ? .orange : .accentColor)
        .disabled(saving)
    }

    /// The pattern most apps need: show loading while work runs, celebrate when it lands, then settle.
    private func fakeSave() async {
        saving = true
        mood = .loading
        try? await Task.sleep(nanoseconds: 2_000_000_000)   // your network call goes here
        mood = .happy
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        mood = .idle
        saving = false
    }
}

#Preview { ContentView() }
