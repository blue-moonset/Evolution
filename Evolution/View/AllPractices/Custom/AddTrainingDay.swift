//
//  AddTrainingDay.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import SwiftUI
import CoreData

struct AddTrainingDay: View {
    @StateObject var field=Field()
    @StateObject var mainData:MainData = .shared
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $field.name)
            }
            SF(sFSelect:$field.symbol)
                .frame(width: UIScreen.main.bounds.width)
                .listRowBackground(Color(.secondarySystemBackground))
            Section {
                Button(action: {
                    mainData.presentedSheet=false
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
            Section {
                Button(action: {
                    let trainingDay=TrainingDay(context: viewContext)
                    trainingDay.name=field.name
                    trainingDay.icone=field.symbol ?? ""
                    trainingDay.index=Int16(mainData.mainBackup!.allTrainingDay().count)
                    trainingDay.active=true
                    trainingDay.id=UUID()
                    mainData.mainBackup!.addToTrainingDay(trainingDay)
                    do {
                        try viewContext.save()
                        mainData.presentedSheet=false
                        impactLight()
                        
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }){
                    HStack {
                        Spacer()
                        Text("Enregistrer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.blue)
                }
            }
        }.onAppear{
            field.name=""
            field.symbol=nil
        }
    }
}

struct AddTrainingDay_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            AddTrainingDay().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}

struct UpdateTrainingDay: View {
    @StateObject var field=Field()
    @StateObject var mainData:MainData = .shared
   
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAlert = false
    
    
    var body: some View {
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $field.name)
            }
            Section {
                SF(sFSelect:$field.symbol)
            }.frame(width: UIScreen.main.bounds.width)
                .listRowBackground(Color(.secondarySystemBackground))
            
            Section {
                Button(action: {
                    
                    mainData.trainingDaySelect!.name=field.name
                    mainData.trainingDaySelect!.icone=field.symbol ?? ""
                    do {
                        try viewContext.save()
                        mainData.presentedSheet=false
                        impactLight()
                        
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
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
                    mainData.presentedSheet=false
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
            Section{
                Button(action: {
                   showAlert=true
                }){
                    HStack {
                        Spacer()
                        Image(systemName: "trash.fill")
                        Text("Supprimer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.red)
                }
            }
        }.onAppear{
            field.name=mainData.trainingDaySelect!.name.capitalizedSentence
            field.symbol=mainData.trainingDaySelect!.icone
        }.actionSheet(isPresented: $showAlert) {
            ActionSheet(
                title: Text("Êtes-vous sûre de vouloir supprimer cette journée ?"),
                message: Text("Choisissez si vous voulez supprimer ou archiver les exercices de la journée"),
                buttons:[
                    .cancel(),
                    .destructive(Text("Supprimer la journée"), action: {
                        emptyTrashAction()
                    }),
                    .destructive(Text("Supprimer la journée et ses exercices"), action: {
                        emptyTrashAndArchiveAction()
                    })
                ]
            )}
    }
    func emptyTrashAction() {
        mainData.mainBackup!.removeFromTrainingDay(mainData.trainingDaySelect!)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        for (index,item) in mainData.mainBackup!.allTrainingDay().enumerated(){
            item.index=Int16(index)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        mainData.presentedSheet=false
        impactLight()
    }
    func emptyTrashAndArchiveAction() {
        mainData.trainingDaySelect!.allPracticeWithHidden().forEach({mainData.mainBackup!.getArchive()[0].addToPractice($0)})
        
        mainData.mainBackup!.removeFromTrainingDay(mainData.trainingDaySelect!)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        for (index,item) in mainData.mainBackup!.allTrainingDay().enumerated(){
            item.index=Int16(index)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        mainData.presentedSheet=false
        impactLight()
    }
}

struct UpdateTrainingDay_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            UpdateTrainingDay()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        mainData.trainingDaySelect=mainData.mainBackup!.allTrainingDay()[0]
        return true
    }
}


struct OrderTrainingDay: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var trainingDayForOrder:[TrainingDay]
    
    @StateObject var mainData:MainData = .shared
    var body: some View {
        Form{
            Section {
                ForEach(trainingDayForOrder, id: \.self) { item in
                    HStack {
                        Image(systemName: item.icone)
                            .font(.callout)
                            .frame(height: 20)
                        Text(item.name.capitalizedSentence)
                            .font(.body)
                    }
                }.onMove { from, to in
                    trainingDayForOrder.move(fromOffsets: from, toOffset: to)
                }
            }

            Section {
                Button(action: {
                    mainData.presentedSheet=false
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
            Section {
                Button(action: {
                    let array=Array(trainingDayForOrder.enumerated())
                    for item in mainData.mainBackup!.allTrainingDay(){
                        item.index=Int16(array.first(where: {$0.element.id == item.id})!.offset)
                        do {
                            try viewContext.save()
                            mainData.presentedSheet=false
                            impactLight()
                            
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                }){
                    HStack {
                        Spacer()
                        Text("Enregistrer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.blue)
                }
            }
        }
    }
}
import CoreData
struct OrderTrainingDay_Previews: PreviewProvider {
    static let viewContext=PersistenceController.preview.container.viewContext
    static let fetchRequest: NSFetchRequest<TrainingDay> = TrainingDay.fetchRequest()
    static var previews: some View {
        if let trainingDay = try? viewContext.fetch(fetchRequest){
            OrderTrainingDay(trainingDayForOrder: trainingDay)
        }
    }
}
