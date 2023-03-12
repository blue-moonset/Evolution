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
   
    @State var total:Int=0
    
    @StateObject var mainData:MainData = .shared
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var timerState:TimerState = .shared
    @StateObject var watchManager : WatchManager = .shared
    
    @State var minY:CGFloat = .zero
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
                            if mainData.trainingDaySelect != nil{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                                impactHeavy.impactOccurred()
                                mainData.trainingDaySelect=nil
                            }
                        }
                    Spacer()
                    Button(action: {
                        mainData.presentedSheet=true
                        mainData.typeSheet = .activity
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                    }) {
                        VStack {
                            Image(systemName: "calendar.badge.plus")
                            Text("Ajouter une activité")
                                .font(.caption2)
                        }
                    }.frame(width: UIScreen.main.bounds.width-180-60)
                }.padding(.horizontal,30)
                .frame(width: UIScreen.main.bounds.width)
                .padding(.bottom,10)
                .padding(.top,15)
                .background(Color(.secondarySystemBackground))

                List{
                    AllPractices()
                    
                    SaveActivity()
                    
                    Section{
                        Charts(total:$total)
                    }.listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                        .listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                    AllActivities()
                        .background(GeometryGetMinY(minY: $minY))
                    Section{
                        NavigationLink(destination: CustomPractice()
                            .onAppear{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }
                        ) {
                            Label("Modifier mes journées", systemImage: "square.and.pencil")
                                .foregroundColor(.blue)
                        }
                    }.listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                    Section{
                        NavigationLink(destination: CustomWorkInHome()
                            .onAppear{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }
                        ) {
                            Label("Modifier mes exercices à la maison", systemImage: "square.and.pencil")
                                .foregroundColor(.blue)
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                        }
                    }.listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                    Section{
                        NavigationLink(destination: SettingsView()
                            .onAppear{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }
                        ) {
                            
                            HStack {
                                Label("Paramètres", systemImage: "gearshape.fill")
                                    .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                if mainData.alertICloud() != nil{
                                    Spacer()
                                    Image(systemName: "exclamationmark.icloud")
                                        .foregroundColor(.yellow)
                                }
                            }
                        }
                    }.listRowBackground(Back(top: true, bottom: true))
                        .listRowSeparator(.hidden, edges: .all)
                        .listRowInsets(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                }.environment(\.locale, Locale(identifier: "fr"))
                .navigationTitle("Menu")
                .navigationBarHidden(true)
                .listStyle(.grouped)
                .scrollIndicators(.hidden)
                .scrollContentBackground(.hidden)
                .background(Color(.secondarySystemBackground))
                .overlay(alignment: .trailing){
                    Rectangle()
                        .frame(width:20)
                        .foregroundColor(Color(.secondarySystemBackground))
                        .offset(y:minY-150)
                        .edgesIgnoringSafeArea(.bottom)
                }
                
            }.sheet(isPresented: $mainData.presentedSheet){
                if  mainData.typeSheet == .check || mainData.typeSheet == .activity {
                    if mainData.typeSheet == .check{
                        VStack (spacing: 20){
                            Text("Ton activité a bien été enregistrée")
                                .font(.callout)
                            AnimatedCheckmarkView()
                        }.presentationDetents([.height(100)])
                        .padding(.top,30)
                    }else if mainData.typeSheet == .activity{
                        AddActivities()
                            .padding(.top,30)
                            .presentationDetents([.fraction(0.8),.large])
                    }
                }else{
                    VStack {
                        Text((mainData.typeSheet == .addTrainingDay || mainData.typeSheet == .orderTrainingDay) ? "Ajouter une activité":mainData.trainingDaySelect!.name.capitalizedSentence)
                            .fontWeight(.semibold)
                            .padding(.top,10)
                            .padding(.vertical,5)
                        if mainData.typeSheet == .addTrainingDay{
                            AddTrainingDay()
                        }else if mainData.typeSheet == .updateTrainingDay{
                            UpdateTrainingDay()
                        }else if mainData.typeSheet == .orderTrainingDay{
                            OrderTrainingDay(trainingDayForOrder: Array(mainData.mainBackup!.allTrainingDay()))
                        }else if mainData.typeSheet == .addPractice{
                            AddPractice()
                        }else if mainData.typeSheet == .updatePractice{
                            UpdatePractice(practice:mainData.updatePractice!)
                        }
                    }
                }
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
   
    @ViewBuilder func SaveActivity()-> some View{
        if mainData.trainingDaySelect == nil || (!mainData.mainBackup!.allActivity().isEmpty && itemFormatter(mainData.mainBackup!.allActivity().first!.date) == itemFormatter(Date())){
            Section{
                HStack {
                    Spacer()
                    if mainData.mainBackup!.allActivity().count==0 || itemFormatter(mainData.mainBackup!.allActivity().first!.date) != itemFormatter(Date()){
                        Button(action: {
                            mainData.presentedSheet=true
                            mainData.typeSheet = .activity
                            mainData.dateSelect=Date()
                        }){
                            HStack {
                                Text("Enregistre ton activité")
                                    .fontWeight(.semibold)
                                Image(systemName: "figure.run")
                            }
                        }
                    }else{
                        Text("Bilan de ta journée")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if isNegative(points(mainData.mainBackup!.allActivity().first!).total) == .green{
                            Image(systemName: "hands.sparkles.fill").foregroundColor(.green)
                        }else{
                            Image(systemName: "hand.thumbsdown.fill").foregroundColor(.red)
                        }
                        
                        
                    }
                    Spacer()
                }
            } .listRowBackground(Back(top: true, bottom: true))
                .listRowSeparator(.hidden, edges: .all)
        }
    }
    func isNegative(_ int:Int) -> Color {
        if int>=0{
            return .green
        }else{
            return .red
        }
    }
}
func points(_ activity:Activity) -> (club:Int,home:Int,total:Int) {
    var result:(club:Int,home:Int,total:Int)=(club:0,home:0,total:0)
    if activity.club==true{
        result.club = Int(MainData.shared.mainBackup!.settings!.clubPointsGo)
    }else{
        result.club = Int(MainData.shared.mainBackup!.settings!.clubPointsNone)
    }
    result.total += result.club
    if activity.home==true{
        result.home = Int(MainData.shared.mainBackup!.settings!.homePointsGo)
    }else{
        result.home = Int(MainData.shared.mainBackup!.settings!.homePointsNone)
    }
    result.total += result.home
    return result
}
struct ContentView_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            ContentView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}
public var impactLight:(() -> Void)={
    var impact=UIImpactFeedbackGenerator(style: .light)
    impact.impactOccurred(intensity: 0.8)
}

func showLine(first:Int,last:Int,item:Int) -> VerticalEdge.Set? {
    if item==first && item==last{
        return .all
    }else if item==first{
        return .top
    }else if item==last{
        return .bottom
    }else{
        return nil
    }
}
@ViewBuilder
func Back(top:Bool,bottom:Bool)-> some View{
    if let corners=cornerList(top,bottom){
        Color.white
            .cornerRadius(10,corners:corners)
            .padding(.horizontal,20)
    }else{
        Color.white
            .padding(.horizontal,20)
    }
}
func cornerList(_ top:Bool,_ bottom:Bool) -> UIRectCorner? {
    var array:UIRectCorner?
    if top && bottom{
        array=[.allCorners]
    }else{
        if top{
            array=[.topLeft,.topRight]
        }else if bottom{
            array=[.bottomLeft,.bottomRight]
        }
    }
    return array
}
