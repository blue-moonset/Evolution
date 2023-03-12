//
//  AddActivities.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 27/11/2022.
//

import SwiftUI
import CoreData

struct AddActivities: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    @State var home:Bool=false
    @State var club:Bool=false
    
    @State var showingAlertDate = false
    @State var clubRepos=false
    let generator = UINotificationFeedbackGenerator()
    @State var allTrainingDay:[TrainingDay]=[]
    @State var allWorkInHome:[WorkInHome]=[]
    
    @StateObject var timerState:TimerState = .shared
    
    @StateObject var mainData:MainData = .shared
    @State var lockScrollViewWorkHome=true
    @State var lockScrollViewTrainingDay=true
    var body: some View {
        VStack{
            Text(mainData.indexValue==nil ? "Ajoute ton activité":"Mets à jour ton activité")
                .font(.title3)
                .fontWeight(.semibold)
            if mainData.indexValue==nil {
                DatePicker(selection: $mainData.dateSelect, in: mainData.mainBackup!.settings!.firstDay...Date(),displayedComponents: .date,label: { Text(activityIsSave(date: mainData.dateSelect, results: mainData.mainBackup!.allActivity()) ? "L'activité est déjà enregistré":"Quelle est la date ?")
                        .font(.callout)
                        .foregroundColor(activityIsSave(date: mainData.dateSelect, results: mainData.mainBackup!.allActivity()) ? .red : (colorScheme == .dark ? Color.white : Color.black))
                        .fontWeight(activityIsSave(date: mainData.dateSelect, results: mainData.mainBackup!.allActivity()) ? .semibold : .medium)
                })
                .environment(\.locale, Locale(identifier: "fr"))
                .datePickerStyle(.compact)
                .accentColor(activityIsSave(date: mainData.dateSelect, results: mainData.mainBackup!.allActivity()) ? .red : .blue)
                .padding(.all)
                .padding(.top,20)
                .onChange(of: mainData.dateSelect){ new in
                    if activityIsSave(date: mainData.dateSelect, results: mainData.mainBackup!.allActivity()){
                        generator.notificationOccurred(.error)
                    }
                }
                
            }else{
                Text(itemFormatter(mainData.mainBackup!.allActivity()[mainData.indexValue!].date))
                    .padding(.vertical,20)
            }
            
            VStack {
                HStack (spacing: 15){
                    Image(systemName: "moon.zzz.fill")
                    Text("Jour de repos")
                }.padding(.horizontal,25)
                    .padding(.vertical,15)
                    .foregroundColor((clubRepos ? Color.blue: Color.gray).opacity(0.9))
                    .font(.body)
                    .background((clubRepos ? Color.blue: Color.gray).opacity(0.18))
                    .clipShape(RoundedCorner())
                    .onTapGesture {
                        if clubRepos{
                            clubRepos=false
                        }else{
                            clubRepos=true
                            club=false
                        }
                    }.padding(.bottom,10)
                HStack (spacing: 20){
                    HStack (spacing: 15){
                        Image(systemName: "dumbbell.fill")
                        Text("À la salle")
                    } .padding(.horizontal,25)
                        .padding(.vertical,15)
                        .foregroundColor(color(state:club).opacity(0.9))
                        .background(color(state:club).opacity(0.18))
                        .clipShape(RoundedCorner())
                        .onTapGesture {
                            if !club{
                                club=true
                                clubRepos=false
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }else{
                                club=false
                                let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                impactHeavy.impactOccurred()
                            }
                        }
                    HStack (spacing: 15){
                        Image(systemName: "house.fill")
                        Text("À la maison")
                    }.padding(.horizontal,25)
                        .padding(.vertical,15)
                        .foregroundColor(color(state: home).opacity(0.9))
                        .background(color(state: home).opacity(0.18))
                        .clipShape(RoundedCorner())
                        .onTapGesture {
                            home.toggle()
                            if home{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }else{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                impactHeavy.impactOccurred()
                            }
                        }
                } .padding(.horizontal)
            }
            
            WorkHome()
            Practice()
            Spacer()
           
                Button(action: {
                    save()
                }){
                    Text("Enregister")
                        .frame(width: UIScreen.main.bounds.width-40)
                        .padding(.vertical,10)
                        .foregroundColor(.blue)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .fontWeight(.semibold)
                }.alert("La date est déjà enregistré"
                        , isPresented: $showingAlertDate) {
                    Button("OK", role: .cancel) { }
                }
            
                Button(action: {
                    dismiss()
                    mainData.indexValue=nil
                    let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                    impactHeavy.impactOccurred()
                }){
                    Text("Annuler")
                        .frame(width: UIScreen.main.bounds.width-40)
                        .padding(.vertical,10)
                        .foregroundColor(.red)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                        .fontWeight(.semibold)
                }.padding(.top,20)
                .padding(.bottom,60)
                //                Button(action: {
                //                    viewContext.delete(mainData.mainBackup!.allActivity()[indexValue!])
                //                    do {
                //                        try viewContext.save()
                //                        dismiss()
                //                        indexValue=nil
                //                    } catch {
                //                        let nsError = error as NSError
                //                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                //                    }
                //                }){
                //                    Text("Supprimer")
                //                    .frame(width: 100,height: 40)
                //                    .foregroundColor(.red)
                //                    .background(Color.red.opacity(0.18))
                //                    .cornerRadius(12)
                //                    .padding(.top,20)
                //                }
            
        }.onAppear{
            initForUpdate()
        }.onDisappear{
            mainData.indexValue=nil
            let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
            impactHeavy.impactOccurred()
        }
    }
    @ViewBuilder
    func Practice()-> some View{
        if club == true{
            VStack (spacing: 0){
                Divider()
                    .padding(.top)
                HStack {
                    Text("À la salle :")
                      
                    Spacer()
                    if allTrainingDay.count > 0{
                        Text("\(allTrainingDay.count) journée\(plural(allTrainingDay.count)) type\(plural(allTrainingDay.count))")
                    }
                }.padding(.horizontal)
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom,30)
                ScrollView(.horizontal,showsIndicators: false)  {
                    HStack (spacing: 0){
                        Spacer()
                        ForEach(mainData.mainBackup!.allTrainingDay(), id: \.self) { item in
                            VStack {
                                Image(systemName: item.icone)
                                    .frame(height: 30)
                                    .foregroundColor(color(state:allTrainingDay.contains(where: {$0.id==item.id})).opacity(0.9))
                                HStack (spacing: 4){
                                    Text(item.name.capitalizedSentence)
                                        .font(.headline)
                                        .lineLimit(1)
                                        .fixedSize()
                                }.padding(.horizontal,12)
                                    .padding(.vertical,6)
                                    .font(.headline)
                                    .foregroundColor(color(state:allTrainingDay.contains(where: {$0.id==item.id})).opacity(0.9))
                                    .background(color(state:allTrainingDay.contains(where: {$0.id==item.id})).opacity(0.18))
                                    .clipShape(RoundedCorner())
                                    .onTapGesture {
                                        impactLight()
                                        if allTrainingDay.contains(where:{$0==item}){
                                            let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                            impactHeavy.impactOccurred()
                                            allTrainingDay.remove(at: allTrainingDay.firstIndex(where:{$0==item})!)
                                        }else{
                                            let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                            impactHeavy.impactOccurred()
                                            allTrainingDay.append(item)
                                        }
                                    }
                            }
                            Spacer()
                        }
                    }.padding(.horizontal,20)
                        .frame(minWidth: lockScrollViewTrainingDay ? UIScreen.main.bounds.width:0)
                            .background(GeometryReader { proxy in
                                Color.clear
                                    .onChange(of:mainData.mainBackup!.allTrainingDay().count){ new in
                                        lockScrollViewTrainingDay=proxy.frame(in: .named("scrollView")).width <= UIScreen.main.bounds.width
                                    }.onAppear{
                                        lockScrollViewTrainingDay=proxy.frame(in: .named("scrollView")).width <= UIScreen.main.bounds.width
                                    }
                            })
                }.coordinateSpace(name: "scrollView")
                    .scrollDisabled(lockScrollViewTrainingDay)
            }
        }
    }
    @ViewBuilder
    func WorkHome()-> some View{
        if home == true{
            VStack (spacing: 0){
                Divider()
                    .padding(.top)
                HStack {
                    Text("À la maison :")
                    Spacer()
                    if allWorkInHome.count > 0{
                        Text("\(allWorkInHome.count) exercice\(plural(allWorkInHome.count))")
                    }
                }.font(.headline)
                .padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom,20)
                ScrollView(.horizontal,showsIndicators: false) {
                    HStack (spacing: 0){
                        Spacer()
                        ForEach(mainData.mainBackup!.allWorkInHome(),id: \.self) { item in
                            Text(item.name.capitalizedSentence)
                                .padding(.horizontal,12)
                                .padding(.vertical,6)
                                .font(.headline)
                                .lineLimit(1)
                                .fixedSize()
                                .foregroundColor(color(state:allWorkInHome.contains(where: {$0==item})).opacity(0.9))
                                .background(color(state:allWorkInHome.contains(where: {$0==item})).opacity(0.18))
                                .clipShape(RoundedCorner())
                                .onTapGesture {
                                    if allWorkInHome.contains(where: {$0==item}){
                                        let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                        impactHeavy.impactOccurred()
                                        allWorkInHome.removeAll(where: {$0==item})
                                    }else{
                                        let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                        impactHeavy.impactOccurred()
                                        allWorkInHome.append(item)
                                    }
                                }
                            Spacer()
                        }
                    }.padding(.horizontal,20)
                        .frame(minWidth: lockScrollViewWorkHome ? UIScreen.main.bounds.width:0)
                        .background(GeometryReader { proxy in
                            Color.clear
                                .onChange(of:mainData.mainBackup!.allWorkInHome().count){ new in
                                    lockScrollViewWorkHome=proxy.frame(in: .named("scrollView")).width <= UIScreen.main.bounds.width
                                }.onAppear{
                                    lockScrollViewWorkHome=proxy.frame(in: .named("scrollView")).width <= UIScreen.main.bounds.width
                                }
                        })
                }.coordinateSpace(name: "scrollView")
                    .scrollDisabled(lockScrollViewWorkHome)
            }
        }
    }
    
    func save(){
        if activityIsSave(date: mainData.dateSelect, results: mainData.mainBackup!.allActivity()) && mainData.indexValue == nil{
            showingAlertDate = true
            generator.notificationOccurred(.error)
        }else{
            if home==false{
                allWorkInHome.removeAll()
            }
            if club==false{
                allTrainingDay.removeAll()
            }
            if mainData.indexValue==nil{
                addItem()
            }else{
                updateItem()
            }
        }
    }
    func initForUpdate(){
        if mainData.indexValue != nil{
            home=mainData.mainBackup!.allActivity()[mainData.indexValue!].home
            club=mainData.mainBackup!.allActivity()[mainData.indexValue!].club
            clubRepos=mainData.mainBackup!.allActivity()[mainData.indexValue!].clubRepos
            
            for idWorkInHome in mainData.mainBackup!.allActivity()[mainData.indexValue!].allIdWorkInHome(){
                if let workInHome=mainData.mainBackup!.allWorkInHome().first(where: {$0.id == idWorkInHome.id}){
                    allWorkInHome.append(workInHome)
                }
            }
            for idTrainingDay in mainData.mainBackup!.allActivity()[mainData.indexValue!].allIdTrainingDay(){
                if let trainingDay=mainData.mainBackup!.allTrainingDay().first(where: {$0.id == idTrainingDay.id}){
                    allTrainingDay.append(trainingDay)
                }
            }
            
            if mainData.trainingDaySelect != nil{
                allTrainingDay.append(mainData.trainingDaySelect!)
                club=true
            }
        }
    }
    func color(state:Bool) -> Color {
        if !state{
            return .gray
        }else{
            return .green
        }
    }
    private func addItem() {
        let newItem = Activity(context: viewContext)
        newItem.date = mainData.dateSelect
        newItem.club = club
        newItem.home = home
        newItem.clubRepos=clubRepos
        for work in allWorkInHome {
            let objectId=ObjectID(context: viewContext)
            objectId.id=work.id
            newItem.addToIdWorkInHome(objectId)
        }
        for day in allTrainingDay {
            let objectId=ObjectID(context: viewContext)
            objectId.id=day.id
            newItem.addToIdTrainingDay(objectId)
        }
        mainData.mainBackup!.addToActivity(newItem)
        do {
            try viewContext.save()
            generator.notificationOccurred(.success)
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    private func updateItem() {
        let updateItem = mainData.mainBackup!.allActivity()[mainData.indexValue!]
        updateItem.club = club
        updateItem.home = home
        updateItem.clubRepos=clubRepos
        
        updateItem.allIdWorkInHome().forEach({updateItem.removeFromIdWorkInHome($0)})
        for work in allWorkInHome {
            let objectId=ObjectID(context: viewContext)
            objectId.id=work.id
            updateItem.addToIdWorkInHome(objectId)
        }
        updateItem.allIdTrainingDay().forEach({updateItem.removeFromIdTrainingDay($0)})
        for day in allTrainingDay {
            let objectId=ObjectID(context: viewContext)
            objectId.id=day.id
            updateItem.addToIdTrainingDay(objectId)
        }
        do {
            try viewContext.save()
            generator.notificationOccurred(.success)
            dismiss()
            mainData.indexValue=nil
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func isSelect(_ item:TrainingDay)->Bool{
        return allTrainingDay.contains{($0 == item)}
    }
}

struct AddActivities_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            AddActivities()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}
