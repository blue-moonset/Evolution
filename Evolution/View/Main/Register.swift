//
//  Register.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import SwiftUI

struct Register: View {
    @StateObject var launchScreenState : LaunchScreenStateManager
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        VStack (spacing: 0){
            Spacer()
            Text("Programme tes journées")
            Spacer()
            Button(action: {
                
            }){
                Text("Je programme mes journées")
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                    .frame(width: 300)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            Button(action: {
                if settings.count != 0{
                    launchScreenState.dismissWithoutTime()
                    settings.first!.register=true
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
                    }
                }
            }){
                Text("Je le fais plus tard")
                    .padding(.vertical,20)
                    .frame(width: 300)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom,30).frame(width:UIScreen.main.bounds.width)
        .background(.white)
        .edgesIgnoringSafeArea(.all)
        .onAppear{
            let settings=Settings(context: viewContext)
            settings.firstDay=Date()
            settings.dayLastDeleteDone=Date()
            settings.homePointsGo = 3
            settings.homePointsNone = -4
            settings.clubPointsGo = 10
            settings.clubPointsNone = -6
            settings.register=false
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
            }
        }
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register(launchScreenState: LaunchScreenStateManager())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
