//
//  DaysTraining.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 23/01/2023.
//

import SwiftUI

struct DaysTraining: View {
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.dateOfDay, ascending: false)])
    private var days: FetchedResults<Day>
    @Binding var indexValue:Int?
    @Binding var dateSelect:Date
    @Binding var isPresented:Bool
    @State var month=Date()
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.index)
    ])var typeDay:FetchedResults<TypeDay>
    var body: some View {
        ForEach(Array(divideIntoWeeks().enumerated()),id: \.offset) { index,week in
            if  index==0 || Calendar.current.component(.month, from: week[0]) ==  Calendar.current.component(.month, from: month) || showAll(){
                Section(header: Text((index==0 ? "Cette semaine":"Semaine du \(itemFormatterWhithoutDayName(week.last!))"))) {
                    ForEach(week, id: \.self) { day in
                        OneDay(date:day)
                    }
                }
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
                }.frame(width: UIScreen.main.bounds.width-40)
                    .listRowBackground(Color(.secondarySystemBackground))
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
    func OneDay(date:Date)->some View{
        if let indexDay=getDay(date: date, results: days){
            
            VStack (spacing: 0){
                HStack (spacing: 0){
                    Text(itemFormatter(date))
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .padding(.top,5)
                    Spacer()
                }
                if !days[indexDay].clubRepos {
                    HStack (spacing: 5){

                        let result=points(days[indexDay])
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
                        ForEach(practices(indexDay: indexDay),id:\.self) { item in
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
                    
                    indexValue=indexDay
                    isPresented=true
                }){
                    Image(systemName: "square.and.pencil")
                }.tint(.orange)
            }
        }else{
            Button(action: {
                dateSelect=date
                isPresented=true
            }){
                HStack {
                    Text(itemFormatter(date))
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .padding(.top,5)
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
    func practices(indexDay:Int)->[TypeDay]{
        var allTypeDay:[TypeDay]=[]
        for day in days[indexDay].idTypeDay{
            if let typeDay=typeDay.first(where: {$0.id == day}){
                allTypeDay.append(typeDay)
            }
        }
        return allTypeDay
    }
    func monthFollowingDate() -> [Date] {
        var months = [Date]()
        var nextDay = settings.first!.firstDay!
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
        var nextDay = Calendar.current.date(bySettingHour: 0, minute: 0, second: 1, of: settings.first!.firstDay!)!
        
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

    
    func points(_ day:Day) -> (club:Int,home:Int,total:Int) {
        var result:(club:Int,home:Int,total:Int)=(club:0,home:0,total:0)
        if day.club==true{
            result.club = Int(settings.first!.clubPointsGo)
        }else{
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
    func isNegative(_ int:Int) -> Color {
        if int>=0{
            return .green
        }else{
            return .red
        }
    }
}
func itemFormatterWhithoutDayName(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}
func itemFormatterMonth(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "MMMM"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}
struct DaysTraining_Previews: PreviewProvider {
    static var previews: some View {
        List {
            DaysTraining(indexValue: .constant(nil), dateSelect: .constant(Date()), isPresented: .constant(false))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
extension Date {
    func startOfWeek() -> Date {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: self)
        var startOfWeek: Date
        if weekday == 1 {
            startOfWeek = calendar.date(byAdding: .day, value: -6, to: self)!
        } else {
            startOfWeek = calendar.date(byAdding: .day, value: -weekday + 2, to: self)!
        }
        return startOfWeek
    }
}
