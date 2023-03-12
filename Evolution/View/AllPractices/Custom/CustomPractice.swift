//
//  CustomPractice.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 05/02/2023.
//

import SwiftUI
import CoreData

struct CustomPractice: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @State var lastTrainingDaySelect:TrainingDay?
    
    @StateObject var field=Field()
    @StateObject var mainData:MainData = .shared
    
    @StateObject var model:Model = .shared
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.5)
            List{
                Section (header:Text("Modifier mes journées")){
                    Button(action: {
                        mainData.presentedSheet = true
                        mainData.typeSheet = .addTrainingDay
                    }){
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                            Text("Ajouter une journée")
                            Spacer()
                        }
                    }
                }.listRowBackground(Back(top: true, bottom: true))
                    .listRowSeparator(.hidden, edges: .all)
                
                if mainData.mainBackup!.allTrainingDay().count != 0{
                    if mainData.mainBackup!.allTrainingDay().count >= 2{
                        Section {
                            Button(action: {
                                mainData.presentedSheet = true
                                mainData.typeSheet = .orderTrainingDay
                            }){
                                HStack {
                                    Spacer()
                                    Image(systemName: "list.triangle")
                                    Text("Modifier l'ordre des journées")
                                    Spacer()
                                }
                            }
                        }.listRowBackground(Back(top: true, bottom: true))
                            .listRowSeparator(.hidden, edges: .all)
                    }
                    Section {
                        Button(action: {
                            mainData.presentedSheet = true
                            mainData.typeSheet = .updateTrainingDay
                        }){
                            HStack {
                                Spacer()
                                Image(systemName: "square.and.pencil")
                                Text("Modifier la journée")
                                Spacer()
                            }
                        }
                        
                    }.listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                    
                    Section (header:Text("Modifier mes exercies")){
                        AllTrainingDayView(settings: true)
                    }.frame(width: UIScreen.main.bounds.width)
                    Practices(model:model)
                }
                    Archives(model:model)
                    
            }.listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
                .scrollIndicators(.hidden)
        }.navigationTitle("Changer mon programme")
            .navigationBarTitleDisplayMode(.inline)
           .onChange(of: mainData.mainBackup!.allTrainingDay().count){ new in
                if mainData.trainingDaySelect == nil{
                    mainData.trainingDaySelect=mainData.mainBackup!.allTrainingDay().last
                }
            }.onAppear{
                lastTrainingDaySelect=mainData.trainingDaySelect
                if mainData.trainingDaySelect==nil, let first=mainData.mainBackup!.allTrainingDay().sorted(by: {$0.index < $1.index}).first{
                    mainData.trainingDaySelect=first
                }
            }.onDisappear{
                mainData.trainingDaySelect=lastTrainingDaySelect
            }
    }
    
    
    func changeIndexForTrainingDay(type:TrainingDay, fromOffsets: IndexSet,toOffset: Int) {
        var array=Array(mainData.mainBackup!.allTrainingDay())
        array.move(fromOffsets: fromOffsets, toOffset: toOffset)
        for (index,item) in Array(array.enumerated()){
            item.index=Int16(index)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    
}



struct CustomPractice_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext

    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            CustomPractice()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}


