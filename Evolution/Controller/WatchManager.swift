//
//  WatchManager.swift
//  Evolution
//
//  Created by Samy Tahri-Dupre on 20/02/2023.
//

import Foundation
import Combine
import WatchConnectivity

final class WatchManager: ObservableObject {
    static var shared=WatchManager()
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<AttributesForWatchConvert?, Never>()
    
    @Published var errorReplyHandler=false
    @Published var sportPractice: AttributesForWatchConvert?
    
    init(session: WCSession = .default) {
        self.delegate = SessionWatchDelegater(countSubject: subject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$sportPractice)
            
    }
//    TODO: agir en cas d'erreur dans les envois
    func sendFromIOS(sportPractice: AttributesForWatch) {
        session.sendMessage(["iOS":sportPractice.toDictionary()], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
//    TODO: probleme de latense entre l'attente de resultat et la repnse si changement de donné a caus  d'action utilisteur
    func saveFromWatchOS(practicesDone:[UUID]) {
        let convertToString=practicesDone.map({$0.uuidString})
        session.sendMessage(["watchOS":["done": convertToString]], replyHandler: nil){ error in
            print(error.localizedDescription)
        }
    }
    func sendFromWatchOS(sportPractice: AttributesForWatchToIOS) {
        session.sendMessage(["watchOS":sportPractice.toDictionary()], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}
