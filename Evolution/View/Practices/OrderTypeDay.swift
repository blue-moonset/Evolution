//
//  OrderTypeDay.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 23/02/2023.
//

import SwiftUI

struct OrderTypeDay: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var typeDayForOrder:[TypeDay]
    @FetchRequest(sortDescriptors: [
        SortDescriptor(\.index)
    ])var typeDay:FetchedResults<TypeDay>
    @Binding var sheetIsPoint:(show:Bool,type:TypeSheet)
    var body: some View {
        Form{
            Section {
                ForEach(typeDayForOrder, id: \.self) { item in
                    HStack {
                        Image(systemName: item.icone)
                            .font(.callout)
                            .frame(height: 20)
                        Text(item.name.capitalizedSentence)
                            .font(.body)
                    }
                }.onMove { from, to in
                    typeDayForOrder.move(fromOffsets: from, toOffset: to)
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
            Section {
                Button(action: {
                    let array=Array(typeDayForOrder.enumerated())
                    for item in typeDay{
                        item.index=Int16(array.first(where: {$0.element.id == item.id})!.offset)
                        do {
                            try viewContext.save()
                            sheetIsPoint.show=false
                            impactLight()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
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
        }
    }
}
import CoreData
struct OrderTypeDay_Previews: PreviewProvider {
    static let viewContext=PersistenceController.preview.container.viewContext
    static let fetchRequest: NSFetchRequest<TypeDay> = TypeDay.fetchRequest()
    static var previews: some View {
        if let typeDay = try? viewContext.fetch(fetchRequest){
            OrderTypeDay(typeDayForOrder: typeDay, sheetIsPoint: .constant((show: false, type: .addPractice)))
        }
    }
}
