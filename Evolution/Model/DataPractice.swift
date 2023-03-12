//
//  DataPractice.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 21/01/2023.
//

import Foundation
import SwiftUI

struct ModelPractice: Identifiable,Hashable {
    let id = UUID()
    var idType: UUID
    var name: String
    var maxLengthRepetition: Int
    var lengthRepetition: Int
    var repetitionInsteadMinute: Bool
    var numberRepetitions: Int
    var repos: Int
    var lien: String
    var done:Bool
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(idType)
    }
}
struct TrainingDayDefault {
    let symbole:String
    let idType=UUID()
    let name:String
}
struct WorkInHomeDefault {
    let id=UUID()
    let active=true
    let name:String
}
class DataPractice{
    init() {
        dataPractice = [
            ModelPractice(idType: trainingDay[0].idType, name: "Chest press", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[0].idType, name: "Pec deck", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[0].idType, name: "Poulie haut pec", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[0].idType, name: "Tirage vertical", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[0].idType, name: "Rowing", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[0].idType, name: "Tractions", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 120, lien: "", done: false),
            ModelPractice(idType: trainingDay[0].idType, name: "Elevations latérales", maxLengthRepetition: 12, lengthRepetition: 10, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "https://www.youtube.com/shorts/67aqcWUYw2I", done: false),



            ModelPractice(idType: trainingDay[1].idType, name: "Squat", maxLengthRepetition: 6, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 150, lien: "https://www.youtube.com/shorts/rRKCJMrTObI", done:false),
            ModelPractice(idType: trainingDay[1].idType, name: "Bulgarian Split squat", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 3, repos: 150, lien: "https://www.youtube.com/shorts/D3-FltbX0-s", done:false),
            ModelPractice(idType: trainingDay[1].idType, name: "Press", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 120, lien: "https://www.youtube.com/shorts/D3-FltbX0-s", done:false),
            ModelPractice(idType: trainingDay[1].idType, name: "Leg extension", maxLengthRepetition: 0, lengthRepetition: 15, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 150, lien: "https://www.youtube.com/shorts/ys-M5FAk9MU", done:false),
            ModelPractice(idType: trainingDay[1].idType, name: "Leg Curl", maxLengthRepetition: 0, lengthRepetition: 15, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 150, lien: "https://www.youtube.com/shorts/EJZTz1-0PUE", done:false),
            ModelPractice(idType: trainingDay[1].idType, name: "Mollets", maxLengthRepetition: 0, lengthRepetition: 15, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 60, lien: "https://www.youtube.com/shorts/I5WjaL8TfT8", done:false),

            ModelPractice(idType: trainingDay[2].idType, name: "Développé couché", maxLengthRepetition: 8, lengthRepetition: 6, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 120, lien: "https://www.youtube.com/shorts/7P562roxtSc", done: false),
            ModelPractice(idType: trainingDay[2].idType, name: "Développé incliné haltères", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 3, repos: 120, lien: "https://www.youtube.com/shorts/3rS4I1HKyig", done: false),
            ModelPractice(idType: trainingDay[2].idType, name: "Poulie vis-à-vis", maxLengthRepetition: 15, lengthRepetition: 12, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "https://www.youtube.com/shorts/TaPVpugw6Zs", done: false),
            ModelPractice(idType: trainingDay[2].idType, name: "Dévéloppé militaire", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 3, repos: 90, lien: "https://www.youtube.com/watch?v=5pjcqP_nqRA", done: false),
            ModelPractice(idType: trainingDay[2].idType, name: "Triceps Pushdown", maxLengthRepetition: 20, lengthRepetition: 15, repetitionInsteadMinute: true, numberRepetitions: 3, repos: 90, lien: "https://www.youtube.com/shorts/Np7cWNTo86o", done: false),
            ModelPractice(idType: trainingDay[2].idType, name: "Dips", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[2].idType, name: "Spider curl ou curl pupitre", maxLengthRepetition: 12, lengthRepetition: 10, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "https://www.youtube.com/watch?v=J1PKSTZs3Cw", done: false),


            ModelPractice(idType: trainingDay[3].idType, name: "Deadlift", maxLengthRepetition: 0, lengthRepetition: 5, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 120, lien: "https://www.youtube.com/shorts/Tr85HIOTce0", done: false),
            ModelPractice(idType: trainingDay[3].idType, name: "Pull Over", maxLengthRepetition: 12, lengthRepetition: 10, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 150, lien: "https://www.youtube.com/watch?v=xRl4mDmayXo", done: false),
            ModelPractice(idType: trainingDay[3].idType, name: "Curl marteau biceps", maxLengthRepetition: 8, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 8, repos: 30, lien: "https://www.youtube.com/watch?v=XtruE8T-19Q", done: false),
            ModelPractice(idType: trainingDay[3].idType, name: "Barre au front", maxLengthRepetition: 12, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 120, lien: "https://www.youtube.com/watch?v=_xC3qsF9cO4", done: false),
            ModelPractice(idType: trainingDay[3].idType, name: "Elevations latérales poulies", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[3].idType, name: "Elevations latérales", maxLengthRepetition: 12, lengthRepetition: 10, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "https://www.youtube.com/shorts/67aqcWUYw2I", done: false),



            ModelPractice(idType: trainingDay[4].idType, name: "Chest press", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[4].idType, name: "Pec deck", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[4].idType, name: "Poulie haut pec", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[4].idType, name: "Tirage horizontale", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[4].idType, name: "T bar", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[4].idType, name: "Tractions", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 120, lien: "", done:false),
            ModelPractice(idType: trainingDay[4].idType, name: "Elevations latérales", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 4, repos: 90, lien: "https://www.youtube.com/shorts/67aqcWUYw2I", done:false),

            ModelPractice(idType: trainingDay[5].idType, name: "Gainage", maxLengthRepetition: 0, lengthRepetition: 120, repetitionInsteadMinute: false, numberRepetitions: 3, repos: 120, lien: "", done:false),
            ModelPractice(idType: trainingDay[5].idType, name: "Banc incline avec poids", maxLengthRepetition: 0, lengthRepetition: 20, repetitionInsteadMinute: false, numberRepetitions: 3, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[5].idType, name: "Banc incline côté des abdos", maxLengthRepetition: 0, lengthRepetition: 15, repetitionInsteadMinute: false, numberRepetitions: 3, repos: 90, lien: "", done:false),
            ModelPractice(idType: trainingDay[5].idType, name: "Abdo coté machine", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 3, repos: 60, lien: "https://www.youtube.com/shorts/67aqcWUYw2I", done:false),

            ModelPractice(idType: trainingDay[5].idType, name: "Roulette abdos", maxLengthRepetition: 15, lengthRepetition: 4, repetitionInsteadMinute: true, numberRepetitions: 15, repos: 90, lien: "https://www.youtube.com/shorts/SoxLgm4E8uA", done: false),
            ModelPractice(idType: trainingDay[5].idType, name: "Lombaires", maxLengthRepetition: 10, lengthRepetition: 3, repetitionInsteadMinute: true, numberRepetitions: 10, repos: 90, lien: "", done: false),
            ModelPractice(idType: trainingDay[5].idType, name: "Dips", maxLengthRepetition: 10, lengthRepetition: 8, repetitionInsteadMinute: true, numberRepetitions: 8, repos: 90, lien: "", done: false)
        ]
        
    }
    var trainingDay:[TrainingDayDefault]=[
        TrainingDayDefault(symbole: "figure.boxing",name:"Mix 1"),
        TrainingDayDefault(symbole: "figure.step.training",name: "Legs"),
        TrainingDayDefault(symbole: "dumbbell.fill",name:"Push"),
        TrainingDayDefault(symbole: "figure.strengthtraining.traditional",name:"Pull"),
        TrainingDayDefault(symbole: "figure.boxing",name:"Mix 2"),
        TrainingDayDefault(symbole: "figure.core.training",name:"Abdo")
    ]
    
