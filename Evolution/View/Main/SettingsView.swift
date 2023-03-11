//  SettingsView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 28/11/2022.
//

import SwiftUI
import UIKit

struct SettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.dateOfDay, ascending: false)],
        animation: .default)
    private var days: FetchedResults<Day>
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @State var showAlertData=false
    @State var showAlertPoints=false
    @State var sheetIsPoint:Bool=false
    @State var updateSportPractice:FetchedResults<SportPractice>.Element?
    @State var isWin=false
    @State var isHome=false
    let generator = UINotificationFeedbackGenerator()
    
    @State var valueStepper=0
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.5)
            List{
                
                
                Section(header: Text("Utilisateur depuis le \(itemFormatter(settings.first!.firstDay!))")) {
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
                        let s=plural(Int(settings.first!.homePointsGo))
                        Label("\(settings.first!.homePointsGo) point\(s) gagné\(s)", systemImage: "house.fill")
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
                        let s=plural(Int(settings.first!.homePointsNone))
                        Label("\(settings.first!.homePointsNone) point\(s) au score", systemImage: "house")
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
                        let s=plural(Int(settings.first!.clubPointsGo))
                        Label("\(settings.first!.clubPointsGo) point\(s) gagné\(s)", systemImage: "dumbbell.fill")
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
                        let s=plural(Int(settings.first!.homePointsNone))
                        Label("\(settings.first!.clubPointsNone) point\(s) au score", systemImage: "dumbbell")
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
                            
                            
                            settings.first!.firstDay=Date()
                            settings.first!.dayLastDeleteDone=Date()
                            settings.first!.homePointsGo = 3
                            settings.first!.homePointsNone = -4
                            settings.first!.clubPointsGo = 10
                            settings.first!.clubPointsNone = -6
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
        for day in days{
            viewContext.delete(day)
            settings.first!.firstDay=Date()
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
                valueStepper=Int(settings.first!.homePointsGo)
            }else{
                valueStepper=Int(settings.first!.homePointsNone)
            }
        }else{
            if isWin{
                valueStepper=Int(settings.first!.clubPointsGo)
            }else{
                valueStepper=Int(settings.first!.clubPointsNone)
            }
        }
    }
    func saveValueStepper(){
        if isHome{
            if isWin{
                settings.first!.homePointsGo=Int16(valueStepper)
            }else{
                settings.first!.homePointsNone=Int16(valueStepper)
            }
        }else{
            if isWin{
                settings.first!.clubPointsGo=Int16(valueStepper)
            }else{
                settings.first!.clubPointsNone=Int16(valueStepper)
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func TextInUpdate()->some View{
        if isHome{
            if isWin{
                return HStack{
                    let s=plural(Int(settings.first!.homePointsGo))
                    Image(systemName: "house.fill")
                    Text("\(settings.first!.homePointsGo) point\(s) gagné\(s)")
                }.foregroundColor(.green)
            }else{
                return HStack{
                    let s=plural(Int(settings.first!.homePointsNone))
                    Image(systemName: "house")
                    Text("\(settings.first!.homePointsNone) point\(s) au score")
                }.foregroundColor(.red)
            }
        }else{
            if isWin{
               return HStack{
                   let s=plural(Int(settings.first!.clubPointsGo))
                    Image(systemName: "dumbbell.fill")
                    Text("\(settings.first!.clubPointsGo) point\(s) gagné\(s)")
                }.foregroundColor(.green)
            }else{
                return HStack{
                    let s=plural(Int(settings.first!.clubPointsNone))
                    Image(systemName: "dumbbell")
                    Text("\(settings.first!.clubPointsNone) point\(s) au score")
                }.foregroundColor(.red)
            }
        }
    }
    func plural(_ val:Int)->String {
        if val>1 || val<(-1){
            return "s"
        }else{
            return ""
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}