fileprivate struct Practices: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var mainData:MainData = .shared
    @StateObject var model:Model = .shared
    @State var showAlert=false
    @State var practiceForArchive:Practice?
    @StateObject var timerState:TimerState = .shared
    var body: some View {
        if let trainingDaySelect=mainData.trainingDaySelect{
            Section{
                Button(action: {
                    mainData.presentedSheet = true
                    mainData.typeSheet = .addPractice
                }){
                    HStack {
                        Spacer()
                        Image(systemName: "plus.circle")
                        Text("Ajouter un exercice")
                        Spacer()
                    }
                }
            }.listRowBackground(Back(top: true, bottom: true))
                .listRowSeparator(.hidden, edges: .all)

            if trainingDaySelect.allPractice().count == 0{
                Section (trainingDaySelect.name){
                    HStack {
                       Text("Ajoute des exercices à ta journée")
                            .foregroundColor(.gray)
                    }.frame(width: UIScreen.main.bounds.width-40)
                }.listRowBackground(Color(.secondarySystemBackground))
                    .listRowBackground(Back(top: true, bottom: true))
                    .listRowSeparator(.hidden, edges: .all)
            }else{
                Section(trainingDaySelect.name){
                    ForEach(Array(trainingDaySelect.allPracticeWithHidden().enumerated()),id:\.offset){ index,item in
                        Group{
                            if let edge=showLine(first: 0, last: trainingDaySelect.allPractice().count-1, item: index){
                                Practice(item,index)
                                    .listRowBackground(Back(top: index==0, bottom: index==trainingDaySelect.allPractice().count-1))
                                    .listRowSeparator(.hidden, edges: edge)
                            }else{
                                Practice(item,index)
                                    .listRowBackground(Back(top: index==0, bottom: index==trainingDaySelect.allPractice().count-1))
                            }
                        }.swipeActions(edge: .trailing){
                            Button(action: {
                                item.active.toggle()
                                model.reloadView()
                                do {
                                    try viewContext.save()
                                } catch {
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }){
                                Image(systemName: "eye.slash")
                            }.tint(.gray)
                        }.swipeActions(edge: .leading){
                            Button(action: {
                                showAlert=true
                                practiceForArchive=item
                            }){
                                Image(systemName: "archivebox")
                            }.tint(.orange)
                        }
                    }.onMove { from, to in
                        changeIndexForPractice(type:trainingDaySelect,fromOffsets: from,toOffset: to)
                    }
                }.listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                    .actionSheet(isPresented: $showAlert) {
                        ActionSheet(
                            title: Text("Êtes-vous sûre de vouloir archiver cet exercice ?"),
                            message: Text("L'exercice sera supprimé de la journée\n\nSinon peux supprimer entièrement l'exercice en cliquant dessus"),
                            buttons:[
                                .cancel(),
                                .destructive(Text("Archiver l'exercice"), action: {
                                    emptyTrashAction()
                                })
                            ]
                        )}
            }

        }
    }
    func emptyTrashAction() {
        mainData.mainBackup!.getArchive()[0].addToPractice(practiceForArchive!)
        mainData.trainingDaySelect!.removeFromPractice(practiceForArchive!)
        do {
            try viewContext.save()
            model.reloadView()
            impactLight()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func changeIndexForPractice(type:TrainingDay, fromOffsets: IndexSet,toOffset: Int) {
        var array=type.allPractice()
        array.move(fromOffsets: fromOffsets, toOffset: toOffset)
        for (index,item) in Array(array.enumerated()){
            item.index=Int16(index)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        if timerState.timer != nil,let trainingDaySelect=mainData.trainingDaySelect{
            let id=timerState.timerState!.practices[timerState.timerState!.index].id
            
            timerState.timerState=(practices:trainingDaySelect.allPractice(),index:Int(trainingDaySelect.allPractice().firstIndex(where: {$0.id == id})!))
            timerState.idRefresh=UUID()
        }
    }

     @ViewBuilder
     func Practice(_ practice:Practice,_ index:Int)->some View{
         Button(action: {
             impactLight()
             mainData.updatePractice=practice
             mainData.typeSheet = .updatePractice
             mainData.presentedSheet=true
         }){
             VStack (alignment: .leading,spacing: 10){
                 HStack {
                     Text(practice.name.capitalizedSentence)
                         .font(.headline)
                     if !practice.active{
                         Image(systemName: "eye.slash")
                     }
                 }
                 HStack {
                     Text(practice.convertRepetitionToStringWithWord())
                         .font(.subheadline)
                     Spacer(minLength: 0)
                     Text(Int(practice.repos).convertSecondsToMinutes())
                         .font(.footnote)
                 }
             }.foregroundColor(practice.active ? .black:.gray.opacity(0.8))
         }

     }
}
fileprivate struct Archives: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var mainData:MainData = .shared
    @StateObject var model:Model = .shared
    var body: some View {
        if !mainData.mainBackup!.getArchive()[0].allPractice().isEmpty{
            DisclosureGroup(
                content: {
                    ForEach(mainData.mainBackup!.getArchive()[0].allPracticeWithHidden(),id:\.id) { archive in
                        VStack (alignment: .leading,spacing: 10){
                            HStack {
                                Text(archive.name.capitalizedSentence)
                                    .font(.headline)
                            }
                            HStack {
                                Text(archive.convertRepetitionToStringWithWord())
                                    .font(.subheadline)
                                Spacer(minLength: 0)
                                Text(Int(archive.repos).convertSecondsToMinutes())
                                    .font(.footnote)
                            }
                        }.swipeActions(edge: .trailing){
                            Button(action: {
                                mainData.mainBackup!.getArchive()[0].removeFromPractice(archive)
                                model.reloadView()
                                do {
                                    try viewContext.save()
                                    impactLight()
                                } catch {
                                    let nsError = error as NSError
                                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                }
                            }){
                                Image(systemName: "trash")
                            }.tint(.red)
                        }
                    }
                },
                label: {
                    HStack {
                        Image(systemName: "archivebox")
                            .font(.callout)
                        Text("Voir tous les exercices archivés")
                            .font(.body)
                            .bold()
                    }.foregroundColor(.black)
                }
            ).padding(.horizontal,20)
            .listRowBackground(Back(top: true, bottom: true))
                .listRowSeparator(.hidden, edges: .all)
        }else{
            HStack {
                Image(systemName: "archivebox")
                    .font(.callout)
                Text("Aucune archive")
                    .font(.body)
                    .bold()
            }.foregroundColor(.gray)
           .padding(.horizontal,20)
                .foregroundColor(.gray)
                .listRowBackground(Back(top: true, bottom: true))
                .listRowSeparator(.hidden, edges: .all)
        }

    }
}
