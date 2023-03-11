//
//  Training.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 21/01/2023.
//

import SwiftUI

struct Training: View {
    @Environment(\.openURL) var openURL
    @State var icone=""
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\Day.dateOfDay,order: .reverse)
    ])
    private var days: FetchedResults<Day>
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.index)
    ])var typeDay:FetchedResults<TypeDay>
    
    @Environment(\.managedObjectContext) private var viewContext
    let generator = UINotificationFeedbackGenerator()
    @Binding var isPresented:Bool
    @Binding var check:Bool
    @Binding var indexValue:Int?
    @StateObject var timerState:TimerState = .shared
    @State var allSportPractice=[SportPractice]()
    var body: some View {
        Section {
            HStack {
                ForEach(Array(typeDay.enumerated()), id: \.offset) { index,item in
                    Item(item)
                    if index != typeDay.count-1{
                        Spacer(minLength: 0)
                    }
                }
            }.frame(width: UIScreen.main.bounds.width-40)
        }.frame(width: UIScreen.main.bounds.width-40)
            .listRowBackground(Color(.secondarySystemBackground))
        Group{
            if let type=timerState.typeDaySelect{
                if !isSave(type){
                    Section{
                        Button(action: {
                            if !dayIsSave(date: Date(), results: days){
                                addItem()
                                isPresented=true
                                check=true
                            }else{
                                isPresented=true
                                indexValue=getDay(date: Date(), results: days)
                            }
                        }) {
                            HStack {
                                Spacer()
                                Image(systemName: icone)
                                Text(dayIsSave(date: Date(), results: days) ? "Ajouter aussi à la journée":"Ajouter à la journée")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Spacer()
                                
                            }
                        }
                    }.animation(.default, value: isSave(type))
                    
                }
                if timerState.timerState != nil{
                    Section{
                        TimeMode()
                    }.onAppear{
                        savePracticesDones(type:type)
                    }.onChange(of: timerState.practicesDone){ new in
                        savePracticesDones(type:type)
                    }
                }
                Section(type.name.capitalizedSentence){
                    ForEach(0..<allSportPractice.count,id:\.self){ item in
                        Practice(allSportPractice[item],type)
                            .swipeActions(edge: .trailing){
                                if let lien=allSportPractice[item].lien,let url=URL(string:lien){
                                    Button(action: {
                                        openURL(url)
                                    }) {
                                        Image(systemName: "link")
                                    }.tint(.blue)
                                }
                            }.swipeActions(edge: .leading){
                                Button(action: {
                                    type.allSportPractice()[item].done.toggle()
                                    do {
                                        try viewContext.save()
                                        generator.notificationOccurred(.success)
                                        allSportPractice=[]
                                        allSportPractice=type.allSportPractice()
                                        timerState.idRefresh=UUID()
                                    } catch {
                                        let nsError = error as NSError
                                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                                    }
                                }) {
                                    Image(systemName: allSportPractice[item].done ? "xmark":"checkmark")
                                }.tint(allSportPractice[item].done ? .orange:.green)
                            }
                    }
                }
            }
        }.onChange(of: timerState.typeDaySelect){ new in
            if new != nil{
                allSportPractice=timerState.typeDaySelect!.allSportPractice()
            }
        }
    }
    @ViewBuilder
    func Item(_ typeDay:TypeDay)->some View{
        VStack (spacing: 4){
            Image(systemName: typeDay.icone)
                .frame(height: 18)
            Text(typeDay.name.capitalizedSentence)
        }.frame(width: 60,height: 70)
            .font(.callout)
            .fontWeight(.regular)
            .foregroundColor(timerState.typeDaySelect==typeDay ? .white:(isSaveThisWeek(typeDay) ? .green.opacity(0.9):.black))
        .background(timerState.typeDaySelect==typeDay ? .blue:(isSaveThisWeek(typeDay) ? .green.opacity(0.18):.white))
        .clipShape(Circle())
        .onTapGesture {
            impactLight()
            if timerState.typeDaySelect==nil{
                withAnimation(.default){
                    timerState.typeDaySelect=typeDay
                }
            }else{
                timerState.typeDaySelect=typeDay
            }
        }.onChange(of: timerState.typeDaySelect){ new in
            if new == typeDay{
                icone=typeDay.icone
            }
        }
    }
    
    @ViewBuilder
    func Practice(_ practice:FetchedResults<SportPractice>.Element,_ typePractice:TypeDay)->some View{
        Button(action: {
            if timerState.timerState == nil{
                impactLight()
            }
            withAnimation(.default){
                timerState.timerState=(practices:typePractice.allSportPractice(),index:Int(practice.index))
           }

        }){
            VStack (alignment: .leading,spacing: 10){
                Text(practice.title.capitalizedSentence)
                    .font(.headline)
                HStack {
                    Text(practice.repetitions ?? "")
                        .font(.subheadline)
                    Spacer(minLength: 0)
                    Text(convertSecondsToMinutes(Int(practice.repos)))
                        .font(.footnote)
                }
            }.foregroundColor(practice.done ? .green:.black)
        }

    }
    func savePracticesDones(type:TypeDay){
        if let practicesDone=timerState.practicesDone {
            for (index,practice) in allSportPractice.enumerated() {
                type.allSportPractice()[index].done = practicesDone.contains(where: {$0 == practice.id})
            }
            do {
                try viewContext.save()
                generator.notificationOccurred(.success)
                allSportPractice=[]
                allSportPractice=type.allSportPractice()
                timerState.practicesDone=nil
                timerState.idRefresh = UUID()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func convertSecondsToMinutes(_ seconds: Int) -> String {
        if seconds >= 60{
            var result="\(seconds/60) min"
            let remainingSeconds = seconds % 60
            if remainingSeconds != 0 {
                result=result+" \(remainingSeconds)"
            }
            return result
        }else{
            return "\(seconds) sec"
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
    func isSaveThisWeek(_ typeDay:TypeDay)->Bool{
        let datesForWeek=datesForWeek(of: Date())
        for day in datesForWeek {
            if isSave(typeDay,date: day){
                return true
            }
        }
        return false
    }
    func isSave(_ typeDay:TypeDay,date:Date=Date())->Bool{
        if let index=getDay(date: date, results: days){
            let day=days[index]
            return day.idTypeDay.contains(where: {$0 == typeDay.id})
        }else{
            return false
        }
    }
    private func addItem() {
        let newItem = Day(context: viewContext)
        newItem.dateOfDay = Date()
        newItem.club = true
        newItem.clubRepos=false
        newItem.idTypeDay.append(timerState.typeDaySelect!.id)
        newItem.home = false
        do {
            try viewContext.save()
            generator.notificationOccurred(.success)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct Training_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Training(isPresented: .constant(false), check: .constant(false), indexValue: .constant(nil))
        }.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}


public var impactLight:(() -> Void)={
    var impact=UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred(intensity: 0.8)
}
