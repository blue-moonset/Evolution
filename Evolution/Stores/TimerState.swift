//
//  TimerState.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 20/02/2023.
//

import Combine
import Foundation

public class TimerState: ObservableObject{
    static let shared = TimerState()
    
    @Published var timerState:(practices:[Practice],index:Int)?
    @Published var sendWatchIsReachable=false
    @Published var practicesDone:[UUID]?
    @Published var totalAccumulatedTime:Double=0
    @Published var idRefresh=UUID()
    @Published var void:LinkActivity?
    @Published var isOn=false
    @Published var timer:ClosedRange<Date>?
    
    
    let allCases=LinkActivity.allCases
}
public enum LinkActivity:String,CaseIterable{
    case last,next,play,pause,reset
}
