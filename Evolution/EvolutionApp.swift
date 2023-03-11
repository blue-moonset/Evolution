//
//  EvolutionApp.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//

import SwiftUI

@main
struct EvolutionApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            Start()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
}
struct Start: View {
    @StateObject var launchScreenState = LaunchScreenStateManager()
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        ZStack {
            if settings.count != 0{
                ContentView()
            }
            if launchScreenState.state == .launch {
                LaunchScreenView()
            }else if launchScreenState.state == .register {
                Register(launchScreenState:launchScreenState)
            }
        }.preferredColorScheme(.light)
            .onChange(of: settings.first?.register){ new in
                if new == false{
                    launchScreenState.register()
                }
            }
            .onAppear{
//                for s in settings{
//                    viewContext.delete(s)
//                }
//                do {
//                    try viewContext.save()
//                } catch {
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
//                }
                if let first=settings.first, first.register{
                        launchScreenState.dismiss()
                }else{
                    launchScreenState.dismissForRegister()
                }
            }
    }
}
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

