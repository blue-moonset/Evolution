//
//  PracticeActivityLiveActivity.swift
//  PracticeActivity
//
//  Created by Samy Tahri-Dupre on 19/02/2023.
//

//import ActivityKit
//import WidgetKit
//import SwiftUI
//
//
//
//
//struct PracticeActivityLiveActivity: Widget {
//    var body: some WidgetConfiguration {
//        ActivityConfiguration(for: PracticeActivityAttributes.self) { context in
//            PracticeActivityView(state: context.state)
//
//        } dynamicIsland: { context in
//            DynamicIsland {
//                // Expanded UI goes here.  Compose the expanded UI through
//                // various regions, like leading/trailing/center/bottom
//                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
//                }
//                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
//                }
//                DynamicIslandExpandedRegion(.bottom) {
//                    Text("Bottom")
//                    // more content
//                }
//            } compactLeading: {
//                Text("L")
//            } compactTrailing: {
//                Text("T")
//            } minimal: {
//                Text("Min")
//            }
//            .widgetURL(URL(string: "http://www.apple.com"))
//            .keylineTint(Color.red)
//        }
//    }
//}
//import CoreData
//struct PracticeActivityLiveActivity_Previews: PreviewProvider {
//    static let viewContext=PersistenceController.preview.container.viewContext
//    static let fetchRequest: NSFetchRequest<TypeDay> = TypeDay.fetchRequest()
//    static var timerState:TimerState = .shared
//    static let attributes = PracticeActivityAttributes()
//    
//    static var contentState:PracticeActivityAttributes.ContentState?=PracticeActivityAttributes.ContentState(time: PracticeActivityLiveActivity_Previews.timerState.timer!,isOn: true,index: PracticeActivityLiveActivity_Previews.timerState.timerState!.index, practices: convertPractices(practices: PracticeActivityLiveActivity_Previews.timerState.timerState!.practices))
//    static var previews: some View {
//        if let typeDay = try? viewContext.fetch(fetchRequest).first, save(typeDay){
//            attributes
//                .previewContext(contentState!, viewKind: .dynamicIsland(.compact))
//                .previewDisplayName("Island Compact")
//            attributes
//                .previewContext(contentState!, viewKind: .dynamicIsland(.expanded))
//                .previewDisplayName("Island Expanded")
//            attributes
//                .previewContext(contentState!, viewKind: .dynamicIsland(.minimal))
//                .previewDisplayName("Minimal")
//            attributes
//                .previewContext(contentState!, viewKind: .content)
//                .previewDisplayName("Notification")
//        }
//    }
//    static func save(_ typeDay:TypeDay)->Bool{
//        timerState.timerState=(practices:typeDay.allSportPractice(),index:0)
//        timerState.isOn=true
//        timerState.timer=Date.now...Date().addingTimeInterval(TimeInterval(90))
//        return true
//    }
//}