    var dataPractice : [ModelPractice] = []
    var workInHome : [WorkInHomeDefault] = [
        WorkInHomeDefault(name: "Abdo"),
        WorkInHomeDefault(name: "pompe")
    ]
    //    let isoDate = "2023-01-23"
    //    let dateFormatter = DateFormatter()
    //    dateFormatter.dateFormat = "yyyy-MM-dd"
    //    let d=dateFormatter.date(from:isoDate)
    //    settings.firstDay=d!
    //    defaultValue()
}


//private func defaultValue() {
//    for (index,dayDefault) in dataPractice.trainingDay.enumerated(){
//        let trainingDay=TrainingDay(context: viewContext)
//        trainingDay.index=Int16(index)
//        trainingDay.id=dayDefault.idType
//        trainingDay.active=true
//        trainingDay.icone=dayDefault.symbole
//        trainingDay.name=dayDefault.name
//        for (index,practice) in Array(dataPractice.dataPractice.filter({$0.idType==trainingDay.id}).enumerated()) {
//            let newItem = Practice(context: viewContext)
//            newItem.id=UUID()
//            newItem.index=Int16(index)
//            newItem.name=practice.name
//            newItem.lien=practice.lien
//            newItem.repetitions=practice.repetitions
//            newItem.repos=Int16(practice.repos)
//            newItem.done=false
//            newItem.active=true
//            trainingDay.addToPractice(newItem)
//        }
//    }
//    do {
//        try viewContext.save()
//    } catch {
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    }
//}
