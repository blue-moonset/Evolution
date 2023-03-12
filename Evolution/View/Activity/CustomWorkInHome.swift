//
//  CustomWorkInHome.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 16/03/2023.
//

import SwiftUI
import CoreData

struct CustomWorkInHome: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var mainData:MainData = .shared
    @StateObject var field=Field()
    @State var showSheet=false
    @State var showAlert=false
    @State var workInHomeInUpdate:WorkInHome?
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.5)
            List{
                Section (header:Text("Modifier mes exercices à la maison")){
                    Button(action: {
                        showSheet=true
                        mainData.typeSheet = .addWorkInHome
                    }){
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                            Text("Ajouter un exercice à la maison")
                            Spacer()
                        }
                    }
                }
                Section{
                    ForEach(mainData.mainBackup!.allWorkInHome()) { item in
                        Button(action: {
                            showSheet=true
                            workInHomeInUpdate=item
                            mainData.typeSheet = .updateWorkInHome
                        }){
                            Text(item.name.capitalizedSentence)
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }.navigationTitle("Changer mon programme")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSheet){
                Form{
                    Section(header: Text("Nom")) {
                        TextField("Nom", text: $field.name)
                    }
                    Section {
                        Button(action: {
                            save()
                        }){
                            HStack {
                                Spacer()
                                Text("Enregistrer")
                                    .fontWeight(.semibold)
                                Spacer()
                            }.foregroundColor(.blue)
                        }
                    }
                    Section {
                        Button(action: {
                            showSheet=false
                            impactLight()
                        }){
                            HStack {
                                Spacer()
                                Text("Annuler")
                                    .fontWeight(.semibold)
                                Spacer()
                            }.foregroundColor(.red)
                        }
                        
                    }
                    if mainData.typeSheet == .updateWorkInHome{
                        Section{
                            Button(action: {
                                showAlert=true
                                print("ldlldld")
                            }){
                                HStack {
                                    Spacer()
                                    Image(systemName: "trash.fill")
                                    Text("Supprimer")
                                        .fontWeight(.semibold)
                                    Spacer()
                                }.foregroundColor(.red)
                            }
                        }.actionSheet(isPresented: $showAlert) {
                            ActionSheet(
                                title: Text("Êtes-vous sûre de vouloir supprimer cet exercice ?"),
//                                message: Text("Vous pouvez toujours archiver cet exercice"),
                                buttons:[
                                    .cancel(),
                                    .destructive(Text("Supprimer l'exercice"), action: {
                                        emptyTrashAction()
                                    })
                                ]
                            )}
                    }
                }.onAppear{
                    if mainData.typeSheet == .updateWorkInHome{
                        field.name=workInHomeInUpdate!.name.capitalizedSentence
                    }else{
                        field.name=""
                    }
                }
            }
    }
    func emptyTrashAction() {
        viewContext.delete(workInHomeInUpdate!)
        
        do {
            try viewContext.save()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        showSheet=false
    }
    func save(){
        if mainData.typeSheet == .addWorkInHome{
            let workInHome=WorkInHome(context: viewContext)
            workInHome.name=field.name
            workInHome.id=UUID()
            workInHome.active=true
            mainData.mainBackup!.addToWorkInHome(workInHome)
        }else{
            workInHomeInUpdate!.name=field.name
        }
        do {
            try viewContext.save()
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        showSheet=false
    }
}
struct CustomWorkInHome_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            CustomWorkInHome()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}
