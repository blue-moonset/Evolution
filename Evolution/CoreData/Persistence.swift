//
//  Persistence.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 29/11/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    static var preview: PersistenceController = {
        let dataPractice=DataPractice()
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        let backup=Backup(context: viewContext)
        
        let isoDateFirstDay = "2023-02-14"
        let dateFormatterFirstDay = DateFormatter()
        dateFormatterFirstDay.dateFormat = "yyyy-MM-dd"
        let firstDay=dateFormatterFirstDay.date(from:isoDateFirstDay)
        backup.date=firstDay!
        
        let settings=Settings(context: viewContext)
        settings.firstDay=firstDay!
        settings.dayLastDeleteDone=Date()
        settings.homePointsGo = 3
        settings.homePointsNone = -4
        settings.clubPointsGo = 10
        settings.clubPointsNone = -6
        settings.register=false
        backup.settings=settings
        
        let archive=TrainingDay(context: viewContext)
        archive.id=UUID()
        archive.active=false
        archive.icone=""
        archive.name="gibjug-8fizxo-byJvov-archive"
        
        for (index,practice) in Array(dataPractice.dataPractice.enumerated()) {
            let newItem = Practice(context: viewContext)
            newItem.id=UUID()
            newItem.index=Int16(index)
            newItem.name=practice.name
            newItem.lien=practice.lien
            newItem.lengthRepetition=Int16(practice.lengthRepetition)
            newItem.maxLengthRepetition=Int16(practice.maxLengthRepetition)
            newItem.numberRepetitions=Int16(practice.numberRepetitions)
            newItem.repetitionInsteadMinute=practice.repetitionInsteadMinute
            newItem.repos=Int16(practice.repos)
            newItem.done=false
            newItem.active=true
            archive.addToPractice(newItem)
        }
        backup.addToTrainingDay(archive)
        
        
        
        for work in dataPractice.workInHome{
            let workInHome=WorkInHome(context: viewContext)
            workInHome.id=work.id
            workInHome.active=work.active
            workInHome.name=work.name
            backup.addToWorkInHome(workInHome)
        }
        
        var allTrainingDays=[TrainingDay]()
        for (index,dayDefault) in dataPractice.trainingDay.enumerated(){
            let trainingDay=TrainingDay(context: viewContext)
            trainingDay.index=Int16(index)
            trainingDay.id=dayDefault.idType
            trainingDay.active=true
            trainingDay.icone=dayDefault.symbole
            trainingDay.name=dayDefault.name
            
            for (index,practice) in Array(dataPractice.dataPractice.filter({$0.idType == trainingDay.id}).enumerated()) {
                let newItem = Practice(context: viewContext)
                newItem.id=UUID()
                newItem.index=Int16(index)
                newItem.name=practice.name
                newItem.lien=practice.lien
                newItem.lengthRepetition=Int16(practice.lengthRepetition)
                newItem.maxLengthRepetition=Int16(practice.maxLengthRepetition)
                newItem.numberRepetitions=Int16(practice.numberRepetitions)
                newItem.repetitionInsteadMinute=practice.repetitionInsteadMinute
                newItem.repos=Int16(practice.repos)
                newItem.done=false
                newItem.active=true
                trainingDay.addToPractice(newItem)
            }
            allTrainingDays.append(trainingDay)
            backup.addToTrainingDay(trainingDay)
        }
        
        for i in 0..<10 {
            var isoDate = "2023-03-\(01+i)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var d=dateFormatter.date(from:isoDate)
            activity(date: d!)
        }
        
        func activity(date:Date){
            let activity = Activity(context: viewContext)
            activity.date=date
            activity.club=Bool.random()
            activity.home=Bool.random()
            
            if activity.home{
                let objectId=ObjectID(context: viewContext)
                objectId.id=backup.allWorkInHome().randomElement()!.id
                activity.addToIdWorkInHome(objectId)
            }
            activity.idTrainingDay=[]
            if !activity.club{
                activity.clubRepos=Bool.random()
                if !activity.clubRepos && !allTrainingDays.isEmpty{
                    let objectId=ObjectID(context: viewContext)
                    objectId.id=allTrainingDays.randomElement()!.id
                    activity.addToIdTrainingDay(objectId)
                }
            }else{
                activity.clubRepos=false
                if !allTrainingDays.isEmpty{
                    let objectId=ObjectID(context: viewContext)
                    objectId.id=allTrainingDays.randomElement()!.id
                    activity.addToIdTrainingDay(objectId)
                }
            }
            backup.addToActivity(activity)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Evolution")
        
        #if DEBUG
        do {
            // Use the container to initialize the development schema.
            try container.initializeCloudKitSchema(options: [])
        } catch {
            // Handle any errors.
        }
        #endif
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
