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
            if let practice=watchManager.practice{
                TabView(selection: $selection){
                    ForEach(Array(practice.practices.enumerated()), id: \.offset) { (index,item) in
                        ItemPractice(practice:item,globalData:practice)
                            .tag(index)
                    }
                }.tabViewStyle(.carousel)
                    .edgesIgnoringSafeArea(.all)
                    .onReceive(timerForOnReceive) { input in
                        if watchManager.practice!.timer != nil{
                            watchManager.timerFinish(timer: watchManager.practice!.timer!)
                        }
                    }.onChange(of: practice.id){ new in
                        watchManager.sendFromWatchOS(practice: AttributesForWatchToIOS(timer:  watchManager.practice!.timer, isOn: watchManager.practice!.isOn, totalAccumulatedTime: watchManager.practice!.totalAccumulatedTime, index: watchManager.practice!.index))
                    }.onChange(of: practicesDone){ new in
                        watchManager.saveFromWatchOS(practicesDone: new)
                    }.onChange(of: practice.index){ new in
                        withAnimation(){
                            selection=new
                        }
                    }.onChange(of: watchManager.practice!.isOn){ new in
                        if new == true{
                            hapticsEngine.startSessionIfNeeded()
                        }else{
                            hapticsEngine.stopSession()
                        }
                    }.onAppear{
                        withAnimation(){
                            selection=practice.index
                        }
                    }
            }else{
                Text("Choisir un jour")
            }
        }
    }
    @ViewBuilder
    func ItemPractice(practice: PracticeForWatch,globalData:AttributesForWatchConvert)-> some View{
        VStack(spacing: 0){
            Button(action: {
                WKInterfaceDevice.current().play(.click)
                watchManager.reset(index: selection)
            }) {
                VStack(spacing: 0){
                    Text(practice.name.capitalizedSentence)
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
                    WKInterfaceDevice.current().play(.click)
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
                    Group{
                        if practice.id == globalData.practices[globalData.index].id{
                            Image(systemName: globalData.isOn ? "pause.circle.fill":"play.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50,height: 50)
                        }else{
                            Image(systemName: "play.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 50,height: 50)
                        }
                    }
                }.buttonStyle(ScaleButtonStyle())
                    .foregroundStyle(.white,.blue)
                    .fontWeight(.bold)
                    
                
                Spacer(minLength: 5)
                Button(action: {
                    WKInterfaceDevice.current().play(.click)
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
                                Color.white.frame(width: 12,height: 23)
                                    .rotationEffect(.degrees(30))
                                    .offset(x:-2,y:-3)
                                Color.white.frame(width: 9,height: 10)
                                    .offset(x:15, y:9.5)
                            }
                        }
                    }
                }.buttonStyle(ScaleButtonStyle())
                    .fontWeight(.bold)
                    .font(.title)
                
            }.padding(.horizontal,40)
                .padding(.bottom,10)
            
            
        }.edgesIgnoringSafeArea(.bottom)
        
        
    }
    
    func doneErrorWhenSave(_ practice: PracticeForWatch)->Bool{
        if practicesDone.contains(where: {$0 == practice.id}) && !practice.done{
            return true
        }else{
            return false
        }
    }
    func timeInString(practice: PracticeForWatch) -> String {
        let time: Double = Double(practice.repos) - watchManager.practice!.totalAccumulatedTime
        
        let minutes = Int(time / 60)
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%01d:%02d", Int(minutes), Int(seconds))
    }
    func timeInStringFix(practice: PracticeForWatch) -> String {
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
    static let fetchRequest: NSFetchRequest<TrainingDay> = TrainingDay.fetchRequest()
    static var previews: some View {
        if let trainingDay = try? viewContext.fetch(fetchRequest).first, save(trainingDay){
            ContentWatchView(watchManager:watchManager)
            
        }
    }
    static func save(_ trainingDay:TrainingDay)->Bool{
        timerState.timerState=(practices:trainingDay.allPractice(),index:0)
        timerState.isOn=true
        timerState.timer=Date.now...Date().addingTimeInterval(TimeInterval(90))
        
        let practice = AttributesForWatchConvert(timer: timerState.timer!, isOn: timerState.isOn,totalAccumulatedTime: timerState.totalAccumulatedTime, practices: convert(timerState.timerState!.practices),index: timerState.timerState!.index)
        watchManager.subject.send(practice)
        return true
    }
    static func convert(_ practice:[Practice])->[PracticeForWatch] {
        var dic=[PracticeForWatch]()
        for practice in practice {
            dic.append(PracticeForWatch(repetitions: practice.convertRepetitionToString(), name: practice.name, done: practice.done, repos: Int(practice.repos), id: practice.id))
        }
        return dic
    }
}
private extension WatchManager{
    
    func timerFinish(timer:ClosedRange<Date>){
        if practice!.totalAccumulatedTime+(-Double(practice!.timer!.lowerBound.timeIntervalSince(Date()))) > Double(practice!.practices[practice!.index].repos){
            print("tiemrFinish")
            HapticsEngine.shared.tick()
            reset(index:nil)
        }
    }
    func pause(){
        practice!.isOn = false
        if practice!.timer != nil{
            practice!.totalAccumulatedTime=practice!.totalAccumulatedTime + (-Double(practice!.timer!.lowerBound.timeIntervalSince(Date())))
        }else{
            practice!.totalAccumulatedTime=0
        }
        practice!.timer=nil
        practice!.id = UUID()
    }
    func play(){
        let totalTime=Int(Double(practice!.practices[practice!.index].repos)-practice!.totalAccumulatedTime)
        practice!.isOn = true
        practice!.timer=Date.now...Date().addingTimeInterval(TimeInterval(totalTime))
        practice!.id = UUID()
    }
    func reset(index:Int?){
        practice!.isOn = false
        practice!.timer=nil
        practice!.totalAccumulatedTime=0
        if let index=index{
            practice!.index = index
        }
        practice!.id = UUID()
    }
    func resetAndPlay(index:Int){
        let totalTime=Int(practice!.practices[index].repos)
        practice!.totalAccumulatedTime=0
        practice!.isOn = true
        practice!.timer=Date.now...Date().addingTimeInterval(TimeInterval(totalTime))
        practice!.id = UUID()
        practice!.index = index
        practice!.id = UUID()
    }
}
