import SwiftUI
import RiveRuntime   // Swift Package: https://github.com/rive-app/rive-ios

/// Values of the `mood` number input on Kiko's `CharacterStateMachine`.
/// Every Charmotion character uses the same numbers, so this enum works for your own character too.
enum KikoMood: Double, CaseIterable {
    case idle = 0
    case happy = 1
    case wave = 2
    case loading = 5
}

/// Kiko, driven by a plain SwiftUI value. Change `mood` and the character blends into that animation.
struct KikoView: View {
    var mood: KikoMood

    @StateObject private var kiko = RiveViewModel(
        fileName: "kiko",                         // kiko.riv in the app bundle
        stateMachineName: "CharacterStateMachine"
    )

    var body: some View {
        kiko.view()
            .aspectRatio(1, contentMode: .fit)
            .onAppear { kiko.setInput("mood", value: mood.rawValue) }
            .onChange(of: mood) { new in kiko.setInput("mood", value: new.rawValue) }
            .accessibilityLabel("Kiko the fox, \(String(describing: mood))")
    }
}
