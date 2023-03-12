//
//  EvolutionApp.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//

import SwiftUI
import CloudKit

@main
struct EvolutionApp: App {
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            Start()
                .environment(\.colorScheme, .light)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
struct Start: View {
    @StateObject var launchScreenState :LaunchScreenStateManager = .shared

    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ])var backup:FetchedResults<Backup>
    @StateObject var mainData:MainData = .shared
    @Environment(\.managedObjectContext) private var viewContext
    @State var alertDetails=true
    var body: some View {
        ZStack {
            if mainData.mainBackup != nil{
                ContentView()
            }
            if launchScreenState.state == .launch {
                LaunchScreenView()
            }else if launchScreenState.state == .creationTrainingDay {
                FirstCreationTrainingDay()
            }else if launchScreenState.state == .register {
                Register()
            }
        }.preferredColorScheme(.light)
            .overlay{ManyBackup()}
            .onAppear{
                CKContainer.default().accountStatus { accountStatus, error in
                    DispatchQueue.main.async{
                        mainData.accountStatusICloud = accountStatus
                    }
                }
                mainData.mainBackup = mainData.fetchMainBackup(fetch: backup)

                if let register=mainData.mainBackup?.settings?.register, register{
                        launchScreenState.dismiss()
                }else{
                    launchScreenState.dismissForRegister()
                }
            }.onChange(of: backup.count){ new in
                mainData.mainBackup = mainData.fetchMainBackup(fetch: backup)
                if mainData.mainBackup == nil{
                    launchScreenState.register()
                }
            }.onChange(of: mainData.mainBackup?.settings?.register){ new in
                if new == false{
                    launchScreenState.register()
                }
            }
    }
}
struct Start_Previews: PreviewProvider {
    static var previews: some View {
        Start()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
