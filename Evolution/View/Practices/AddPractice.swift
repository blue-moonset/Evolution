//
//  AddPractice.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 05/02/2023.
//

import SwiftUI

enum TypeSheet {
    case updatePractice,addPractice,addTypeDay,updateTypeDay,orderTypeDay
    
}
struct AddPractice: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var sheetIsPoint:(show:Bool,type:TypeSheet)=(show:false,type:.addPractice)
    
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.index)
    ])var typeDay:FetchedResults<TypeDay>
    @StateObject var timerState:TimerState = .shared
    @State var lastTypeDaySelect:TypeDay?
    @State var name:String=""
    @State var sFSelect:String?
    @State var repetition:String=""
    @State var repos:Int=0
    @State var lien:String=""
    @State var updateSportPractice:SportPractice?
    @State var textAdd:String="répétitions"
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 0.5)
            List{
                Section (header:Text("Modifier mes journées")){
                    Button(action: {
                        sheetIsPoint=(show:true,type: .addTypeDay)
                    }){
                        HStack {
                            Spacer()
                            Image(systemName: "plus.circle")
                            Text("Ajouter une journée")
                            Spacer()
                        }
                    }
                }.frame(width: UIScreen.main.bounds.width-40)
                
                if typeDay.count != 0{
                    if typeDay.count >= 2{
                        Section {
                            Button(action: {
                                sheetIsPoint=(show:true,type: .orderTypeDay)
                            }){
                                HStack {
                                    Spacer()
                                    Image(systemName: "list.triangle")
                                    Text("Modifier l'ordre des journées")
                                    Spacer()
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width-40)
                    }
                    Section {
                        Button(action: {
                            sheetIsPoint=(show:true,type: .updateTypeDay)
                        }){
                            HStack {
                                Spacer()
                                Image(systemName: "square.and.pencil")
                                Text("Modifier la journée")
                                Spacer()
                            }
                        }
                        
                    }.frame(width: UIScreen.main.bounds.width-40)
                    
                    Section (header:Text("Modifier mes exercies")){
                        HStack {
                            ForEach(Array(typeDay.enumerated()), id: \.offset) { index,item in
                                Item(item)
                                if index != typeDay.count-1{
                                    Spacer(minLength: 0)
                                }
                            }
                        }.frame(width: UIScreen.main.bounds.width-40)
                    }.frame(width: UIScreen.main.bounds.width-40)
                        .listRowBackground(Color(.secondarySystemBackground))
                    
                    if let typeDay=timerState.typeDaySelect{
                        Section{
                            Button(action: {
                                sheetIsPoint=(show:true,type: .addPractice)
                            }){
                                HStack {
                                    Spacer()
                                    Image(systemName: "plus.circle")
                                    Text("Ajouter un exercice")
                                    Spacer()
                                }
                            }
                        }
                        
                        if typeDay.allSportPractice().count == 0{
                            Section (typeDay.name){
                                HStack {
                                   Text("Ajoute des exercices à ta journée")
                                        .foregroundColor(.gray)
                                }.frame(width: UIScreen.main.bounds.width-40)
                            }.listRowBackground(Color(.secondarySystemBackground))
                        }else{
                            Section(typeDay.name){
                                ForEach(Array(typeDay.allSportPractice().enumerated()),id:\.offset){ index,item in
                                    Practice(item,index)
                                }.onMove { from, to in
                                    changeIndexForPractice(type:typeDay,fromOffsets: from,toOffset: to)
                                }
                            }
                        }
                        
                    }
                }
            }
        }.navigationTitle("Changer mon programme")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $sheetIsPoint.show){
                VStack {
                    Text((sheetIsPoint.type == .addTypeDay || sheetIsPoint.type == .orderTypeDay) ? "Ajouter une journée":timerState.typeDaySelect!.name.capitalizedSentence)
                        .fontWeight(.semibold)
                        .padding(.top,10)
                        .padding(.vertical,5)
                    if sheetIsPoint.type == .updatePractice{
                        UpdatePractice(updateSportPractice!)
                    }else if sheetIsPoint.type == .addPractice{
                        AddPractice()
                    }else if sheetIsPoint.type == .addTypeDay{
                        AddTypeDay()
                    }else if sheetIsPoint.type == .updateTypeDay{
                        UpdateTypeDay()
                    }else if sheetIsPoint.type == .orderTypeDay{
                        OrderTypeDay(typeDayForOrder: Array(typeDay), sheetIsPoint: $sheetIsPoint)
                    }
                }
                
            }.onChange(of: updateSportPractice){ new in
                //            bug si j'enleve
            }.onChange(of: sheetIsPoint.type){ new in
                //            bug si j'enleve
            }.onChange(of: typeDay.count){ new in
                if timerState.typeDaySelect == nil{
                    timerState.typeDaySelect=typeDay.last
                }
            }.onAppear{
                lastTypeDaySelect=timerState.typeDaySelect
                if timerState.typeDaySelect==nil, let first=typeDay.sorted(by: {$0.index < $1.index}).first{
                    timerState.typeDaySelect=first
                }
            }.onDisappear{
                timerState.typeDaySelect=lastTypeDaySelect
            }
    }
    func changeIndexForPractice(type:TypeDay, fromOffsets: IndexSet,toOffset: Int) {
        var array=type.allSportPractice()
        array.move(fromOffsets: fromOffsets, toOffset: toOffset)
        for (index,item) in Array(array.enumerated()){
            item.index=Int16(index)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func changeIndexForTypeDay(type:TypeDay, fromOffsets: IndexSet,toOffset: Int) {
        var array=Array(typeDay)
        array.move(fromOffsets: fromOffsets, toOffset: toOffset)
        for (index,item) in Array(array.enumerated()){
            item.index=Int16(index)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    func convertSecondsToMinutes(_ seconds: Int) -> String {
        if seconds == 0{
            return ""
        }else if seconds >= 60{
            var result="\(seconds/60) min"
            let remainingSeconds = seconds % 60
            if remainingSeconds != 0 {
                result=result+" \(remainingSeconds)"
            }
            return result
        }else{
            return "\(seconds) sec"
        }
    }
}

extension AddPractice{
    @ViewBuilder
    func AddTypeDay()->some View{
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $name)
            }
            Section{
                SF(sFSelect:$sFSelect)
            }.frame(width: UIScreen.main.bounds.width)
                .listRowBackground(Color(.secondarySystemBackground))
            Section {
                Button(action: {
                    sheetIsPoint.show=false
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
            Section {
                Button(action: {
                    let typeDay=TypeDay(context: viewContext)
                    typeDay.name=name
                    typeDay.icone=sFSelect ?? ""
                    typeDay.index=Int16(self.typeDay.count)
                    typeDay.active=true
                    typeDay.id=UUID()
                    do {
                        try viewContext.save()
                        sheetIsPoint.show=false
                        impactLight()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                }){
                    HStack {
                        Spacer()
                        Text("Enregistrer")
                            .fontWeight(.semibold)
                        Spacer()
                    }.foregroundColor(.blue)
                }
            }
        }.onAppear{
            name=""
            sFSelect=nil
        }
    }
    @ViewBuilder
    func UpdateTypeDay()->some View{
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $name)
            }
            Section {
                SF(sFSelect:$sFSelect)
            }.frame(width: UIScreen.main.bounds.width)
                .listRowBackground(Color(.secondarySystemBackground))
            
            Section {
                Button(action: {
                    
                    timerState.typeDaySelect!.name=name
                    timerState.typeDaySelect!.icone=sFSelect ?? ""
                    do {
                        try viewContext.save()
                        sheetIsPoint.show=false
                        impactLight()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
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
                    sheetIsPoint.show=false
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
                    viewContext.delete(timerState.typeDaySelect!)
                    
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    
                    for (index,item) in typeDay.enumerated(){
                        item.index=Int16(index)
                    }
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    sheetIsPoint.show=false
                    impactLight()
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
            name=timerState.typeDaySelect!.name.capitalizedSentence
            sFSelect=timerState.typeDaySelect!.icone
        }
    }
    @ViewBuilder
    func Item(_ type:TypeDay)->some View{
        VStack (spacing: 4){
            Image(systemName: type.icone)
                .font(.callout)
                .frame(height: 20)
            Text(type.name.capitalizedSentence)
                .font(.caption)
        }.padding(.all,2)
            .foregroundColor(self.timerState.typeDaySelect==type ? .white:.black)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(self.timerState.typeDaySelect==type ? .blue:.black.opacity(0.05))
            .clipShape(Circle())
            .onTapGesture {
                impactLight()
                self.timerState.typeDaySelect=type
            }
    }
    @ViewBuilder
    func Practice(_ practice:SportPractice,_ index:Int)->some View{
        Button(action: {
            impactLight()
            updateSportPractice=practice
            sheetIsPoint=(show:true,type: .updatePractice)
        }){
            VStack (alignment: .leading,spacing: 10){
                Text(practice.title.capitalizedSentence)
                    .font(.headline)
                HStack {
                    Text(practice.repetitions ?? "")
                        .font(.subheadline)
                    Spacer(minLength: 0)
                    Text(convertSecondsToMinutes(Int(practice.repos)))
                        .font(.footnote)
                }
            }.foregroundColor(.black)
        }
        
    }
    
    @ViewBuilder
    func UpdatePractice(_ practice:FetchedResults<SportPractice>.Element?)->some View{
        Form{
            Section(header: Text("Nom")) {
                TextField("", text: $name)
                    .placeholder(practice!.title.capitalizedSentence, when: name.isEmpty, color: .black)
            }
            Section(header: Text("Répétitions")) {
                TextField("", text: $repetition)
                    .placeholder(practice!.repetitions ?? "", when: repetition.isEmpty, color: .black)
            }
            Section(header: Text("Repos")) {
                Stepper(value: $repos, in: 0...3*60, step: 10) {
                    Text(convertSecondsToMinutes(Int(repos)))
                }
                
            }
            Section(header: Text("Lien")) {
                TextField("", text: $lien)
                    .placeholder(practice!.lien ?? "", when: lien.isEmpty, color: .black)
            }
            Section {
                Button(action: {
                    sheetIsPoint.show=false
                    practice!.title=name
                    practice!.repetitions=repetition
                    practice!.repos=Int16(repos)
                    practice!.lien=lien
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    impactLight()
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
                    sheetIsPoint.show=false
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
                    viewContext.delete(practice!)
                    
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    let array=timerState.typeDaySelect!.allSportPractice()
                    for (index,item) in Array(array.enumerated()){
                        item.index=Int16(index)
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    sheetIsPoint.show=false
                    impactLight()
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
            name=practice!.title.capitalizedSentence
            repetition=practice!.repetitions ?? ""
            repos=Int(practice!.repos)
            lien=practice!.lien ?? ""
        }
    }
    @ViewBuilder
    func AddPractice()->some View{
        Form{
            Section(header: Text("Nom")) {
                TextField("Nom", text: $name)
            }
            Section(header: Text("Répétitions")) {
                HStack {
                    TextField("Répétitions", text: $repetition)
                    Text("répétitions")
                        .padding(.all,5)
                        .font(.callout)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedCorner())
                        .overlay{
                            Group {
                                if textAdd == "répétitions"{
                                    RoundedCorner()
                                        .stroke(.blue,style: StrokeStyle(lineWidth: 2))
                                }
                            }
                        }
                        .onTapGesture {
                            textAdd="répétitions"
                        }
                    Text("min")
                        .padding(.all,5)
                        .font(.callout)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedCorner())
                        .overlay{
                            Group {
                                if textAdd == "min"{
                                    RoundedCorner()
                                        .stroke(.blue,style: StrokeStyle(lineWidth: 2))
                                }
                            }
                        }
                        .onTapGesture {
                            textAdd="min"
                        }
                }
            }
            Section(header: Text("Repos")) {
                Stepper(value: $repos, in: 0...3*60, step: 10) {
                    Text(convertSecondsToMinutes(Int(repos)))
                }
                
            }
            Section(header: Text("Lien")) {
                TextField("Lien", text: $lien)
                
            }
            
            Section {
                Button(action: {
                    sheetIsPoint.show=false
                    let practice=SportPractice(context: viewContext)
                    practice.title=name
                    practice.repetitions=repetition+" "+textAdd
                    practice.repos=Int16(repos)
                    practice.lien=lien
                    practice.id=UUID()
                    practice.done=false
                    practice.index=Int16(timerState.typeDaySelect!.allSportPractice().count)
                    timerState.typeDaySelect!.addToSportPractice(practice)
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    impactLight()
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
                    sheetIsPoint.show=false
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
            name=""
            repetition="4 x 8/10"
            repos=60
            lien=""
        }
    }
}
struct AddPractice_Previews: PreviewProvider {
    static var previews: some View {
        AddPractice()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: .leading) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}
extension View {
    func placeholder(
        _ text: String,
        when shouldShow: Bool,color:Color) -> some View {
            
            placeholder(when: shouldShow) { Text(text).foregroundColor(color) }
        }
}

