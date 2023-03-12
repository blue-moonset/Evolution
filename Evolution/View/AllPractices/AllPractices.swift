//
//  AllPractices.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 21/01/2023.
//

import SwiftUI
import CoreData

struct AllPractices: View {
    @Environment(\.openURL) var openURL
    
    @Environment(\.managedObjectContext) private var viewContext
    let generator = UINotificationFeedbackGenerator()
    
    @StateObject var mainData:MainData = .shared
    
    @StateObject var timerState:TimerState = .shared
    @StateObject private var model = Model()
    var body: some View {
        AllTrainingDayView(settings: false)
        Group{
            if let type=mainData.trainingDaySelect{
                if !isSave(type){
                    Section{
                        Button(action: {
                            if !activityIsSave(date: Date(), results: mainData.mainBackup!.allActivity()){
                                addItem()
                                mainData.presentedSheet=true
                                mainData.typeSheet = .check
                            }else{
                                mainData.presentedSheet=true
                                mainData.typeSheet = .activity
                                mainData.indexValue=getActivity(date: Date(), results: mainData.mainBackup!.allActivity())
                            }
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: type.icone)
                                Text("Ajouter \(type.name.capitalizedSentence) à la journée")
                                    .fontWeight(.semibold)
                                Spacer()

                            }
                        }
                    }.animation(.default, value: isSave(type))
                        .listRowBackground(Back(top: true, bottom: true))
                            .listRowSeparator(.hidden, edges: .all)

                }
                if mainData.trainingDaySelect!.allPractice().contains(where: {$0.done == true}){
                    Section{
                        Button(action: {
                            deleteDone()
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: "checklist")
                                Text("Enlever tout les checks")
                                    .fontWeight(.semibold)
                                Spacer()
                                
                            }.foregroundColor(.red)
                        }
                    }.animation(.default, value: isSave(type))
                        .listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                }
                if timerState.timerState != nil{
                    Section{
                        TimeMode()
                    }.listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                    .onAppear{
                        savePracticesDones(type:type)
                    }.onChange(of: timerState.practicesDone){ new in
                        savePracticesDones(type:type)
                    }
                }

                Section(type.name.capitalizedSentence){
                    if type.allPractice().count != 0{
                        ForEach(Array(type.allPractice().enumerated()),id:\.offset){ (index,item) in
                            Group{
                                if let edge=showLine(first: 0, last: type.allPractice().count-1, item: index){
                                    Practice(item,type)
                                        .listRowBackground(Back(top: index==0, bottom: index==type.allPractice().count-1))
                                        .listRowSeparator(.hidden, edges: edge)
                                }else{
                                    Practice(item,type)
                                        .listRowBackground(Back(top: index==0, bottom: index==type.allPractice().count-1))
                                }
                            }
                                    .swipeActions(edge: .trailing){
                                    if let lien=item.lien,let url=URL(string:lien){
                                        Button(action: {
                                            openURL(url)
                                        }) {
                                            Image(systemName: "link")
                                        }.tint(.blue)
                                    }
                                    Button(action: {
                                        mainData.typeSheet = .updatePractice
                                        mainData.updatePractice=item
                                        mainData.presentedSheet = true
                                    }){
                                        Image(systemName: "square.and.pencil")
                                    }.tint(.orange)
                                }.swipeActions(edge: .leading){
                                    Button(action: {
                                        item.done.toggle()
                                        do {
                                            try viewContext.save()
                                            generator.notificationOccurred(.success)
                                            model.reloadView()
                                            timerState.idRefresh=UUID()
                                        } catch {
                                            let nsError = error as NSError
                                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                        }
                                    }) {
                                        Image(systemName: item.done ? "xmark":"checkmark")
                                    }.tint(item.done ? .orange:.green)

                                }
                        }
                    }else{
                        Button(action:{
                            mainData.presentedSheet = true
                            mainData.typeSheet = .addPractice
                        }) {
                            HStack {
                                Spacer()
                                Text("Ajoute des exercices à ta journée")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.blue)
                                Spacer()
                            }
                        }.listRowBackground(Back(top: true, bottom: true))
                            .listRowSeparator(.hidden, edges: .all)
                    }

                }.listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
            }
        }
    }
    
    @ViewBuilder
    func Practice(_ practice:FetchedResults<Practice>.Element,_ typePractice:TrainingDay)->some View{
        Button(action: {
            if timerState.timerState == nil{
                impactLight()
            }
            withAnimation(.default){
                timerState.timerState=(practices:typePractice.allPractice(),index:Int(practice.index))
           }

        }){
            VStack (alignment: .leading,spacing: 10){
                Text(practice.name.capitalizedSentence)
                    .font(.headline)
                HStack {
                    Text(practice.convertRepetitionToStringWithWord())
                        .font(.subheadline)
                    Spacer(minLength: 0)
                    if let timer=timerState.timerState, timer.index == practice.index, timer.practices == mainData.trainingDaySelect!.allPractice(){
                        Circle()
                            .foregroundColor(.blue)
                            .frame(width: 8,height: 8)
                    }
                    Text(Int(practice.repos).convertSecondsToMinutes())
                        .font(.footnote)
                }
            }.foregroundColor(practice.done ? .green:.black)
        }

    }
    private func deleteDone() {
        for practice in mainData.trainingDaySelect!.allPractice(){
            practice.done=false
            
        }
        do {
            try viewContext.save()
            model.reloadView()
            impactLight()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func savePracticesDones(type:TrainingDay){
        if let practicesDone=timerState.practicesDone {
            for (index,practice) in type.allPractice().enumerated() {
                type.allPractice()[index].done = practicesDone.contains(where: {$0 == practice.id})
            }
            do {
                try viewContext.save()
                generator.notificationOccurred(.success)
                timerState.practicesDone=nil
                timerState.idRefresh = UUID()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func datesForWeek(of date: Date) -> [Date] {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // Monday
        let dateComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        let startOfWeek = calendar.date(from: dateComponents)!
        var dates: [Date] = []
        for i in 0...6 {
            dates.append(calendar.date(byAdding: .day, value: i, to: startOfWeek)!)
        }
        return dates
    }
    func isSaveThisWeek(_ trainingDay:TrainingDay)->Bool{
        let datesForWeek=datesForWeek(of: Date())
        for day in datesForWeek {
            if isSave(trainingDay,date: day){
                return true
            }
        }
        return false
    }
    func isSave(_ trainingDay:TrainingDay,date:Date=Date())->Bool{
        if let index=getActivity(date: date, results: mainData.mainBackup!.allActivity()){
            let activity=mainData.mainBackup!.allActivity()[index]
            return activity.allIdTrainingDay().contains(where: {$0.id == trainingDay.id})
        }else{
            return false
        }
    }
    private func addItem() {
        let newItem = Activity(context: viewContext)
        newItem.date = Date()
        newItem.club = true
        newItem.clubRepos=false
        let objectId=ObjectID(context: viewContext)
        objectId.id=mainData.trainingDaySelect!.id
        newItem.addToIdTrainingDay(objectId)
        newItem.home = false
        mainData.mainBackup!.addToActivity(newItem)
        do {
            try viewContext.save()
            generator.notificationOccurred(.success)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct AllPractices_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            List {
                AllPractices()
            }.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                .listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}



