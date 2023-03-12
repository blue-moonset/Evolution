//
//  LaunchScreenView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//

import Foundation
enum LaunchScreenStep {
    case launch
    case register
    case creationTrainingDay
    case finished
}
final class LaunchScreenStateManager: ObservableObject {
    static var shared=LaunchScreenStateManager()
    @MainActor
    @Published private(set) var state: LaunchScreenStep = .launch
    
    @MainActor
    func dismiss() {
        Task {
            try? await Task.sleep(for: Duration.seconds(1))
            self.state = .finished
        }
    }
    @MainActor
    func dismissForRegister() {
        Task {
            try? await Task.sleep(for: Duration.seconds(1))
            self.state = .register
        }
    }
    @MainActor
    func dismissWithoutTime() {
        self.state = .finished
    }
    @MainActor
    func creationTrainingDay() {
        self.state = .creationTrainingDay
    }
    @MainActor
    func register() {
        self.state = .register
    }
}
import SwiftUI
extension Color {
    static let launchScreenBackground = Color("launchScreenBackground")
}
struct LaunchScreenView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    @State private var firstAnimation = false
    
    var body: some View {
        ZStack {
            Color.launchScreenBackground.ignoresSafeArea()
            Image("iconeTrajectory")
        }
    }
    
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LaunchScreenStateManager())
    }
}
