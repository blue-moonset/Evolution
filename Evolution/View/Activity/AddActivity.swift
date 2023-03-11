//
//  AddActivity.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 27/11/2022.
//

import SwiftUI

struct AddActivity: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [
    ])var settings:FetchedResults<Settings>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Day.dateOfDay, ascending: false)],
        animation: .default)
    private var days: FetchedResults<Day>
    @Binding var dateSelect:Date
    @State var  home:Bool?
    @State var club:Bool?
    @State var abdo:Bool=false
    @State var pompe:Bool=false
    @Binding var indexValue:Int?
    @State var showingAlertDate = false
    @State var showingAlertItem = false
    @State var clubRepos=false
    let generator = UINotificationFeedbackGenerator()
    @State var allTypeDay:[TypeDay]=[]
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.index)
    ])var typeDay:FetchedResults<TypeDay>
    @StateObject var timerState:TimerState = .shared
    var body: some View {
        VStack{
            ZStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                        indexValue=nil
                        let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
                        impactHeavy.impactOccurred()
                    }){
                        Image(systemName: "xmark.circle")
                            .foregroundColor(.red)
                            .font(.title3)
                            .padding(.trailing)
                    }
                }
                Text(indexValue==nil ? "Ajoute ton activité":"Mets à jour tes activités")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            if indexValue==nil {
                DatePicker(selection: $dateSelect, in: settings.first!.firstDay!...Date(),displayedComponents: .date,label: { Text(dayIsSave(date: dateSelect, results: days) ? "La journée est déjà enregistré":"Quelle est la journée ?")
                        .font(.callout)
                        .foregroundColor(dayIsSave(date: dateSelect, results: days) ? .red : (colorScheme == .dark ? Color.white : Color.black))
                        .fontWeight(dayIsSave(date: dateSelect, results: days) ? .semibold : .medium)
                })
                    .environment(\.locale, Locale(identifier: "fr"))
                    .datePickerStyle(.compact)
                    .accentColor(dayIsSave(date: dateSelect, results: days) ? .red : .blue)
                    .padding(.all)
                    .padding(.top,20)
                    .onChange(of: dateSelect){ new in
                        if dayIsSave(date: dateSelect, results: days){
                            generator.notificationOccurred(.error)
                        }
                    }
                    
            }else{
                Text(itemFormatter(days[indexValue!].dateOfDay))
                    .padding(.vertical,20)
            }
           
            VStack {
                HStack (spacing: 15){
                    Image(systemName: "moon.zzz.fill")
                    Text("Jour de repos")
                }.frame(height:50)
                    .foregroundColor((clubRepos ? Color.green: Color.red).opacity(0.9))
                .font(.body)
                .padding(.horizontal,20)
                .background((clubRepos ? Color.green: Color.red).opacity(0.18))
                .clipShape(RoundedCorner())
                .onTapGesture {
                    if clubRepos{
                        clubRepos=false
                    }else{
                        clubRepos=true
                        club=false
                    }
                }.padding(.bottom,10)
                HStack (spacing: 20){
                    HStack (spacing: 15){
                        Image(systemName: "dumbbell.fill")
                        Text("À la salle")
                    }.frame(minWidth: 100,maxWidth: 200)
                        .frame(height: 50)
                        .foregroundColor(color(state:club).opacity(0.9))
                        .background(color(state:club).opacity(0.18))
                        .clipShape(RoundedCorner())
                        .onTapGesture {
                            if club == nil{
                                club=true
                            }else{
                                club?.toggle()
                            }
                            if club!{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }else{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                impactHeavy.impactOccurred()
                            }
                        }
                    HStack (spacing: 15){
                        Image(systemName: "house.fill")
                        Text("À la maison")
                    }.frame(minWidth: 100,maxWidth: 200)
                        .frame(height: 50)
                        .foregroundColor(color(state: home).opacity(0.9))
                        .background(color(state: home).opacity(0.18))
                        .clipShape(RoundedCorner())
                        .onTapGesture {
                            if home == nil{
                                home=true
                            }else{
                                home?.toggle()
                            }
                            if home!{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                impactHeavy.impactOccurred()
                            }else{
                                let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                impactHeavy.impactOccurred()
                            }
                        }
                } .padding(.horizontal)
                .onChange(of: home){ new in
                    pompe=false
                    abdo=false
                }.onChange(of: club){ new in
                    if new==false{
                        allTypeDay.removeAll()
                    }
                }
            }
            if home == true{
                VStack (spacing: 0){
                    Divider()
                        .padding(.top)
                    HStack {
                        Text("À la maison")
                            .font(.headline)
                        Spacer()
                    }.padding(.horizontal)
                        .padding(.top)
                        .padding(.bottom,10)
                    HStack (spacing: 0){
                        Spacer(minLength: 50)
                        VStack (spacing: 5){
                            Image(systemName: "figure.core.training")
                                .font(.callout)
                            Text("Abdo")
                                .font(.caption)
                        }.padding(.all,2)
                            .foregroundColor(pompe==true ? .white:.red)
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            .background(pompe==true ? .blue:.gray.opacity(0.18))
                            .clipShape(Circle())
                            .onTapGesture {
                                pompe.toggle()
                                if pompe{
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                    impactHeavy.impactOccurred()
                                }else{
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                    impactHeavy.impactOccurred()
                                }
                            }
                        Spacer(minLength: 0)
                        VStack (spacing: 5){
                            Image("pompe")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 9)
                            Text("Pompe")
                                .font(.caption)
                        }.padding(.all,2)
                            .foregroundColor(abdo==true ? .white:.red)
                            .frame(maxWidth: .infinity,maxHeight: .infinity)
                            .background(abdo==true ? .blue:.gray.opacity(0.18))
                            .clipShape(Circle())
                            .onTapGesture {
                                abdo.toggle()
                                if abdo{
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                                    impactHeavy.impactOccurred()
                                }else{
                                    let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                                    impactHeavy.impactOccurred()
                                }
                            }
                        Spacer(minLength: 50)
                    }.frame(height: 60)
                }
            }
            AddPractice()
            HStack (spacing:20){
                Button(action: {
                    if home==false{
                        abdo=false
                        pompe=false
                    }
                    if dayIsSave(date: dateSelect, results: days) && indexValue == nil{
                        showingAlertDate = true
                        generator.notificationOccurred(.error)
                    }else{
                        if club != nil && home != nil{
                            if indexValue==nil{
                                addItem()
                            }else{
                                updateItem()
                            }
                        }else{
                            showingAlertItem = true
                            generator.notificationOccurred(.error)
                        }
                    }
                }){
                    Text("Enregister")
                    .frame(width: 100,height: 40)
                    .foregroundColor(.blue)
                    .background(Color.blue.opacity(0.18))
                    .cornerRadius(12)
                    .padding(.top,20)
                }.alert("Les informations sur:"+textAlert()
                        , isPresented: $showingAlertItem) {
                    Button("OK", role: .cancel) { }
                }.alert("La date est déjà enregistré"
                        , isPresented: $showingAlertDate) {
                    Button("OK", role: .cancel) { }
                }
//                Button(action: {
//                    viewContext.delete(days[indexValue!])
//                    do {
//                        try viewContext.save()
//                        dismiss()
//                        indexValue=nil
//                    } catch {
//                        let nsError = error as NSError
//                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//                    }
//                }){
//                    Text("Supprimer")
//                    .frame(width: 100,height: 40)
//                    .foregroundColor(.red)
//                    .background(Color.red.opacity(0.18))
//                    .cornerRadius(12)
//                    .padding(.top,20)
//                }
            }
           
            Spacer()
        }.onAppear{
            if indexValue != nil{
                home=days[indexValue!].home
                club=days[indexValue!].club
                abdo=days[indexValue!].typeHome.abdo
                pompe=days[indexValue!].typeHome.pompe
                clubRepos=days[indexValue!].clubRepos
                for day in days[indexValue!].idTypeDay{
                    if let typeDay=typeDay.first(where: {$0.id == day}){
                        allTypeDay.append(typeDay)
                    }
                }
                if timerState.typeDaySelect != nil{
                    allTypeDay.append(timerState.typeDaySelect!)
                    club=true
                }
            }
        }.onDisappear{
            indexValue=nil
            let impactHeavy = UIImpactFeedbackGenerator(style: .medium)
            impactHeavy.impactOccurred()
        }
    }
    @ViewBuilder
    func AddPractice()-> some View{
        if club == true{
            VStack (spacing: 0){
                Divider()
                    .padding(.top)
                HStack {
                    Text("À la salle")
                        .font(.headline)
                    Spacer()
                }.padding(.horizontal)
                    .padding(.top)
                    .padding(.bottom,10)
                HStack (spacing: 10){
                    ForEach(typeDay, id: \.self) { item in
                        Item(item)
                    }
                }.frame(height: 60)
                .padding(.horizontal)
                .padding(.vertical,10)
            }
        }
    }
    @ViewBuilder
    func Item(_ typeDay:TypeDay)->some View{
        VStack (spacing: 4){
            Image(systemName: typeDay.icone)
                .font(.callout)
            Text(typeDay.name.capitalizedSentence)
                .font(.caption)
        }.padding(.all,2)
            .foregroundColor(allTypeDay.contains(where:{$0==typeDay}) ? .white:.red)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(allTypeDay.contains(where:{$0==typeDay}) ? .blue:.black.opacity(0.05))
        .clipShape(Circle())
        .onTapGesture {
            impactLight()
            if allTypeDay.contains(where:{$0==typeDay}){
                let impactHeavy = UIImpactFeedbackGenerator(style: .rigid)
                    impactHeavy.impactOccurred()
                allTypeDay.remove(at: allTypeDay.firstIndex(where:{$0==typeDay})!)
            }else{
                let impactHeavy = UIImpactFeedbackGenerator(style: .soft)
                    impactHeavy.impactOccurred()
                allTypeDay.append(typeDay)
            }
        }
    }
    func textAlert() -> String {
        var resultText=""
        if club == nil{
            resultText += "\nÀ la salle"
        }
        if home == nil{
            resultText += "\nÀ la maison"
        }
        return resultText
    }
    func color(state:Bool?) -> Color {
        if state == nil{
            return .blue
        }else if !state!{
            return .red
        }else{
            return .green
        }
    }
    private func addItem() {
        let newItem = Day(context: viewContext)
        newItem.dateOfDay = dateSelect
        newItem.club = club!
        newItem.home = home!
        newItem.clubRepos=clubRepos
        let new=TypeHome(context: viewContext)
        new.abdo=abdo
        new.pompe=pompe
        newItem.typeHome=new
        newItem.idTypeDay=[]
        for day in allTypeDay {
            newItem.idTypeDay.append(day.id)
        }
        do {
            try viewContext.save()
            generator.notificationOccurred(.success)
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    private func updateItem() {
        let updateItem = days[indexValue!]
        updateItem.club = club!
        updateItem.home = home!
        updateItem.clubRepos=clubRepos
        let new=TypeHome(context: viewContext)
        new.abdo=abdo
        new.pompe=pompe
        updateItem.typeHome=new
        updateItem.idTypeDay=[]
        for day in allTypeDay {
            updateItem.idTypeDay.append(day.id)
        }
        do {
            try viewContext.save()
            generator.notificationOccurred(.success)
            dismiss()
            indexValue=nil
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    func isSelect(_ item:TypeDay)->Bool{
        return allTypeDay.contains{($0 == item)}
    }
}

struct AddActivity_Previews: PreviewProvider {
    static var previews: some View {
        AddActivity(dateSelect:.constant(Date()), indexValue: .constant(1))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            
    }
}
