//
//  ContentView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 27/11/2022.
//

import SwiftUI
import UIKit
import CoreData
import ActivityKit

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.dateOfDay, ascending: false)])
    private var days: FetchedResults<Day>
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @State var isPresented=false
    @State var indexValue:Int?
    @State var dateSelect=Date()
    @State var total:Int=0
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.index)
    ])var typeDay:FetchedResults<TypeDay>
    
    @State var check:Bool=false
    @State var dataPractice=DataPractice()
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var timerState:TimerState = .shared
    @StateObject var watchManager : WatchManager = .shared
    var body: some View {
        NavigationStack  {
            VStack(spacing: 0){
                HStack (spacing: 0){
                    HStack (spacing: 30){
                            VStack (spacing: 5){
                                Image(systemName:"trophy.fill")
                                    .font(.title3)
//                                    .foregroundColor(Color("gold"))
                                Text("Mes points")
                                    .font(.callout)
                            }

                            Text("\(total)")
                                .fontWeight(.semibold)
                                .foregroundColor(isNegative(total))
                        }.frame(width: 180)
                            .frame(height: 60)
                            .background(.white)
                        .cornerRadius(10)
                        .onTapGesture {
                            timerState.typeDaySelect=nil
                            let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                            impactHeavy.impactOccurred()

                        }
                    Spacer()
                    Button(action: {
                        isPresented=true
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                    }) {
                        VStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Ajouter une journée")
                                .font(.caption2)
                        }
                    }.frame(width: UIScreen.main.bounds.width-180-60)
                }.padding(.horizontal,30)
                .frame(width: UIScreen.main.bounds.width)
                .padding(.bottom,10)
                .padding(.top,15)
                .background(Color(.secondarySystemBackground))

                List{
                    Training(isPresented: $isPresented,check: $check, indexValue:$indexValue)
                    Section{
                        HStack {
                            Spacer()
                            if days.count==0 || itemFormatter(days.first!.dateOfDay) != itemFormatter(Date()){
                                Button(action: {
                                    isPresented=true
                                    dateSelect=Date()
                                }){
                                    HStack {
                                        Text("Enregistre ta journée")
                                            .font(.title3)
                                        .fontWeight(.semibold)
                                        Image(systemName: "figure.run")
                                    }
                                }
                            }else{
                                Text("Bilan de ta journée")
                                    .font(.title3)
                                    .fontWeight(.semibold)

                                if isNegative(points(days.first!).total) == .green{
                                    Image(systemName: "hands.sparkles.fill").foregroundColor(.green)
                                }else{
                                    Image(systemName: "hand.thumbsdown.fill").foregroundColor(.red)
                                }


                            }
                            Spacer()
                        }
                    }
                    Section{
                        Charts(total:$total, isPresented: $isPresented)
                    }
                    DaysTraining(indexValue:$indexValue,dateSelect: $dateSelect, isPresented: $isPresented)

                    Section{
                        NavigationLink(destination: AddPractice()
                            .onAppear{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }
                        ) {
                            Label("Modifier mes exercies", systemImage: "square.and.pencil")
                                .foregroundColor(.blue)
                        }
                    }
                    Section{
                        NavigationLink(destination: SettingsView()
                            .onAppear{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }
                        ) {
                            Label("Paramètres", systemImage: "gearshape.fill")
                                .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        }
                    }
                }
                .environment(\.locale, Locale(identifier: "fr"))
                .navigationTitle("Menu")
                .navigationBarHidden(true)
            }.sheet(isPresented: $isPresented){
                if check{
                    HStack (spacing: 20){
                        Image(systemName: "checkmark.circle")
                            .font(.largeTitle)
                            .foregroundColor(.green)
                        Text("La journée a bien été enregistrée")
                            .font(.callout)
                    }.presentationDetents([.fraction(0.3),.large])
                    .onDisappear{
                        check=false
                    }
                }else{
                    AddActivity(dateSelect: $dateSelect, indexValue:$indexValue)
                        .padding(.top,30)
                        .presentationDetents([.fraction(0.8),.large])
                }
            }.onAppear{
//            TODO: refaire le tout pour la suppresion de donee
//                if !Calendar.current.isDate(settings.first!.dayLastDeleteDone!, inSameDayAs: Date()){
//                    deleteDone()
//                    settings.first!.dayLastDeleteDone! = Date()
//                }
            }
//            .onOpenURL(perform: { url in
//                print(url)
//                let value=url.absoluteString.replacingOccurrences(of: "evolution://", with: "")
//                print(value)
//                for link in timerState.allCases{
//                    if value==link.rawValue{
//                        timerState.void = link
//                        print(link)
//                    }
//                }
//            })
//            .onDisappear{
//                let liveActivityHelper:LiveActivityHelper = .shared
//                liveActivityHelper.removeAll()
//            }
            
        }
    }
   
    
    func isNegative(_ int:Int) -> Color {
        if int>=0{
            return .green
        }else{
            return .red
        }
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
    private func deleteDone() {
        for day in typeDay{
            for practice in day.allSportPractice(){
                practice.done=false
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
func itemFormatter(_ date:Date)->String{
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE d MMMM"
    formatter.locale = Locale(identifier: "fr")
    return formatter.string(from: date).capitalized
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
           
    }
}
