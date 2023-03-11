//
//  ContentWatchView.swift
//  WatchEvolution Watch App
//
//  Created by Samy Tahri-Dupre on 20/02/2023.
//

import SwiftUI
import WatchConnectivity
import CoreData
import WatchKit
import UserNotifications

struct ContentWatchView: View {
    @StateObject var watchManager : WatchManager = .shared
    @StateObject var hapticsEngine : HapticsEngine = .shared
    
    let timerForOnReceive = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    @State var selection=0
    @State var practicesDone=[UUID]()
    var body: some View {
        
        Group{
            if let sportPractice=watchManager.sportPractice{
                TabView(selection: $selection){
                    ForEach(Array(sportPractice.practices.enumerated()), id: \.offset) { (index,item) in
                        ItemSportPractice(practice:item,globalData:sportPractice)
                            .tag(index)
                    }
                }.tabViewStyle(.carousel)
                    .edgesIgnoringSafeArea(.all)
                    .onReceive(timerForOnReceive) { input in
                        if watchManager.sportPractice!.timer != nil{
                            watchManager.timerFinish(timer: watchManager.sportPractice!.timer!)
                        }
                    }.onChange(of: sportPractice.id){ new in
                        watchManager.sendFromWatchOS(sportPractice: AttributesForWatchToIOS(timer:  watchManager.sportPractice!.timer, isOn: watchManager.sportPractice!.isOn, totalAccumulatedTime: watchManager.sportPractice!.totalAccumulatedTime, index: watchManager.sportPractice!.index))
                    }.onChange(of: practicesDone){ new in
                        watchManager.saveFromWatchOS(practicesDone: new)
                    }.onChange(of: sportPractice.index){ new in
                        withAnimation(){
                            selection=new
                        }
                    }.onChange(of: watchManager.sportPractice!.isOn){ new in
                        if new == true{
                            hapticsEngine.startSessionIfNeeded()
                        }else{
                            hapticsEngine.stopSession()
                        }
                    }.onAppear{
                        withAnimation(){
                            selection=sportPractice.index
                        }
                    }
            }else{
                Text("Choisir un jour")
            }
        }
    }
    @ViewBuilder
    func ItemSportPractice(practice: SportPracticeForWatch,globalData:AttributesForWatchConvert)-> some View{
        VStack(spacing: 0){
            Button(action: {
                watchManager.reset(index: selection)
            }) {
                VStack(spacing: 0){
                    Text(practice.title.capitalizedSentence)
                        .fontWeight(.bold)
                        .font(.title3)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .foregroundColor(.white)
                        .padding(.horizontal,10)
                        .padding(.vertical,5)
                        .background(practice.id == globalData.practices[globalData.index].id ? .gray.opacity(0.4):.black)
                        .animation(.default, value: globalData.index)
                        .clipShape(RoundedCorner())
                        .padding(.top,0.5)
                        .multilineTextAlignment(.center)
                    Text(practice.repetitions)
                        .font(.callout)
                        .lineLimit(1)
                        .padding(.top,10)
                        .foregroundColor(.white)
                    
                }
            }.buttonStyle(.plain)
            .frame(maxHeight: 100)
            Spacer()
            
            Label {
                Group{
                    if practice.id == globalData.practices[globalData.index].id{
                        if globalData.timer != nil{
                            Text(timerInterval: globalData.timer!, countsDown: true)
                        }else{
                            Text(timeInString(practice:practice))
                        }
                    }else{
                        Text(timeInStringFix(practice:practice))
                    }
                }
                .multilineTextAlignment(.center)
                .monospacedDigit()
                .foregroundColor(.white)
            } icon: {
                Image(systemName: "timer")
                    .foregroundColor(.indigo)
            }.font(.title2)
            
            Spacer(minLength: 5)
            HStack{
                Button(action: {
                    if practice.id == globalData.practices[globalData.index].id{
                        if globalData.isOn{
                            watchManager.pause()
                        }else{
                            watchManager.play()
                        }
                    }else{
                        watchManager.resetAndPlay(index: selection)
                    }
                }) {
                    if practice.id == globalData.practices[globalData.index].id{
                        Image(systemName: globalData.isOn ? "pause.circle.fill":"play.circle.fill")
                    }else{
                        Image(systemName: "play.circle.fill")
                        
                    }
                }.buttonStyle(ScaleButtonStyle())
                    .foregroundStyle(.white,.blue)
                    .fontWeight(.bold)
                    .font(.title)
                
                Spacer(minLength: 5)
                Button(action: {
                    if !practicesDone.contains(where: {$0 == practice.id}){
                        practicesDone.append(practice.id)
                    }else{
                        practicesDone.removeAll(where: {$0 == practice.id})
                    }
                }) {
                    if !doneErrorWhenSave(practice){
                        if practice.done{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.white,.green)
                        }else{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundStyle(.white,.gray)
                        }
                    }else{
                        Group{
                            if practice.done{
                                Image(systemName: "checkmark.circle.badge.xmark.fill")
                                    .foregroundStyle(.red,.green,.red)
                                
                            }else{
                                Image(systemName: "checkmark.circle.badge.xmark.fill")
                                    .foregroundStyle(.red,.gray)
                            }
                        }.background{
                            ZStack {
                                Color.white.frame(width: 12,height: 20)
                                    .rotationEffect(.degrees(30))
                                    .offset(y:-3)
                                Color.white.frame(width: 9,height: 9)
                                    .offset(x:12, y:7.5)
                            }
                        }
                    }
                }.buttonStyle(ScaleButtonStyle())
                    .fontWeight(.bold)
                    .font(.title2)
                
            }.padding(.horizontal,10)
                .padding(.bottom,10)
            
            
        }.edgesIgnoringSafeArea(.bottom)
        
        
    }
    
    func doneErrorWhenSave(_ practice: SportPracticeForWatch)->Bool{
        if practicesDone.contains(where: {$0 == practice.id}) && !practice.done{
            return true
        }else{
            return false
        }
    }
    func timeInString(practice: SportPracticeForWatch) -> String {
        let time: Double = Double(practice.repos) - watchManager.sportPractice!.totalAccumulatedTime
        
        let minutes = Int(time / 60)
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%01d:%02d", Int(minutes), Int(seconds))
    }
    func timeInStringFix(practice: SportPracticeForWatch) -> String {
        let time: Double = Double(practice.repos)
        
        let minutes = Int(time / 60)
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%01d:%02d", Int(minutes), Int(seconds))
    }
}

