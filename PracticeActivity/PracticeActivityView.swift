//
//  PracticeActivityView.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 19/02/2023.
//

//import ActivityKit
//import WidgetKit
//import SwiftUI
//
//struct PracticeActivityView: View {
////    @State var attributes: PracticeActivityAttributes
//    @State var state: PracticeActivityAttributes.ContentState
//    var body: some View {
//        VStack (spacing:0){
//            Link(destination: URL(string:"evolution://reset")!) {
//                Text(state.practices[state.index].name)
//                    .fontWeight(.semibold)
//                    .font(.title2)
//                    .lineLimit(1)
//                    .foregroundColor(.black)
//            }.padding(.bottom,10)
//            Divider()
//                .padding(.bottom,10)
//            HStack {
//                Link(destination: URL(string:"evolution://last")!) {
//                    Image(systemName: "arrow.left.to.line")
//                        .foregroundColor(state.index-1 >= 0 ? .blue:.gray)
//                        .fontWeight(.bold)
//                        .font(.body)
//                        .frame(width: 30,height: 30)
//                        .background(.gray.opacity(0.2))
//                        .clipShape(Circle())
//                }
//
//                Link(destination: URL(string: state.isOn ? "evolution://pause":"evolution://play")!) {
//                    Image(systemName: state.isOn ? "pause.fill":"play.fill")
//                        .foregroundColor(.white)
//                        .font(.title2)
//                        .frame(width: 40,height: 40)
//                        .background(.blue)
//                        .clipShape(Circle())
//                 }.padding(.leading,20)
//
//                Spacer(minLength: 0)
//                Label {
//                    Group{
//                        if state.pauseTime != nil || Date() > state.time.upperBound{
//                            Text(timeInString())
//                        }else{
//                            Text(timerInterval: state.time, countsDown: true)
//                        }
//                        
//                    }
//                    .multilineTextAlignment(.center)
//                    .frame(width: 70)
//                    .monospacedDigit()
//                } icon: {
//                    Image(systemName: "timer")
//                        .foregroundColor(.indigo)
//                }.font(.title)
//                    .minimumScaleFactor(0.6)
//                    .fontWeight(.medium)
//                
//                Spacer(minLength: 0)
//                Link(destination: URL(string:"evolution://next")!) {
//                    Image(systemName: "arrow.right.to.line")
//                        .foregroundColor(state.index+1 <= state.practices.count-1 ? .blue:.gray)
//                        .fontWeight(.bold)
//                        .font(.body)
//                        .frame(width: 30,height: 30)
//                        .background(.gray.opacity(0.2))
//                        .clipShape(Circle())
//                        .padding(.leading,20)
//                }
//                
//            }
//        }.padding(.horizontal,20)
//            .padding(.vertical,15)
//            .activityBackgroundTint(.white)
//            .activitySystemActionForegroundColor(.black)
//            .preferredColorScheme(.light)
//            
//    }
//    func timeInString() -> String {
//        var time: Double = 0
//        if let pauseTime=state.pauseTime{
//            time = Double(pauseTime)
//        }else{
//            time = Double(state.practices[state.index].repos)
//        }
//        let minutes = Int(time / 60)
//        let seconds = time.truncatingRemainder(dividingBy: 60)
//        return String(format: "%01d:%02d", Int(minutes), Int(seconds))
//    }
//}
//
//
//import CoreData
//struct PracticeActivityView_Previews: PreviewProvider {
//    static let viewContext=PersistenceController.preview.container.viewContext
//    static let fetchRequest: NSFetchRequest<TrainingDay> = TrainingDay.fetchRequest()
//    static var timerState:TimerState = .shared
//    static let attributes = PracticeActivityAttributes()
//    
//    static var contentState:PracticeActivityAttributes.ContentState?=PracticeActivityAttributes.ContentState(time: PracticeActivityView_Previews.timerState.timer!,isOn: true,index: PracticeActivityView_Previews.timerState.timerState!.index, practices: convertPractices(practices: PracticeActivityView_Previews.timerState.timerState!.practices))
//    static var previews: some View {
//        if let trainingDay = try? viewContext.fetch(fetchRequest).first, save(trainingDay){
//            attributes
//                .previewContext(contentState!, viewKind: .content)
//                .previewDisplayName("Notification")
//        }
//    }
//    static func save(_ trainingDay:TrainingDay)->Bool{
//        timerState.timerState=(practices:trainingDay.allPractice(),index:0)
//        timerState.isOn=true
//        timerState.timer=Date.now...Date().addingTimeInterval(TimeInterval(90))
//        return true
//    }
//}
