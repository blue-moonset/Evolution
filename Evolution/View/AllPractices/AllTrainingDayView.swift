//
//  TrainingDayView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 13/03/2023.
//

import SwiftUI
import CoreData
import Introspect

struct AllTrainingDayView: View {
    @StateObject private var mainData:MainData = .shared
    
    @State private var selectedCoordinateIndex:Int=0
    @State private var scrollView=UIScrollView()
    @State private var positionsInScrollView: [UUID:CGFloat] = [:]
    @State private var positionsIcon: [UUID:CGFloat] = [:]
    @State private var widthAllTrainingDay:CGFloat = .zero
    @State private var lock1=false
    @State private var lock2=false
    var settings:Bool
    var body: some View {
        if mainData.mainBackup!.allTrainingDay().count != 0{
            
            ScrollView (.horizontal,showsIndicators: false){
                VStack{
                    HStack (spacing: 4){
                        ForEach(mainData.mainBackup!.allTrainingDay(),id: \.id) { item in
                            TrainingDayView(trainingDay: item, positionsInScrollView: $positionsInScrollView,scrollView:$scrollView)
                        }
                        
                    }.padding(.all,5)
                        .background(GeometryGetWidth(whidth: $widthAllTrainingDay))
                }
                .background(.white)
                .clipShape(RoundedCorner())
                .frame(minWidth: UIScreen.main.bounds.width)
                .padding(.horizontal, widthAllTrainingDay > UIScreen.main.bounds.width-40 ? 20:0)
                .padding(.top,20)
            }.listRowInsets(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))
                .frame(width: UIScreen.main.bounds.width)
                .coordinateSpace(name: "scrollView")
                .introspectScrollView{ scrollView in
                    self.scrollView=scrollView
                }
                .listRowBackground(Color(.secondarySystemBackground))
                .listRowSeparator(.hidden, edges: .all)
                .overlay{
                    Group{
                        if widthAllTrainingDay > UIScreen.main.bounds.width-40{
                            AnyPosition()
                        }else{
                            Position()
                        }
                    }
                }.onAppear{
                    if !lock1{
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                            move()
                        }
                        lock1=true
                    }
                }.onChange(of: mainData.mainBackup?.allActivity().count){ new in
                    move()
                }.onChange(of: mainData.trainingDaySelect){ new in
                    move()
                }
        }else if !settings{
            Section{
                Button(action:{
                    mainData.presentedSheet = true
                    mainData.typeSheet = .addTrainingDay
                }) {
                    HStack {
                        Spacer()
                        Text("Enregistre une journée d'entraînement")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                }
            }.listRowBackground(Back(top: true, bottom: true))
                .listRowSeparator(.hidden, edges: .all)
        }
    }
    func move(){
        if let trainingDay=mainData.trainingDaySelect{
            if widthAllTrainingDay > UIScreen.main.bounds.width-40{
                scrollView.setContentOffset(CGPoint(x: Int(self.positionsInScrollView[trainingDay.id]!)-Int(positionsIcon[trainingDay.id]!)+20, y: 0), animated: true)
            }
        }
    }
    @ViewBuilder
    func AnyPosition()->some View{
        HStack (spacing: 4){
            Spacer(minLength: 0)
            ForEach(mainData.mainBackup!.allTrainingDay(),id: \.id) { item in
                Image(systemName: item.icone)
                    .frame(height: 20)
                    .background(GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                if !lock2{
                                    self.positionsIcon[item.id] = proxy.frame(in: .global).origin.x+(proxy.size.width/2)
                                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                                        lock2=true
                                    }
                                }
                            }
                    }).offset(y:-30)
                    .foregroundColor(mainData.trainingDaySelect==item ? .blue:.black)
                    .onTapGesture {
                        impactLight()
                        if mainData.trainingDaySelect==nil{
                            withAnimation(.default){
                                mainData.trainingDaySelect=item
                            }
                        }else{
                            mainData.trainingDaySelect=item
                        }
                    }
                Spacer(minLength: 0)
            }
        }.padding(.horizontal,20)
    }
    @ViewBuilder
    func Position()->some View{
        HStack (spacing: 4){
            ForEach(mainData.mainBackup!.allTrainingDay(),id: \.id) { item in
                ZStack{
                    Text(item.name.capitalizedSentence)
                        .padding(.horizontal,12)
                        .padding(.vertical,6)
                        .font(.body)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.secondarySystemBackground))
                    Image(systemName: item.icone)
                        .foregroundColor(mainData.trainingDaySelect==item ? .blue:.black)
                        .onTapGesture {
                            impactLight()
                            if mainData.trainingDaySelect==nil{
                                withAnimation(.default){
                                    mainData.trainingDaySelect=item
                                }
                            }else{
                                mainData.trainingDaySelect=item
                            }
                        }
                }.frame(height: 20)
                .offset(y:-30)
            }
        }
    }
}
struct TrainingDayView: View {
    
    @State var trainingDay:TrainingDay
    @StateObject var mainData:MainData = .shared
    @Binding var positionsInScrollView: [UUID:CGFloat]
    @Binding var scrollView:UIScrollView
    var body: some View {
        Text(trainingDay.name.capitalizedSentence)
            
            .background(GeometryReader { proxy in
                Color.clear
                    .onAppear {
                        if positionsInScrollView[trainingDay.id] == nil{
                            self.positionsInScrollView[trainingDay.id] = proxy.frame(in: .named("scrollView")).origin.x+(proxy.size.width/2)
                        }
                    }.onChange(of: mainData.mainBackup!.allTrainingDay().count){ new in
                        self.positionsInScrollView[trainingDay.id] = proxy.frame(in: .named("scrollView")).origin.x+(proxy.size.width/2)
                    }
            })
            .padding(.horizontal,12)
            .padding(.vertical,6)
            .font(.headline)
            .foregroundColor(mainData.trainingDaySelect==trainingDay ? .blue.opacity(0.9):.gray)
            .background(mainData.trainingDaySelect==trainingDay ? Color.blue.opacity(0.18):Color.clear)
            .clipShape(RoundedCorner())
            .onTapGesture {
                impactLight()
                if mainData.trainingDaySelect==nil{
                    withAnimation(.default){
                        mainData.trainingDaySelect=trainingDay
                    }
                }else{
                    mainData.trainingDaySelect=trainingDay
                }
            }.animation(.default, value: mainData.trainingDaySelect)
    }
}


struct AllTrainingDayView_Previews: PreviewProvider {
    static var mainData:MainData = .shared
    static let viewContext=PersistenceController.preview.container.viewContext
    
    static let fetchRequest: NSFetchRequest<Backup> = Backup.fetchRequest()
    static var previews: some View {
        if let backup = try? viewContext.fetch(fetchRequest).first, save(backup){
                List {
                    AllTrainingDayView(settings: false)
                }.environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
                    .listStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .background(Color(.secondarySystemBackground))
        }
    }
    static func save(_ backup:Backup)->Bool{
        mainData.mainBackup=backup
        return true
    }
}

