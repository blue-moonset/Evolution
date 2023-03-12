//
//  AddPractice.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import SwiftUI
import CoreData
struct AddPractice: View {
    @StateObject var field=Field()
    @StateObject var mainData:MainData = .shared
    @Environment(\.managedObjectContext) private var viewContext
    let generator = UINotificationFeedbackGenerator()
    @State var showSheet:Bool=false
    @State var valueStepper=0
    @State var plus=false
    @State var indexStepper=0
    @State var showSheetArchive=false
    @StateObject var timerState:TimerState = .shared
    var body: some View {
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $field.name)
            }
            Section{
                VStack {
                    HStack{
                        Spacer()
                        HStack {
                            Text("Répétitions")
                                .padding(.horizontal,12)
                                .padding(.vertical,4)
                                .foregroundColor(field.typeWait == .repetition ? .blue.opacity(0.9):.gray)
                                .background(field.typeWait == .repetition ? Color.blue.opacity(0.18):Color.clear)
                                .fontWeight(.semibold)
                                .clipShape(RoundedCorner())
                                .onTapGesture {
                                    if field.typeWait != .repetition{
                                        impactLight()
                                        field.typeWait = .repetition
                                        field.lengthRepetition = 8
                                        if plus{
                                            field.maxLengthRepetition = 10
                                        }
                                    }
                                }
                            Text("Temps")
                                .padding(.horizontal,12)
                                .padding(.vertical,4).foregroundColor(field.typeWait != .repetition ? .blue.opacity(0.9):.gray)
                                .background(field.typeWait != .repetition ? Color.blue.opacity(0.18):Color.clear)
                                .fontWeight(.semibold)
                                .clipShape(RoundedCorner())
                                .onTapGesture {
                                    if field.typeWait != .time{
                                        impactLight()
                                        field.typeWait = .time
                                        field.lengthRepetition = 60
                                        if plus{
                                            field.maxLengthRepetition = 75
                                        }
                                    }
                                }
                        }.padding(.all,4)
                            .background(.white)
                            .clipShape(RoundedCorner())
                        
                        Spacer()
                    }.padding(.bottom,20)
                    HStack {
                        Text("\(field.numberRepetitions)")
                            .padding(.horizontal,14)
                            .padding(.vertical,6)
                            .background(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                showSheet=true
                                indexStepper=0
                                impactLight()
                            }
                        Text("x")
                            .frame(width: 15)
                            .padding(.vertical,6)
                        
                        
                        Text("\(field.typeWait == .repetition ? "\(field.lengthRepetition)":field.lengthRepetition.convertSecondsToMinutes())")
                            .padding(.horizontal,14)
                            .padding(.vertical,6)
                            .background(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                showSheet=true
                                indexStepper=1
                                impactLight()
                            }
                        if !plus{
                            HStack {
                                Text("à ")
                                    .offset(y:-1)
                                Image(systemName: "plus.circle")
                                
                            }.frame(width: 65)
                                .padding(.vertical,6)
                                .foregroundColor(.gray)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(8)
                                .onTapGesture {
                                    plus=true
                                    if field.typeWait == .repetition{
                                        if  field.maxLengthRepetition<field.lengthRepetition+2{
                                            field.maxLengthRepetition=field.lengthRepetition+2
                                        }
                                    }else{
                                        if  field.maxLengthRepetition<field.lengthRepetition+15{
                                            field.maxLengthRepetition=field.lengthRepetition+15
                                        }
                                    }
                                    
                                    impactLight()
                                }
                        }else{
                            Text("/")
                                .frame(width: 15)
                                .padding(.vertical,6)
                            Text("\(field.typeWait == .repetition ? "\(field.maxLengthRepetition)":field.maxLengthRepetition.convertSecondsToMinutes())")
                                .padding(.horizontal,14)
                                .padding(.vertical,6)
                                .background(.white)
                                .cornerRadius(8)
                                .onTapGesture {
                                    showSheet=true
                                    indexStepper=2
                                    impactLight()
                                }
                            HStack {
                                Image(systemName: "minus.circle")
                            }.frame(width: 25)
                                .padding(.vertical,6)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    plus=false
                                    impactLight()
                                }
                        }
                    }
                }
            }.listRowBackground(Color(.secondarySystemBackground))
            
            Section(header: Text("Repos")) {
                Stepper(value: $field.repos, in: 0...3*60, step: 15) {
                    Text(Int(field.repos).convertSecondsToMinutes())
                }
                
            }
            Section(header: Text("Lien")) {
                TextField("Lien", text: $field.lien)
                    .foregroundColor(.blue)
            }
            if !mainData.mainBackup!.getArchive()[0].allPractice().isEmpty{
                Section {
                    Button(action: {
                        showSheetArchive=true
                    }){
                        HStack {
                            Spacer()
                            Image(systemName: "archivebox")
                                .font(.callout)
                            Text("Choisir dans les archives")
                                .fontWeight(.semibold)
                            Spacer()
                        }.foregroundColor(.blue)
                    }
                }
            }
            Section {
                Button(action: {
                    save()
                }){
                    HStack {
                        Spacer()
                        Text("Enregistrer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.blue)
                }
            }
            Section {
                Button(action: {
                    mainData.presentedSheet=false
                    impactLight()
                }){
                    HStack {
                        Spacer()
                        Text("Annuler")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.red)
                }
                
            }
        }.onAppear{
            field.name=""
            field.numberRepetitions = 4
            field.lengthRepetition = 8
            field.typeWait = .repetition
            field.repos=90
            field.lien=""
        }.sheet(isPresented: $showSheet){
            VStack{
                Stepper(value: $valueStepper, in: indexStepper==0 ? (1...50):(indexStepper==1 ? (field.typeWait == .repetition ? (1...200):(15...1800)):((field.lengthRepetition+(field.typeWait == .repetition ? 2:15))...(field.typeWait == .repetition ? 220:1815))), step: field.typeWait == .repetition ? 1:15) {
                    HStack(spacing: 0){
                        Spacer()
                        Text("\(field.numberRepetitions)")
                            .foregroundColor(indexStepper==0 ? .black:.gray )
                            .fontWeight(indexStepper==0 ? .semibold:.regular)
                        Text("  x  ")
                            .foregroundColor(.gray)
                        Text("\(field.typeWait == .repetition ? "\(field.lengthRepetition)":field.lengthRepetition.convertSecondsToMinutes())")
                            .foregroundColor(indexStepper==1 ? .black:.gray )
                            .fontWeight(indexStepper==1 ? .semibold:.regular)
                        if plus{
                            Text(" / ")
                                .foregroundColor(.gray)
                            Text("\(field.typeWait == .repetition ? "\(field.maxLengthRepetition)":field.maxLengthRepetition.convertSecondsToMinutes())")
                                .foregroundColor(indexStepper==2 ? .black:.gray)
                                .fontWeight(indexStepper==2 ? .semibold:.regular)
                        }
                        Text(" \(field.typeWait == .repetition ? "répétition\(field.lengthRepetition==1 ? "":"s")":"")")
                            .foregroundColor(.gray)
                        Spacer()
                    }.font(.title3)
                    
                }.padding(.horizontal,30)
                    .onChange(of: valueStepper){ new in
                        generator.notificationOccurred(.success)
                        saveValueStepper()
                    }
            }.presentationDetents([.fraction(0.1)])
                .onAppear{
                    valueSelect()
                }
        }.sheet(isPresented: $showSheetArchive){
            VStack (spacing:0){
                Text("Sélectionne un exercice")
                    .font(.body)
                    .bold()
                    .padding(.top,10)
                    .padding(.vertical,10)
                Divider()
                List{
                   
                    Section {
                        ForEach(mainData.mainBackup!.getArchive()[0].allPractice(),id:\.id) { archive in
                            Button(action:{
                                field.name=archive.name
                                field.numberRepetitions = Int(archive.numberRepetitions)
                                field.lengthRepetition = Int(archive.lengthRepetition)
                                field.maxLengthRepetition = Int(archive.maxLengthRepetition)
                                if field.maxLengthRepetition == 0{
                                    plus=false
                                }else{
                                    plus=true
                                }
                                field.typeWait = (archive.repetitionInsteadMinute ? .repetition:.time)
                                field.repos=Int(archive.repos)
                                field.lien=archive.lien ?? ""
                                showSheetArchive=false
                                impactLight()
                            }) {
                                VStack (alignment: .leading,spacing: 10){
                                    HStack {
                                        Text(archive.name.capitalizedSentence)
                                            .font(.headline)
                                    }
                                    HStack {
                                        Text(archive.convertRepetitionToStringWithWord())
                                            .font(.subheadline)
                                        Spacer(minLength: 0)
                                        Text(Int(archive.repos).convertSecondsToMinutes())
                                            .font(.footnote)
                                    }
                                }
                            }.foregroundColor(.black)
                            
                        }
                      
                    }
                    Button(action: {
                        showSheetArchive=false
                        impactLight()
                    }){
                        HStack {
                            Spacer()
                            Text("Annuler")
                                .fontWeight(.semibold)
                            Spacer()
                        }.foregroundColor(.red)
                    }
                }
            }
        }
    }
    
    func valueSelect(){
        if indexStepper==0{
            valueStepper=field.numberRepetitions
        }else if indexStepper==1{
            valueStepper=field.lengthRepetition
        }else{
            valueStepper=field.maxLengthRepetition
        }
    }
    func saveValueStepper(){
        if indexStepper==0{
            field.numberRepetitions=valueStepper
        }else if indexStepper==1{
            field.lengthRepetition=valueStepper
            if field.typeWait == .repetition{
                if  field.maxLengthRepetition<field.lengthRepetition+2{
                    field.maxLengthRepetition=field.lengthRepetition+2
                }
            }else{
                if  field.maxLengthRepetition<field.lengthRepetition+15{
                    field.maxLengthRepetition=field.lengthRepetition+15
                }
            }
        }else{
            field.maxLengthRepetition=valueStepper
        }
    }
    func save(){
        let practice=Practice(context: viewContext)
        practice.name=field.name
        practice.lengthRepetition=Int16(field.lengthRepetition)
        practice.maxLengthRepetition=(plus ? Int16(field.maxLengthRepetition):0)
        practice.numberRepetitions=Int16(field.numberRepetitions)
        practice.repetitionInsteadMinute=(field.typeWait == .repetition)
        practice.repos=Int16(field.repos)
        practice.lien=field.lien
        practice.id=UUID()
        practice.done=false
        practice.index=Int16(mainData.trainingDaySelect!.allPractice().count)
        mainData.trainingDaySelect!.addToPractice(practice)
        do {
            try viewContext.save()
            mainData.presentedSheet=false
            if timerState.timer != nil,let trainingDaySelect=mainData.trainingDaySelect{
                let int=timerState.timerState!.index
                timerState.timerState=(practices:trainingDaySelect.allPractice(),index:Int(int))
                timerState.idRefresh=UUID()
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        impactLight()
    }
}
struct AddPractice_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            AddPractice()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}

