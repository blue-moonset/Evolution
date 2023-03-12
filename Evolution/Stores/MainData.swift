//
//  MainData.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import Foundation
import CoreData
import SwiftUI
import CloudKit

class MainData:ObservableObject{
    static var shared=MainData()
    @Published var accountStatusICloud:CKAccountStatus = .couldNotDetermine
    @Published var presentedSheet:Bool = false
    @Published var typeSheet:TypeSheet = .check
    @Published var indexValue:Int?
    @Published var dateSelect=Date()
    
    @Published var updatePractice:Practice?
    @Published var trainingDaySelect:TrainingDay?
    enum TypeSheet {
    case check
    case activity
    case updatePractice,addPractice,addTrainingDay,updateTrainingDay,orderTrainingDay
    case updateWorkInHome,addWorkInHome
    }
    
    @Published var mainBackup:Backup?
    @Published var manyBackup=false
    
    var launchScreenState :LaunchScreenStateManager = .shared
    
    @MainActor func fetchMainBackup(fetch:FetchedResults<Backup>)->Backup?{
        if fetch.count == 0{
            return nil
        }else if fetch.count == 1{
            return fetch.first!
        }else{
            if launchScreenState.state != .register{
                manyBackup = true
            }
            return fetch.first!
        }
    }
    func alertICloud()->(String,String)?{
        let textAlert="Les nouvelles données ne pourront être sauvegardées dans le cloud"
        if accountStatusICloud == .noAccount{
            return ("Pas de compte iCloud enregistré",textAlert)
        }else if accountStatusICloud == .restricted{
            return ("Compte iCloud avec une restriction",textAlert)
        }else if accountStatusICloud == .temporarilyUnavailable{
            return ("Compte iCloud momentanément indisponible",textAlert)
        }else if accountStatusICloud == .available{
            return nil
        }else if accountStatusICloud == .couldNotDetermine{
            return nil
        }else{
            return nil
        }
    }
}

class Field:ObservableObject{
    @Published var name:String=""
    @Published var symbol:String?
    @Published var repos:Int=0
    @Published var lien:String=""
    
    @Published var numberRepetitions: Int = 0
    @Published var lengthRepetition: Int = 0
    @Published var maxLengthRepetition: Int = 0
    @Published var typeWait: TypeWait = .repetition
    enum TypeWait {
    case repetition
    case time
    }
}
class Model: ObservableObject {
    static var shared=Model()
    func reloadView() {
        objectWillChange.send()
    }
}
