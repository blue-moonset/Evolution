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
    var title: String
    var repetitions: String
    var repos: Int
    var lien: String
    var done:Bool
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(idType)
    }
}
struct TypeDayDefault {
    var symbole:String
    let idType=UUID()
    var name:String
}
class DataPractice{
    init() {
        dataPractice = [
            ModelPractice(idType: typeDay[0].idType, title: "Chest press", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[0].idType, title: "Pec deck", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[0].idType, title: "Poulie haut pec", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[0].idType, title: "Tirage vertical", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[0].idType, title: "Rowing", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[0].idType, title: "Tractions", repetitions: "4 x 8/10 répétitions", repos: 120, lien: "",done:false),
            ModelPractice(idType: typeDay[0].idType, title: "Elevations latérales", repetitions: "4 x 10/12 répétitions", repos: 90, lien: "https://www.youtube.com/shorts/67aqcWUYw2I",done:false),
            
            ModelPractice(idType: typeDay[1].idType, title: "Squat", repetitions: "4 x 6/8 répétitions", repos: 150, lien: "https://www.youtube.com/shorts/rRKCJMrTObI",done:false),
            ModelPractice(idType: typeDay[1].idType, title: "Bulgarian Split squat", repetitions: "3 x 10 répétitions", repos: 150, lien: "https://www.youtube.com/shorts/D3-FltbX0-s",done:false),
            ModelPractice(idType: typeDay[1].idType, title: "Press", repetitions: "4 x 8/10 répétitions", repos: 120, lien: "https://www.youtube.com/shorts/D3-FltbX0-s",done:false),
            ModelPractice(idType: typeDay[1].idType, title: "Leg extension", repetitions: "4 x 15 répétitions", repos: 150, lien: "https://www.youtube.com/shorts/ys-M5FAk9MU",done:false),
            ModelPractice(idType: typeDay[1].idType, title: "Leg Curl", repetitions: "4 x 15 répétitions", repos: 150, lien: "https://www.youtube.com/shorts/EJZTz1-0PUE",done:false),
            ModelPractice(idType: typeDay[1].idType, title: "Mollets", repetitions: "4 x 15 répétitions", repos: 60, lien: "https://www.youtube.com/shorts/I5WjaL8TfT8",done:false),
            
            
            ModelPractice(idType: typeDay[2].idType, title: "Développé couché", repetitions: "4 x 6/8 répétitions", repos: 120, lien: "https://www.youtube.com/shorts/7P562roxtSc",done:false),
            ModelPractice(idType: typeDay[2].idType, title: "Développé incliné haltères", repetitions: "3 x 8/10 répétitions", repos: 120, lien: "https://www.youtube.com/shorts/3rS4I1HKyig",done:false),
            ModelPractice(idType: typeDay[2].idType, title: "Poulie vis-à-vis", repetitions: "4 x 12/15 répétitions", repos: 90, lien: "https://www.youtube.com/shorts/TaPVpugw6Zs",done:false),
            ModelPractice(idType: typeDay[2].idType, title: "Dévéloppé militaire", repetitions: "3 x 8/10 répétitions", repos: 90, lien: "https://www.youtube.com/watch?v=5pjcqP_nqRA",done:false),
            ModelPractice(idType: typeDay[2].idType, title: "Triceps Pushdown", repetitions: "3 x 15/20 répétitions", repos: 90, lien: "https://www.youtube.com/shorts/Np7cWNTo86o",done:false),
            ModelPractice(idType: typeDay[2].idType, title: "Dips", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[2].idType, title: "Spider curl ou curl pupitre", repetitions: "4 x 10/12 répétitions", repos: 90, lien: "https://www.youtube.com/watch?v=J1PKSTZs3Cw",done:false),
            
            ModelPractice(idType: typeDay[3].idType, title: "Deadlift", repetitions: "4 x 5 répétitions", repos: 120, lien: "https://www.youtube.com/shorts/Tr85HIOTce0",done:false),
            ModelPractice(idType: typeDay[3].idType, title: "Pull Over", repetitions: "4 x 10/12 répétitions", repos: 150, lien: "https://www.youtube.com/watch?v=xRl4mDmayXo",done:false),
            ModelPractice(idType: typeDay[3].idType, title: "Curl marteau biceps", repetitions: "8 x 8 répétitions", repos: 30, lien: "https://www.youtube.com/watch?v=XtruE8T-19Q",done:false),
            ModelPractice(idType: typeDay[3].idType, title: "Barre au front", repetitions: "4 x 8/12 répétitions", repos: 120, lien: "https://www.youtube.com/watch?v=_xC3qsF9cO4",done:false),
            ModelPractice(idType: typeDay[3].idType, title: "Elevations latérales poulies", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[3].idType, title: "Elevations latérales", repetitions: "4 x 10/12 répétitions", repos: 90, lien: "https://www.youtube.com/shorts/67aqcWUYw2I",done:false),
            
            
            
            ModelPractice(idType: typeDay[4].idType, title: "Chest press", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[4].idType, title: "Pec deck", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[4].idType, title: "Poulie haut pec", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[4].idType, title: "Tirage horizontale", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[4].idType, title: "T bar", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[4].idType, title: "Tractions", repetitions: "4 x 8/10 répétitions", repos: 120, lien: "",done:false),
            ModelPractice(idType: typeDay[4].idType, title: "Elevations latérales", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "https://www.youtube.com/shorts/67aqcWUYw2I",done:false),
            
            ModelPractice(idType: typeDay[5].idType, title: "Gainage", repetitions: "3 x 2 min", repos: 120, lien: "",done:false),
            ModelPractice(idType: typeDay[5].idType, title: "Banc incline avec poids", repetitions: "3 x 20 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[5].idType, title: "Banc incline côté des abdos", repetitions: "4 x 15 (chaque côté) répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[5].idType, title: "Abdo coté machine", repetitions: "4 x 8/10 répétitions", repos: 60, lien: "https://www.youtube.com/shorts/67aqcWUYw2I",done:false),
            ModelPractice(idType: typeDay[5].idType, title: "Roulette abdos", repetitions: "4 x 15 répétitions", repos: 90, lien: "https://www.youtube.com/shorts/SoxLgm4E8uA",done:false),
            ModelPractice(idType: typeDay[5].idType, title: "Lombaires", repetitions: "3 x 10 répétitions", repos: 90, lien: "",done:false),
            ModelPractice(idType: typeDay[5].idType, title: "Dips", repetitions: "4 x 8/10 répétitions", repos: 90, lien: "",done:false),
        ]
        
    }
    var typeDay:[TypeDayDefault]=[
        TypeDayDefault(symbole: "figure.boxing",name:"Mix 1"),
        TypeDayDefault(symbole: "figure.step.training",name: "Legs"),
        TypeDayDefault(symbole: "dumbbell.fill",name:"Push"),
        TypeDayDefault(symbole: "figure.strengthtraining.traditional",name:"Pull"),
        TypeDayDefault(symbole: "figure.boxing",name:"Mix 2"),
        TypeDayDefault(symbole: "figure.core.training",name:"Abdo")]
    
