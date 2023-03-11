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
        
        let settings=Settings(context: viewContext)
        let isoDateFirstDay = "2023-01-26"
        
        let dateFormatterFirstDay = DateFormatter()
        dateFormatterFirstDay.dateFormat = "yyyy-MM-dd"
        let firstDay=dateFormatterFirstDay.date(from:isoDateFirstDay)
        settings.firstDay=firstDay!
        settings.dayLastDeleteDone=Date()
        settings.homePointsGo = 3
        settings.homePointsNone = -4
        settings.clubPointsGo = 10
        settings.clubPointsNone = -6
        settings.register=true
       
        var allTypeDays=[TypeDay]()
        for (index,dayDefault) in dataPractice.typeDay.enumerated(){
            let typeDay=TypeDay(context: viewContext)
            typeDay.index=Int16(index)
            typeDay.id=dayDefault.idType
            typeDay.active=true
            typeDay.icone=dayDefault.symbole
            typeDay.name=dayDefault.name
            
            for (index,practice) in Array(dataPractice.dataPractice.filter({$0.idType == typeDay.id}).enumerated()) {
                let newItem = SportPractice(context: viewContext)
                newItem.id=UUID()
                newItem.index=Int16(index)
                newItem.title=practice.title
                newItem.lien=practice.lien
                newItem.repetitions=practice.repetitions
                newItem.repos=Int16(practice.repos)
                newItem.done=false
                newItem.active=true
                typeDay.addToSportPractice(newItem)
            }
            allTypeDays.append(typeDay)
        }
        
        for i in 0..<7 {
            var isoDate = "2023-01-\(16+i)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            var d=dateFormatter.date(from:isoDate)
            day(date: d!)
        }
        var isoDate = "2023-01-\(20)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        var d=dateFormatter.date(from:isoDate)
        day(date: d!)
        
        func day(date:Date){
            let day = Day(context: viewContext)
            day.dateOfDay=date
            day.club=Bool.random()
            
            day.home=Bool.random()
            if day.home{
                let new=TypeHome(context: viewContext)
                new.abdo=Bool.random()
                new.pompe=Bool.random()
                if !new.abdo && !new.pompe{
                    new.abdo=true
                }
                day.typeHome=new
            }
            day.idTypeDay=[]
            if !day.club{
                day.clubRepos=Bool.random()
                if !day.clubRepos{
                    day.idTypeDay.append(allTypeDays.randomElement()!.id)
                }
            }else{
                day.clubRepos=false
                day.idTypeDay.append(allTypeDays.randomElement()!.id)
            }
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
