//
//  AllActivities.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 23/01/2023.
//

import SwiftUI
import CoreData

struct AllActivities: View {
   
    @State var month=Date()
    @StateObject var mainData:MainData = .shared
    
    var body: some View {
        ForEach(Array(divideIntoWeeks().enumerated()),id: \.offset) { index,week in
            if  index==0 || Calendar.current.component(.month, from: week[0]) ==  Calendar.current.component(.month, from: month) || showAll(){
                Section(header: Text((index==0 ? "Cette semaine":"Semaine du \(itemFormatterWhithoutDayName(week.last!))"))) {
                    ForEach(Array(week.enumerated()), id: \.offset) { (index,day) in
                        if let edge=showLine(first: 0, last: week.count-1, item: index){
                            OneActivity(date:day)
                                .listRowBackground(Back(top: day==week.first!, bottom: day==week.last!))
                                .listRowSeparator(.hidden, edges: edge)
                        }else{
                            OneActivity(date:day)
                                .listRowBackground(Back(top: day==week.first!, bottom: day==week.last!))
                        }
                    }
                }.listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                   
            }
            if index==0 && !showAll(){
                ScrollView (.horizontal){
                    HStack {
                        ForEach(monthFollowingDate().reversed(),id: \.self) { item in
                            Text(itemFormatterMonth(item))
                                .padding(.horizontal,10)
                                .padding(.vertical,5)
                                .font(.callout)
                                .foregroundColor(isSameMonth(date1: item,date2: month) ? .black:.gray)
                                .background(isSameMonth(date1: item,date2: month) ? Color(.secondarySystemBackground):Color.clear)
                                .clipShape(RoundedCorner())
                                .onTapGesture {
                                    month=item
                                    impactLight()
                                }
                                
                        }
                    }.padding(.all,5)
                        .background(.white)
                    .clipShape(RoundedCorner())
                    .frame(minWidth: UIScreen.main.bounds.width-40)
                }.listRowBackground(Color(.secondarySystemBackground))
                .listRowSeparator(.hidden, edges: .all)
            }
        }
    }
    func showAll()->Bool{
        if monthFollowingDate().count >= 2{
            return false
        }else{
            return true
        }
    }
    @ViewBuilder
    func OneActivity(date:Date)->some View{
        if let indexActivity=getActivity(date: date, results: mainData.mainBackup!.allActivity()){
            
            VStack (spacing: 0){
                HStack (spacing: 0){
                    Text(itemFormatter(date))
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .padding(.top, !mainData.mainBackup!.allActivity()[indexActivity].clubRepos ? 5:2)
                    Spacer()
                }
                if !mainData.mainBackup!.allActivity()[indexActivity].clubRepos {
                    HStack (spacing: 5){

                        let result=points(mainData.mainBackup!.allActivity()[indexActivity])
                        HStack (spacing: 5){
                            Image(systemName: "dumbbell.fill")
                                .font(.footnote)
                                .foregroundColor(isNegative(result.club).opacity(0.9))
                            Text("\(result.club)")
                                .foregroundColor(isNegative(result.club).opacity(0.9))
                                .lineLimit(1)
                                .frame(width: 20)
                        }.frame(height:20)
                        .padding(.horizontal,5)
                        .background(isNegative(result.club).opacity(0.18))
                        .clipShape(RoundedCorner())

                        Divider()
                            .padding(.horizontal,5)
                        HStack (spacing: 5){
                            Image(systemName: "house.fill")
                                .font(.footnote)
                                .foregroundColor(isNegative(result.home).opacity(0.9))
                            Text("\(result.home)")
                                .foregroundColor(isNegative(result.home).opacity(0.9))
                                .lineLimit(1)
                                .frame(width: 20)
                        }.padding(.horizontal,5)
                        .frame(height:20)
                        .background(isNegative(result.home).opacity(0.18))
                        .clipShape(RoundedCorner())
                        .padding(.trailing,10)
                        ForEach(practices(indexDay: indexActivity),id:\.self) { item in
                            HStack (spacing: 5){
                                Image(systemName: item.icone)
                                    .font(.caption)
                                    .foregroundColor(.blue.opacity(0.9))
                                    .frame(width:20,height:20)
                                    .background(.blue.opacity(0.18))
                                    .clipShape(Circle())
                                Text(item.name.capitalizedSentence)
                                    .foregroundColor(.blue.opacity(0.9))
                                    .lineLimit(1)
                                    .font(.footnote)
                                    .frame(height:20)
                                    
                            }
                            
                        }
                        
                        Spacer()
                        Text("\(result.total)")
                            .foregroundColor(isNegative(result.total))
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .frame(width: 30)
                    }
                }else{
                    HStack {
                       
                        HStack (spacing: 5){
                            Image(systemName: "moon.zzz.fill")
                                .font(.footnote)
                                .foregroundColor(.blue.opacity(0.9))
                            Text("Jour de repos")
                                .foregroundColor(.blue.opacity(0.9))
                                .lineLimit(1)
                                .font(.footnote)
                        }.frame(height:20)
                        .padding(.horizontal,5)
                        .background(.blue.opacity(0.18))
                        .clipShape(RoundedCorner())
                        Spacer()
                    }.padding(.top,7)
                }
            }.background(Color.white.opacity(0.001))
            .swipeActions{
                Button(action: {
                    
                    mainData.indexValue=indexActivity
                    mainData.presentedSheet=true
                    mainData.typeSheet = .activity
                }){
                    Image(systemName: "square.and.pencil")
                }.tint(.orange)
            }
        }else{
            Button(action: {
                mainData.dateSelect=date
                mainData.presentedSheet=true
                mainData.typeSheet = .activity
            }){
                HStack {
                    Text(itemFormatter(date))
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .padding(.top,2)
                    Spacer()
                    Text("Enregistrer")
                        .font(.footnote)
                    .foregroundColor(.blue)
                    .frame(height:20)
                    .padding(.horizontal,5)
                    .background(.blue.opacity(0.18))
                    .clipShape(RoundedCorner())
                }
            }
        }
    }
    func practices(indexDay:Int)->[TrainingDay]{
        var allTrainingDay:[TrainingDay]=[]
        for activity in mainData.mainBackup!.allActivity()[indexDay].allIdTrainingDay(){
            if let trainingDay=mainData.mainBackup!.allTrainingDay().first(where: {$0.id == activity.id}){
                allTrainingDay.append(trainingDay)
            }
        }
        return allTrainingDay
    }
    func monthFollowingDate() -> [Date] {
        var months = [Date]()
        var nextDay = mainData.mainBackup!.settings!.firstDay
        while nextDay <= Date() {
            if !months.contains(where: {
                Calendar.current.component(.month, from: $0) == Calendar.current.component(.month, from: nextDay)
            }) {
                months.append(nextDay)
            }
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
        }

        return months
    }
    func isSameMonth(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        let month1 = calendar.component(.month, from: date1)
        let month2 = calendar.component(.month, from: date2)
        return month1 == month2
    }
    func daysFollowingDate() -> [Date] {
        var days = [Date]()
        var nextDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: mainData.mainBackup!.settings!.firstDay)!
        
