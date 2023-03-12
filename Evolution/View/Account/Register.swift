//
//  Register.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import SwiftUI

struct Register: View {
    @StateObject var launchScreenState :LaunchScreenStateManager = .shared
    @StateObject var mainData:MainData = .shared
    @Environment(\.managedObjectContext) private var viewContext
    @State var dataLoad=false
    @State var nextPageIsManyBackup=false
    @State var dateOfRegister=Date()
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ])var backup:FetchedResults<Backup>
    
    
    @State var dataPractice=DataPractice()
    var body: some View {
        VStack (spacing: 0){
            Spacer()
            Text("Programme tes journées")
            Spacer()
            if let alert=mainData.alertICloud(){
                HStack (spacing: 0){
                    Image(systemName: "exclamationmark.icloud")
                        .foregroundColor(.yellow)
                        .fontWeight(.semibold)
                    Divider()
                        .frame(height: 20)
                        .padding(.horizontal)
                    VStack {
                        Text(alert.0)
                            .font(.subheadline)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }.padding(.horizontal,15)
                    .frame(width: UIScreen.main.bounds.width-40)
                        .padding(.vertical,10)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(15)
                    .multilineTextAlignment(.center)
                Text(alert.1)
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,40)
                    .padding(.top,10)
            }
            Spacer()
            Button(action: {
                launchScreenState.creationTrainingDay()
                let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                impactHeavy.impactOccurred()
            }){
                Text("Je programme mes journées")
                    .padding(.vertical,10)
                    .padding(.horizontal,20)
                    .frame(width: 300)
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            Button(action: {
                launchScreenState.dismissWithoutTime()
                backup.first!.settings!.register=true
                let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                impactHeavy.impactOccurred()
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
                }
            }){
                Text("Je le fais plus tard")
                    .padding(.vertical,20)
                    .frame(width: 300)
                    .foregroundColor(.gray)
            }
        }
        .padding(.bottom,30).frame(width:UIScreen.main.bounds.width)
        .background(.white)
        .overlay{
            if dataLoad{
                ZStack {
                    Color.black.opacity(0.7)
                    VStack(spacing: 0){
                        Text("Tes données ont bien été récupéré")
                        
                        AnimatedCheckmarkView()
                            .padding(.vertical,15)
                    }.padding(.horizontal,20)
                        .padding(.top,25)
                        .background(.white)
                        .cornerRadius(25)
                }.transition(.opacity.animation(.default))
                .onTapGesture {
                    let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                    impactHeavy.impactOccurred()
                    launchScreenState.dismissWithoutTime()
                    if nextPageIsManyBackup{
                        mainData.manyBackup=true
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: backup.count){ new in
            if new > 1{
                if backup.last!.date == dateOfRegister && backupIsEmpty(backup.last!){
                    viewContext.delete(backup.last!)
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
                    }
                    dataLoad=true
                    if backup.count>1{
                        nextPageIsManyBackup=true
                    }
                }else{
                    dataLoad=true
                    nextPageIsManyBackup=true
                }
            }
        }.onAppear{
            if backup.count == 0{
                let backup=Backup(context: viewContext)
                
//                let isoDate = "2023-01-23"
//                let dateFormatter = DateFormatter()
//                dateFormatter.dateFormat = "yyyy-MM-dd"
//                let d=dateFormatter.date(from:isoDate)
//                dateOfRegister=d!
                backup.date=dateOfRegister
                
                let settings=Settings(context: viewContext)
                settings.firstDay=dateOfRegister
                settings.dayLastDeleteDone=dateOfRegister
                settings.homePointsGo = 3
                settings.homePointsNone = -4
                settings.clubPointsGo = 10
                settings.clubPointsNone = -6
                settings.register=false
                backup.settings=settings
                
                let trainingDay=TrainingDay(context: viewContext)
                trainingDay.id=UUID()
                trainingDay.active=false
                trainingDay.icone=""
                trainingDay.name="gibjug-8fizxo-byJvov-archive"
                backup.addToTrainingDay(trainingDay)
                
//                for (index,dayDefault) in dataPractice.trainingDay.enumerated(){
//                    let trainingDay=TrainingDay(context: viewContext)
//                    trainingDay.index=Int16(index)
//                    trainingDay.id=dayDefault.idType
//                    trainingDay.active=true
//                    trainingDay.icone=dayDefault.symbole
//                    trainingDay.name=dayDefault.name
//                    for (index,practice) in Array(dataPractice.dataPractice.filter({$0.idType==trainingDay.id}).enumerated()) {
//                        let newItem = Practice(context: viewContext)
//                        newItem.id=UUID()
//                        newItem.index=Int16(index)
//                        newItem.name=practice.name
//                        newItem.lien=practice.lien
//                        newItem.lengthRepetition=Int16(practice.lengthRepetition)
//                        newItem.maxLengthRepetition=Int16(practice.maxLengthRepetition)
//                        newItem.numberRepetitions=Int16(practice.numberRepetitions)
//                        newItem.repetitionInsteadMinute=practice.repetitionInsteadMinute
//                        newItem.repos=Int16(practice.repos)
//                        newItem.done=false
//                        newItem.active=true
//                        trainingDay.addToPractice(newItem)
//                    }
//                    backup.addToTrainingDay(trainingDay)
//                }
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
                }
            }else{
                dataLoad=true
            }
        }
    }
    func backupIsEmpty(_ backup:Backup)->Bool{
        return backup.allTrainingDay().count == 0 && backup.allActivity().count == 0
    }
}

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
