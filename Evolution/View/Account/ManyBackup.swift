//
//  ManyBackup.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 12/03/2023.
//

import SwiftUI

struct ManyBackup: View {
    @StateObject var launchScreenState :LaunchScreenStateManager = .shared
    @StateObject var mainData:MainData = .shared
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.date)
    ])var backup:FetchedResults<Backup>
    @Environment(\.managedObjectContext) private var viewContext
    @State private var showAlert = false
    var body: some View {
        if mainData.manyBackup{
            ScrollView {
                VStack {
                    Spacer()
                    Text("Choisi ta sauvegarde")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .padding(.bottom,30)
                        .padding(.top,10)
                    ForEach(backup,id: \.id) { backup in
                        VStack{
                            Text("Créé le \(itemFormatterWithYear(backup.date))")
                                .font(.body)
                                .bold()
                                .foregroundColor(.black)


                            ForEach(backup.allTrainingDay(),id:\.id) { trainingDay in

                                DisclosureGroup(
                                    content: {
                                        ForEach(trainingDay.allPractice(),id:\.id) { practice in
                                            HStack {
                                                Text(practice.name)
                                                    .font(.callout)
                                                    .fontWeight(.light)
                                                Spacer()
                                                Text(practice.convertRepetitionToString())
                                                    .font(.footnote)
                                            }.padding(.top,0.5)
                                                .padding(.leading,10)
                                                .lineLimit(1)
                                        }
                                    },
                                    label: {
                                        HStack {
                                            Text(trainingDay.name)
                                                .font(.body)
                                                .bold()
                                                .foregroundColor(.black)
                                            Image(systemName: trainingDay.icone)
                                                .font(.callout)
                                                .frame(width:25)
                                        }
                                    }
                                )
                            }
                            Divider()
                                .padding(.vertical,5)
                            HStack {
                                Spacer()
                                Text("\(backup.allActivity().count) journée"+plural(backup.allActivity().count)+" enregistré"+plural(backup.allActivity().count))
                                    .font(.body)
                                    .bold()
                                    .foregroundColor(.black)
                                Spacer()
                            }
                        }.padding(.horizontal,20)
                            .padding(.vertical,20)
                            .background(.white)
                            .cornerRadius(20)
                            .padding(.horizontal,30)

                        Button(action: {
                            showAlert = true
                        }){
                            HStack {
                                Spacer()
                                Text("Je choisis cette sauvegarde")
                                Spacer()
                            } .padding(.vertical,10)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .padding(.horizontal,30)
                        }.padding(.top,10)
                            .actionSheet(isPresented: $showAlert) {
                                ActionSheet(
                                    title: Text("Êtes-vous sûre de vouloir choisir la sauvegarde du \(itemFormatterWithYear(backup.date))"),
                                    message: Text("Cette action entraînera la suppression de toutes les autres sauvegardes"),
                                    buttons:[
                                        .cancel(),
                                        .destructive(Text("Confirmer"), action: {
                                            emptyTrashAction(backupSelect: backup)
                                            })
                                    ]
                                )}
                    }
                    Spacer()
                }
            }.frame(width: UIScreen.main.bounds.width)
                .background(Color(.secondarySystemBackground))
        }
    }
    func emptyTrashAction(backupSelect:Backup) {
        for b in backup{
            if b != backupSelect{
                viewContext.delete(b)
            }
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError.localizedDescription),\(String(describing: nsError.localizedFailureReason)), \(nsError.userInfo)")
        }
    }
}
struct ManyBackup_Previews: PreviewProvider {
    static var mainData:MainData{
        let mainData=MainData()
        mainData.manyBackup=true
        return mainData
    }
    static var previews: some View {
        ManyBackup(mainData:mainData)
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
