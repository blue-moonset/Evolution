//
//  Charts.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 28/11/2022.
//

import SwiftUI

import SwiftUI
import Charts

struct Value: Identifiable {
    var id = UUID()
    var date: Date
    var total: Int
}

struct Charts: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.dateOfDay, ascending: true)],
        animation: .default)
    private var days: FetchedResults<Day>
    @State var datas: [Value]=[]
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @Binding var total:Int
    @Binding var isPresented:Bool
    @State var daysBetween=0
    var body: some View {
        
        VStack(spacing: 0){
            if daysBetween<3{
                HStack{
                    if 3-daysBetween==1{
                        Text("Reviens demain")
                    }else{
                        Text("Reviens dans \(3-daysBetween) jours")
                    }
                    Image(systemName: "hourglass")
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
            daysBetween=Evolution.daysBetween(start: settings.first!.firstDay!, end: Date())
            load(allDays: daysFollowingDate())
        }.onDisappear{
            datas=[]
        }.onChange(of: days.count){ new in
            datas=[]
            load(allDays: daysFollowingDate())
        }.onChange(of: isPresented){ new in
            if new{
                datas=[]
                load(allDays: daysFollowingDate())
            }
        }
        
        
    }
    func daysFollowingDate() -> [Date] {
        var days = [Date]()
        var nextDay = settings.first!.firstDay!
        while nextDay <= Date() {
            days.append(nextDay)
            nextDay = Calendar.current.date(byAdding: .day, value: 1, to: nextDay)!
        }
        return days
    }
    func isDateInFetchedResults(_ date: Date) -> Day? {
        return days.first { Calendar.current.isDate($0.dateOfDay, inSameDayAs: date) }
    }
    func load(allDays:[Date]){
        var total=0
        for day in allDays {
            if let d=isDateInFetchedResults(day){
                total += calculation(d).total
                datas.append(Value(date: d.dateOfDay, total: total))
            }else{
                total += Int((settings.first!.clubPointsNone+settings.first!.homePointsNone))
                datas.append(Value(date: day, total: total))
            }
        }
        self.total=total
    }
    func calculation(_ day:Day)->(club:Int,home:Int,total:Int){
        var result:(club:Int,home:Int,total:Int)=(club:0,home:0,total:0)
        if day.club==true {
            result.club = Int(settings.first!.clubPointsGo)
        }else if day.club==false && day.clubRepos==false{
            result.club = Int(settings.first!.clubPointsNone)
        }
        result.total += result.club
        if day.home==true{
            result.home = Int(settings.first!.homePointsGo)
        }else{
            result.home = Int(settings.first!.homePointsNone)
        }
        result.total += result.home
        return result
    }
}

func daysBetween(start: Date, end: Date) -> Int {
    return Calendar.current.dateComponents([.day], from: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: start)!, to: Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: end)!).day!
}
struct Charts_Previews: PreviewProvider {
    static var previews: some View {
        List {
            Charts(total: .constant(0),isPresented:.constant(false))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