struct ContentWatchView_Previews: PreviewProvider {
    static var watchManager : WatchManager = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    static var timerState:TimerState = .shared
    static let fetchRequest: NSFetchRequest<TypeDay> = TypeDay.fetchRequest()
    static var previews: some View {
        if let typeDay = try? viewContext.fetch(fetchRequest).first, save(typeDay){
            ContentWatchView(watchManager:watchManager)
            
        }
        
    }
    static func save(_ typeDay:TypeDay)->Bool{
        timerState.timerState=(practices:typeDay.allSportPractice(),index:0)
        timerState.isOn=true
        timerState.timer=Date.now...Date().addingTimeInterval(TimeInterval(90))
        
        let sportPractice = AttributesForWatchConvert(timer: timerState.timer!, isOn: timerState.isOn,totalAccumulatedTime: timerState.totalAccumulatedTime, practices: convert(timerState.timerState!.practices),index: timerState.timerState!.index)
        watchManager.subject.send(sportPractice)
        return true
    }
    static func convert(_ sportPractice:[SportPractice])->[SportPracticeForWatch] {
        var dic=[SportPracticeForWatch]()
        for practice in sportPractice {
            dic.append(SportPracticeForWatch(repetitions: practice.repetitions ?? "", title: practice.title, done: practice.done, repos: Int(practice.repos), id: practice.id))
        }
        return dic
    }
}
private extension WatchManager{
    
    func timerFinish(timer:ClosedRange<Date>){
        if sportPractice!.totalAccumulatedTime+(-Double(sportPractice!.timer!.lowerBound.timeIntervalSince(Date()))) > Double(sportPractice!.practices[sportPractice!.index].repos){
            HapticsEngine.shared.tick()
            reset(index:nil)
        }
    }
    func pause(){
        sportPractice!.isOn = false
        if sportPractice!.timer != nil{
            sportPractice!.totalAccumulatedTime=sportPractice!.totalAccumulatedTime + (-Double(sportPractice!.timer!.lowerBound.timeIntervalSince(Date())))
        }else{
            sportPractice!.totalAccumulatedTime=0
        }
        sportPractice!.timer=nil
        sportPractice!.id = UUID()
    }
    func play(){
        let totalTime=Int(Double(sportPractice!.practices[sportPractice!.index].repos)-sportPractice!.totalAccumulatedTime)
        sportPractice!.isOn = true
        sportPractice!.timer=Date.now...Date().addingTimeInterval(TimeInterval(totalTime))
        sportPractice!.id = UUID()
    }
    func reset(index:Int?){
        //        TODO: erreur si le nombre de l'index change
        sportPractice!.isOn = false
        sportPractice!.timer=nil
        sportPractice!.totalAccumulatedTime=0
        if let index=index{
            sportPractice!.index = index
        }
        sportPractice!.id = UUID()
    }
    func resetAndPlay(index:Int){
        //        TODO: erreur si le nombre de l'index change
        let totalTime=Int(sportPractice!.practices[sportPractice!.index].repos)
        sportPractice!.isOn = true
        sportPractice!.timer=Date.now...Date().addingTimeInterval(TimeInterval(totalTime))
        sportPractice!.id = UUID()
        sportPractice!.index = index
        sportPractice!.id = UUID()
    }
}
