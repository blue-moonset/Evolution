//
//  Charts.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 28/11/2022.
//

import SwiftUI

import CoreData
import Charts

struct Value: Identifiable {
    var id = UUID()
    var date: Date
    var total: Int
}

struct Charts: View {
    
    @State var datas: [Value]=[]
    @Binding var total:Int
    @State var daysBetween=0
    @StateObject var mainData:MainData = .shared
    var body: some View {
        
        VStack(spacing: 0){
            if daysBetween<3{
                HStack{
                    Spacer()
                    if 3-daysBetween==1{
                        Text("Reviens demain")
                    }else{
                        Text("Reviens dans \(3-daysBetween) jours")
                    }
                    Image(systemName: "hourglass")
                    Spacer()
                }
            }else{
                Chart(datas) {
                    RuleMark(
                        y: .value("Value",0)
                    )
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .foregroundStyle(.green.opacity(0.1))
                    
                    LineMark(
                        x: .value("Mois", $0.date,unit: .day),
                        y: .value("Value", $0.total)
                    ).interpolationMethod(.catmullRom)
                       
                    PointMark(
                        x: .value("Mois", $0.date,unit: .day),
                        y: .value("Value", $0.total)
                    )
                    
                }.frame(height: 250)
                    .environment(\.locale, Locale(identifier: "fr"))
            }
        }
        .onAppear{
            datas=[]
            daysBetween=daysBetween(start: mainData.mainBackup!.settings!.firstDay, end: Date())
            load(allDays: daysFollowingDate())
        }.onDisappear{
            datas=[]
        }.onChange(of: mainData.mainBackup!.allActivity().count){ new in
            datas=[]
            load(allDays: daysFollowingDate())
        }.onChange(of: mainData.mainBackup!.settings!.firstDay){ new in
            datas=[]
            load(allDays: daysFollowingDate())
        }
        
        
    }
    func daysFollowingDate() -> [Date] {
        var days = [Date]()
        var nextDay = mainData.mainBackup!.settings!.firstDay
        while nextDay <= Date() {
            days.append(nextDay)
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
        }
        return days
    }
    func isDateInFetchedResults(_ date: Date) -> Activity? {
        return mainData.mainBackup!.allActivity().reversed().first { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    func load(allDays:[Date]){
        var total=0
        for day in allDays {
            if let d=isDateInFetchedResults(day){
                total += calculation(d).total
                datas.append(Value(date: d.date, total: total))
            }else{
                total += Int((mainData.mainBackup!.settings!.clubPointsNone+mainData.mainBackup!.settings!.homePointsNone))
                datas.append(Value(date: day, total: total))
            }
        }
        self.total=total
    }
    func calculation(_ day:Activity)->(club:Int,home:Int,total:Int){
        var result:(club:Int,home:Int,total:Int)=(club:0,home:0,total:0)
        if day.club==true {
            result.club = Int(mainData.mainBackup!.settings!.clubPointsGo)
        }else if day.club==false && day.clubRepos==false{
            result.club = Int(mainData.mainBackup!.settings!.clubPointsNone)
        }
        result.total += result.club
        if day.home==true{
            result.home = Int(mainData.mainBackup!.settings!.homePointsGo)
        }else{
            result.home = Int(mainData.mainBackup!.settings!.homePointsNone)
        }
        result.total += result.home
        return result
    }
    func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: start)!, to: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: end)!).day!
    }
}



struct Charts_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            List {
                Charts(total: .constant(0))
                    .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}