import SwiftUI
struct UpdatePractice: View {
    @StateObject var field=Field()
    @StateObject var mainData:MainData = .shared
    @Environment(\.managedObjectContext) private var viewContext
    let generator = UINotificationFeedbackGenerator()
    @State var showSheet:Bool=false
    @State var valueStepper=0
    @State var plus=false
    @State var indexStepper=0
    @State var practice:FetchedResults<Practice>.Element
    @State private var showAlert = false
    @StateObject var timerState:TimerState = .shared
    var body: some View {
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $field.name)
            }
            Section{
                VStack {
                    HStack{
                        Spacer()
                        HStack {
                            Text("Répétitions")
                                .padding(.horizontal,12)
                                .padding(.vertical,4)
                                .foregroundColor(field.typeWait == .repetition ? .blue.opacity(0.9):.gray)
                                .background(field.typeWait == .repetition ? Color.blue.opacity(0.18):Color.clear)
                                .fontWeight(.semibold)
                                .clipShape(RoundedCorner())
                                .onTapGesture {
                                    if field.typeWait != .repetition{
                                        impactLight()
                                        field.typeWait = .repetition
                                        field.lengthRepetition = 8
                                        if plus{
                                            field.maxLengthRepetition = 10
                                        }
                                    }
                                }
                            Text("Temps")
                                .padding(.horizontal,12)
                                .padding(.vertical,4).foregroundColor(field.typeWait != .repetition ? .blue.opacity(0.9):.gray)
                                .background(field.typeWait != .repetition ? Color.blue.opacity(0.18):Color.clear)
                                .fontWeight(.semibold)
                                .clipShape(RoundedCorner())
                                .onTapGesture {
                                    if field.typeWait != .time{
                                        impactLight()
                                        field.typeWait = .time
                                        field.lengthRepetition = 60
                                        if plus{
                                            field.maxLengthRepetition = 75
                                        }
                                    }
                                }
                        }.padding(.all,4)
                            .background(.white)
                            .clipShape(RoundedCorner())
                        
                        Spacer()
                    }.padding(.bottom,20)
                    HStack {
                        Text("\(field.numberRepetitions)")
                            .padding(.horizontal,14)
                            .padding(.vertical,6)
                            .background(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                showSheet=true
                                indexStepper=0
                                impactLight()
                            }
                        Text("x")
                            .frame(width: 15)
                            .padding(.vertical,6)
                        
                        
                        Text("\(field.typeWait == .repetition ? "\(field.lengthRepetition)":field.lengthRepetition.convertSecondsToMinutes())")
                            .padding(.horizontal,14)
                            .padding(.vertical,6)
                            .background(.white)
                            .cornerRadius(8)
                            .onTapGesture {
                                showSheet=true
                                indexStepper=1
                                impactLight()
                            }
                        if !plus{
                            HStack {
                                Text("à ")
                                    .offset(y:-1)
                                Image(systemName: "plus.circle")
                                
                            }.frame(width: 65)
                                .padding(.vertical,6)
                                .foregroundColor(.gray)
                                .background(.gray.opacity(0.1))
                                .cornerRadius(8)
                                .onTapGesture {
                                    plus=true
                                    if field.typeWait == .repetition{
                                        if  field.maxLengthRepetition<field.lengthRepetition+2{
                                            field.maxLengthRepetition=field.lengthRepetition+2
                                        }
                                    }else{
                                        if  field.maxLengthRepetition<field.lengthRepetition+15{
                                            field.maxLengthRepetition=field.lengthRepetition+15
                                        }
                                    }
                                    
                                    impactLight()
                                }
                        }else{
                            Text("/")
                                .frame(width: 15)
                                .padding(.vertical,6)
                            Text("\(field.typeWait == .repetition ? "\(field.maxLengthRepetition)":field.maxLengthRepetition.convertSecondsToMinutes())")
                                .padding(.horizontal,14)
                                .padding(.vertical,6)
                                .background(.white)
                                .cornerRadius(8)
                                .onTapGesture {
                                    showSheet=true
                                    indexStepper=2
                                    impactLight()
                                }
                            HStack {
                                Image(systemName: "minus.circle")
                            }.frame(width: 25)
                                .padding(.vertical,6)
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    plus=false
                                    impactLight()
                                }
                        }
                    }
                }
            }.listRowBackground(Color(.secondarySystemBackground))
            
            Section(header: Text("Repos")) {
                Stepper(value: $field.repos, in: 0...3*60, step: 15) {
                    Text(Int(field.repos).convertSecondsToMinutes())
                }
                
            }
            Section(header: Text("Lien")) {
                TextField("Lien", text: $field.lien)
                    .foregroundColor(.blue)
            }
            
            Section {
                Button(action: {
                    save()
                }){
                    HStack {
                        Spacer()
                        Text("Enregistrer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.blue)
                }
            }
            Section {
                Button(action: {
                    mainData.presentedSheet=false
                    impactLight()
                }){
                    HStack {
                        Spacer()
                        Text("Annuler")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.red)
                }
                
            }
            Section{
                Button(action: {
                    showAlert=true
                }){
                    HStack {
                        Spacer()
                        Image(systemName: "trash.fill")
                        Text("Supprimer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.red)
                }
            }
        }.onAppear{
            field.name=practice.name
            field.numberRepetitions = Int(practice.numberRepetitions)
            field.lengthRepetition = Int(practice.lengthRepetition)
            field.maxLengthRepetition = Int(practice.maxLengthRepetition)
            if field.maxLengthRepetition == 0{
                plus=false
            }else{
                plus=true
            }
            field.typeWait = (practice.repetitionInsteadMinute ? .repetition:.time)
            field.repos=Int(practice.repos)
            field.lien=practice.lien ?? ""
        }.sheet(isPresented: $showSheet){
            VStack{
                Stepper(value: $valueStepper, in: indexStepper==0 ? (1...50):(indexStepper==1 ? (field.typeWait == .repetition ? (1...200):(15...1800)):((field.lengthRepetition+(field.typeWait == .repetition ? 2:15))...(field.typeWait == .repetition ? 220:1815))), step: field.typeWait == .repetition ? 1:15) {
                    HStack(spacing: 0){
                        Spacer()
                        Text("\(field.numberRepetitions)")
                            .foregroundColor(indexStepper==0 ? .black:.gray )
                            .fontWeight(indexStepper==0 ? .semibold:.regular)
                        Text("  x  ")
                            .foregroundColor(.gray)
                        Text("\(field.typeWait == .repetition ? "\(field.lengthRepetition)":field.lengthRepetition.convertSecondsToMinutes())")
                            .foregroundColor(indexStepper==1 ? .black:.gray )
                            .fontWeight(indexStepper==1 ? .semibold:.regular)
                        if plus{
                            Text(" / ")
                                .foregroundColor(.gray)
                            Text("\(field.typeWait == .repetition ? "\(field.maxLengthRepetition)":field.maxLengthRepetition.convertSecondsToMinutes())")
                                .foregroundColor(indexStepper==2 ? .black:.gray)
                                .fontWeight(indexStepper==2 ? .semibold:.regular)
                        }
                        Text(" \(field.typeWait == .repetition ? "répétition\(field.lengthRepetition==1 ? "":"s")":"")")
                            .foregroundColor(.gray)
                        Spacer()
                    }.font(.title3)
                    
                }.padding(.horizontal,30)
                    .onChange(of: valueStepper){ new in
                        generator.notificationOccurred(.success)
                        saveValueStepper()
                    }
            }.presentationDetents([.fraction(0.1)])
                .onAppear{
                    valueSelect()
                }
        }.actionSheet(isPresented: $showAlert) {
            ActionSheet(
                title: Text("Êtes-vous sûre de vouloir supprimer cet exercice ?"),
                message: Text("Vous pouvez toujours archiver cet exercice"),
                buttons:[
                    .cancel(),
                    .destructive(Text("Supprimer l'exercice"), action: {
                        emptyTrashAction()
                    }),
                    .default(Text("Archiver l'exercice"), action: {
                        emptyTrashAndArchiveAction()
                    })
                ]
            )}
    }
    func emptyTrashAction() {
        mainData.trainingDaySelect!.removeFromPractice(practice)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        let array=mainData.trainingDaySelect!.allPractice()
        for (index,item) in Array(array.enumerated()){
            item.index=Int16(index)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        if timerState.timer != nil,let trainingDaySelect=mainData.trainingDaySelect, !trainingDaySelect.allPractice().isEmpty{
            var int=timerState.timerState!.index
            if int > trainingDaySelect.allPractice().count-1{
                int=trainingDaySelect.allPractice().count-1
            }
            timerState.timerState=(practices:trainingDaySelect.allPractice(),index:Int(int))
            timerState.idRefresh=UUID()
        }
        mainData.presentedSheet=false
        impactLight()
    }
    func emptyTrashAndArchiveAction() {
        mainData.mainBackup!.getArchive()[0].addToPractice(practice)
        mainData.trainingDaySelect!.removeFromPractice(practice)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        let array=mainData.trainingDaySelect!.allPractice()
        for (index,item) in Array(array.enumerated()){
            item.index=Int16(index)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        if timerState.timer != nil,let trainingDaySelect=mainData.trainingDaySelect, !trainingDaySelect.allPractice().isEmpty{
            var int=timerState.timerState!.index
            if int > trainingDaySelect.allPractice().count-1{
                int=trainingDaySelect.allPractice().count-1
            }
            timerState.timerState=(practices:trainingDaySelect.allPractice(),index:Int(int))
            timerState.idRefresh=UUID()
        }
        mainData.presentedSheet=false
        impactLight()
    }
    func valueSelect(){
        if indexStepper==0{
            valueStepper=field.numberRepetitions
        }else if indexStepper==1{
            valueStepper=field.lengthRepetition
        }else{
            valueStepper=field.maxLengthRepetition
        }
    }
    func saveValueStepper(){
        if indexStepper==0{
            field.numberRepetitions=valueStepper
        }else if indexStepper==1{
            field.lengthRepetition=valueStepper
            if field.typeWait == .repetition{
                if  field.maxLengthRepetition<field.lengthRepetition+2{
                    field.maxLengthRepetition=field.lengthRepetition+2
                }
            }else{
                if  field.maxLengthRepetition<field.lengthRepetition+15{
                    field.maxLengthRepetition=field.lengthRepetition+15
                }
            }
        }else{
            field.maxLengthRepetition=valueStepper
        }
    }
    func save(){
        practice.name=field.name
        practice.lengthRepetition=Int16(field.lengthRepetition)
        practice.maxLengthRepetition=(plus ? Int16(field.maxLengthRepetition):0)
        practice.numberRepetitions=Int16(field.numberRepetitions)
        practice.repetitionInsteadMinute=(field.typeWait == .repetition)
        practice.repos=Int16(field.repos)
        practice.lien=field.lien
        practice.id=UUID()
        practice.done=false
        practice.index=Int16(mainData.trainingDaySelect!.allPractice().count)
        mainData.trainingDaySelect!.addToPractice(practice)
        do {
            try viewContext.save()
            mainData.presentedSheet=false
            if timerState.timer != nil,let trainingDaySelect=mainData.trainingDaySelect{
                let int=timerState.timerState!.index
                timerState.timerState=(practices:trainingDaySelect.allPractice(),index:Int(int))
                timerState.idRefresh=UUID()
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        impactLight()
    }
}


struct UpdatePractice_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup),let practice=mainData.mainBackup?.allTrainingDay()[5].allPractice()[4]{
            UpdatePractice(practice: practice)
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}