        while nextDay <= Date() {
            days.append(nextDay)
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
        }
        return days.reversed()
    }
    func divideIntoWeeks() -> [[Date]]{
        var weekDates = [Date: [Date]]()
        
        for date in daysFollowingDate() {
            let startOfWeek = date.startOfWeek()
            if weekDates[startOfWeek] == nil {
                weekDates[startOfWeek] = [date]
            } else {
                weekDates[startOfWeek]?.append(date)
            }
        }
        let array=weekDates.sorted(by: { $0.key > $1.key})
        var result = [[Date]]()
        for item in array{
            result.append(item.value)
        }
        return result
    }

    
    func points(_ activity:Activity) -> (club:Int,home:Int,total:Int) {
        var result:(club:Int,home:Int,total:Int)=(club:0,home:0,total:0)
        if activity.club==true{
            result.club = Int(mainData.mainBackup!.settings!.clubPointsGo)
        }else{
            result.club = Int(mainData.mainBackup!.settings!.clubPointsNone)
        }
        result.total += result.club
        if activity.home==true{
            result.home = Int(mainData.mainBackup!.settings!.homePointsGo)
        }else{
            result.home = Int(mainData.mainBackup!.settings!.homePointsNone)
        }
        result.total += result.home
        return result
    }
    func isNegative(_ int:Int) -> Color {
        if int>=0{
            return .green
        }else{
            return .red
        }
    }
}

struct AllActivities_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            List {
                AllActivities()
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }.listStyle(.grouped)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}

