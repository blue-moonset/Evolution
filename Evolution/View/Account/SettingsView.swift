//  SettingsView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 28/11/2022.
//

import SwiftUI
import UIKit
import CoreData

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var showAlertData=false
    @State var showAlertPoints=false
    @State var sheetIsPoint:Bool=false
    @State var updatePractice:FetchedResults<Practice>.Element?
    @State var isWin=false
    @State var isHome=false
    let generator = UINotificationFeedbackGenerator()
    
    @State var valueStepper=0
    
    @StateObject var mainData:MainData = .shared
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.5)
            List{
                
                
                Section(header: Text("Utilisateur depuis le \(itemFormatter(mainData.mainBackup!.settings!.firstDay))")) {
                    Button(action: {
                        showAlertData=true
                    }){
                        Label("Supprimer toutes mes données", systemImage: "trash.fill")
                            .foregroundColor(.red)
                    }.confirmationDialog(
                        "Toutes tes données vont être effacés",
                        isPresented: $showAlertData,titleVisibility: .visible
                    ) {
                        Button("Tout supprimer", role: .destructive) {
                            generator.notificationOccurred(.success)
                            
                            deleteAll()
                        }
                        Button("Annuler", role: .cancel) {
                            showAlertData=false
                        }
                    }
                }
                Section(header: Text("Points à la maison")) {
                    HStack{
                        let s=plural(Int(mainData.mainBackup!.settings!.homePointsGo))
                        Label("\(mainData.mainBackup!.settings!.homePointsGo) point\(s) gagné\(s)", systemImage: "house.fill")
                        Spacer()
                        Button(action: {
                            isWin=true
                            isHome=true
                            sheetIsPoint=true
                        }){
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }.foregroundColor(.green)
                    HStack{
                        let s=plural(Int(mainData.mainBackup!.settings!.homePointsNone))
                        Label("\(mainData.mainBackup!.settings!.homePointsNone) point\(s) au score", systemImage: "house")
                        Spacer()
                        Button(action: {
                            isWin=false
                            isHome=true
                            sheetIsPoint=true
                        }){
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }.foregroundColor(.red)
                }
                
                Section(header: Text("Points à la salle")) {
                    HStack{
                        let s=plural(Int(mainData.mainBackup!.settings!.clubPointsGo))
                        Label("\(mainData.mainBackup!.settings!.clubPointsGo) point\(s) gagné\(s)", systemImage: "dumbbell.fill")
                        Spacer()
                        Button(action: {
                            isWin=true
                            isHome=false
                            sheetIsPoint=true
                        }){
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }.foregroundColor(.green)
                    HStack{
                        let s=plural(Int(mainData.mainBackup!.settings!.homePointsNone))
                        Label("\(mainData.mainBackup!.settings!.clubPointsNone) point\(s) au score", systemImage: "dumbbell")
                        Spacer()
                        Button(action: {
                            isWin=false
                            isHome=false
                            sheetIsPoint=true
                        }){
                            Image(systemName: "pencil")
                                .foregroundColor(.blue)
                        }
                    }.foregroundColor(.red)
                }
                Section{
                    Button(action: {
                        showAlertPoints=true
                    }){
                        HStack{
                            Spacer()
                            Image(systemName: "trash.fill")
                            Text("Réinitialiser les points")
                            Spacer()
                        }.foregroundColor(.red)
                    }.confirmationDialog(
                        "Les points vont être réinitialisés",
                        isPresented: $showAlertPoints,titleVisibility: .visible
                    ) {
                        Button("Réinitialiser", role: .destructive) {
                            let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)
                            impactHeavy.impactOccurred()
                            
                            
                            mainData.mainBackup!.settings!.firstDay=Date()
                            mainData.mainBackup!.settings!.dayLastDeleteDone=Date()
                            mainData.mainBackup!.settings!.homePointsGo = 3
                            mainData.mainBackup!.settings!.homePointsNone = -4
                            mainData.mainBackup!.settings!.clubPointsGo = 10
                            mainData.mainBackup!.settings!.clubPointsNone = -6
                            do {
                                try viewContext.save()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                        Button("Annuler", role: .cancel) {
                            showAlertData=false
                        }
                    }
                }
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
                        .background(Color(.white))
                        .cornerRadius(15)
                        .multilineTextAlignment(.center)
                        .listRowBackground(Color(.secondarySystemBackground))
                    Text(alert.1)
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal,40)
                        .listRowBackground(Color(.secondarySystemBackground))
                        .listRowSeparator(.hidden)
                }
            }
            
        }.navigationTitle("Paramètres")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $sheetIsPoint){
            VStack{
                Stepper(value: $valueStepper, in: isWin ? (0...20):(-20...0)) {
                    TextInUpdate()
                }.padding(.horizontal,30)
                .onChange(of: valueStepper){ new in
                    generator.notificationOccurred(.success)
                    saveValueStepper()
                }
            }.presentationDetents([.fraction(0.1)])
            .onAppear{
                valueSelect()
            }
        }
    }
    
    private func deleteAll() {
        for day in mainData.mainBackup!.allActivity(){
            viewContext.delete(day)
            mainData.mainBackup!.settings!.firstDay=Date()
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func valueSelect(){
        if isHome{
            if isWin{
                valueStepper=Int(mainData.mainBackup!.settings!.homePointsGo)
            }else{
                valueStepper=Int(mainData.mainBackup!.settings!.homePointsNone)
            }
        }else{
            if isWin{
                valueStepper=Int(mainData.mainBackup!.settings!.clubPointsGo)
            }else{
                valueStepper=Int(mainData.mainBackup!.settings!.clubPointsNone)
            }
        }
    }
    func saveValueStepper(){
        if isHome{
            if isWin{
                mainData.mainBackup!.settings!.homePointsGo=Int16(valueStepper)
            }else{
                mainData.mainBackup!.settings!.homePointsNone=Int16(valueStepper)
            }
        }else{
            if isWin{
                mainData.mainBackup!.settings!.clubPointsGo=Int16(valueStepper)
            }else{
                mainData.mainBackup!.settings!.clubPointsNone=Int16(valueStepper)
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    @ViewBuilder
    func TextInUpdate()->some View{
        if isHome{
            if isWin{
                HStack{
                    let s=plural(Int(mainData.mainBackup!.settings!.homePointsGo))
                    Image(systemName: "house.fill")
                    Text("\(mainData.mainBackup!.settings!.homePointsGo) point\(s) gagné\(s)")
                }.foregroundColor(.green)
            }else{
                HStack{
                    let s=plural(Int(mainData.mainBackup!.settings!.homePointsNone))
                    Image(systemName: "house")
                    Text("\(mainData.mainBackup!.settings!.homePointsNone) point\(s) au score")
                }.foregroundColor(.red)
            }
        }else{
            if isWin{
                HStack{
                   let s=plural(Int(mainData.mainBackup!.settings!.clubPointsGo))
                    Image(systemName: "dumbbell.fill")
                    Text("\(mainData.mainBackup!.settings!.clubPointsGo) point\(s) gagné\(s)")
                }.foregroundColor(.green)
            }else{
                HStack{
                    let s=plural(Int(mainData.mainBackup!.settings!.clubPointsNone))
                    Image(systemName: "dumbbell")
                    Text("\(mainData.mainBackup!.settings!.clubPointsNone) point\(s) au score")
                }.foregroundColor(.red)
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
            NavigationStack {
                SettingsView()
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            }
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}

