//
//  TimeMode.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 25/01/2023.
//

import SwiftUI

struct TimeMode: View {
    @StateObject var timerState:TimerState = .shared
    @Environment(\.scenePhase) var scenePhase
//    var helper: LiveActivityHelper = .shared
    @StateObject var watchManager : WatchManager = .shared
    let timerForOnReceive = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    reset()
                }){
                    Text(timerState.timerState!.practices[timerState.timerState!.index].name)
                        .fontWeight(.bold)
                        .font(.title3)
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
                Spacer()
                Text("")
            }
            Divider()
            HStack {
                Image(systemName: "arrow.left.to.line")
                    .foregroundColor(timerState.timerState!.index - 1 >= 0 ? .blue:.gray)
                    .fontWeight(.bold)
                    .font(.body)
                    .frame(width: 30,height: 30)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
                    .onTapGesture {
                        last()
                    }
                
                
                Image(systemName: timerState.isOn ? "pause.fill":"play.fill")
                    .foregroundColor(.white)
                    .font(.title2)
                    .frame(width: 40,height: 40)
                    .background(.blue)
                    .clipShape(Circle())
                    .onTapGesture {
                        timerState.isOn.toggle()
                        if timerState.isOn{
                            play()
                        }else{
                            pause()
                        }
                    }
                    .padding(.leading,20)
                
                Spacer(minLength: 20)
                Label {
                    Group{
                        if timerState.timer != nil{
                            Text(timerInterval: timerState.timer!, countsDown: true)
//                                .animation(.default, value: timerState.timer?.lowerBound)
//                                .contentTransition(.numericText(countsDown: false))
                                
                        }else{
                            Text(timeInString())
                        }
                    }
                    .multilineTextAlignment(.center)
                    .frame(width: 50)
                    .monospacedDigit()
                } icon: {
                    Image(systemName: "timer")
                        .foregroundColor(.indigo)
                }.font(.title2)
                
                Spacer(minLength: 20)
                Image(systemName: "arrow.right.to.line")
                    .foregroundColor(timerState.timerState!.index + 1 <= timerState.timerState!.practices.count-1 ? .blue:.gray)
                    .fontWeight(.bold)
                    .font(.body)
                    .frame(width: 30,height: 30)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
                    .padding(.leading,20)
                    .onTapGesture {
                        next()
                    }
            }
        }.onChange(of: timerState.void){ new in
            if new != nil{
                if new == .pause{
                    pause()
                }else if new == .play{
                    play()
                }else if new == .reset{
                    reset()
                }else if new == .next{
                    next()
                }else if new == .last{
                    last()
                }
            }
        }.onChange(of:timerState.idRefresh){ new in
            send()
        }.onChange(of:timerState.sendWatchIsReachable){ new in
            if new{
                send()
                timerState.sendWatchIsReachable=false
            }
        }.onAppear{
            send()
        }.onReceive(timerForOnReceive) { input in
            if timerState.timer != nil{
                timerFinish(timer: timerState.timer!)
            }
        }
    }
    func send(){
        watchManager.sendFromIOS(practice: AttributesForWatch(timer: timerState.timer, isOn: timerState.isOn, totalAccumulatedTime: timerState.totalAccumulatedTime, practices:convertPractice(timerState.timerState!.practices), index: timerState.timerState!.index))
            timerState.sendWatchIsReachable=false
    }
    func timerFinish(timer:ClosedRange<Date>){
        if Date() > timer.upperBound{
            reset()
        }
    }
    func pause(){
        impactLight()
        timerState.isOn=false
        if timerState.timer != nil{
            timerState.totalAccumulatedTime = timerState.totalAccumulatedTime + (-Double(timerState.timer!.lowerBound.timeIntervalSince(Date())))
        }else{
            timerState.totalAccumulatedTime=0
        }
//        if helper.practiceActivity != nil{
//            helper.update(timer: Date.now...Date(), void: .pause)
//        }
        timerState.timer=nil
        timerState.idRefresh=UUID()
    }
    func play(){
        impactLight()
        timerState.isOn=true
        timerState.timer=Date.now...Date().addingTimeInterval(TimeInterval(Double(timerState.timerState!.practices[timerState.timerState!.index].repos)-timerState.totalAccumulatedTime))
        timerState.idRefresh=UUID()
//        if helper.practiceActivity == nil{
//            helper.start(timer: timerState.timer!)
//        }else{
//            helper.update(timer: timerState.timer!, void: .play)
//        }
    }
    func last(){
        if timerState.timerState!.index - 1 >= 0{
            impactLight()
            timerState.timerState!.index -= 1
            timerState.isOn=false
            timerState.timer=nil
            timerState.totalAccumulatedTime=0
            timerState.idRefresh=UUID()
//            if helper.practiceActivity != nil{
//                helper.update(timer: Date.now...Date(), void: .last)
//            }
        }
    }
    func next(){
        if timerState.timerState!.index + 1 <= timerState.timerState!.practices.count-1{
            impactLight()
            timerState.timerState!.index += 1
            timerState.isOn=false
            timerState.timer=nil
            timerState.totalAccumulatedTime=0
            timerState.idRefresh=UUID()
//            if helper.practiceActivity != nil{
//                helper.update(timer: Date.now...Date(), void: .next)
//            }
        }
    }
    func reset(){
        impactLight()
        timerState.isOn=false
        timerState.timer=nil
        timerState.totalAccumulatedTime=0
        timerState.idRefresh=UUID()
//        if helper.practiceActivity != nil{
//            helper.update(timer: Date.now...Date(), void: .reset)
//        }
    }
    
    func timeInString() -> String {
        let time = Double(timerState.timerState!.practices[timerState.timerState!.index].repos) - timerState.totalAccumulatedTime
        let minutes = Int(time / 60)
        let seconds = time.truncatingRemainder(dividingBy: 60)
        return String(format: "%01d:%02d", Int(minutes), Int(seconds))
    }
}

import Foundation
import CoreData
struct TimeMode_Previews: PreviewProvider {
    static let timerState: TimerState = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    static let fetchRequest: NSFetchRequest<TrainingDay> = TrainingDay.fetchRequest()
    static var previews: some View {
        VStack {
            List {
                if let trainingDay = try? viewContext.fetch(fetchRequest).first, save(trainingDay){
                    TimeMode(timerState:timerState)
                }
            }
        }.environment(\.managedObjectContext, viewContext)
        
    }
    static func save(_ trainingDay:TrainingDay)->Bool{
        TimeMode_Previews.timerState.timerState=(practices:trainingDay.allPractice(),index:0)
        return true
    }
}