    var dataPractice : [ModelPractice] = []
    //    let isoDate = "2023-01-23"
    //    let dateFormatter = DateFormatter()
    //    dateFormatter.dateFormat = "yyyy-MM-dd"
    //    let d=dateFormatter.date(from:isoDate)
    //    settings.firstDay=d!
    //    defaultValue()
}


//private func defaultValue() {
//    for (index,dayDefault) in dataPractice.typeDay.enumerated(){
//        let typeDay=TypeDay(context: viewContext)
//        typeDay.index=Int16(index)
//        typeDay.id=dayDefault.idType
//        typeDay.active=true
//        typeDay.icone=dayDefault.symbole
//        typeDay.name=dayDefault.name
//        for (index,practice) in Array(dataPractice.dataPractice.filter({$0.idType==typeDay.id}).enumerated()) {
//            let newItem = SportPractice(context: viewContext)
//            newItem.id=UUID()
//            newItem.index=Int16(index)
//            newItem.title=practice.title
//            newItem.lien=practice.lien
//            newItem.repetitions=practice.repetitions
//            newItem.repos=Int16(practice.repos)
//            newItem.done=false
//            newItem.active=true
//            typeDay.addToSportPractice(newItem)
//        }
//    }
//    do {
//        try viewContext.save()
//    } catch {
//        let nsError = error as NSError
//        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//    }
//}
