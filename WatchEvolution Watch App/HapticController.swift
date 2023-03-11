//
//  HapticController.swift
//  WatchEvolution Watch App
//
//  Created by Samy Tahri-Dupre on 11/03/2023.
//

import WatchKit
import SwiftUI

class HapticsEngine: NSObject, ObservableObject, WKExtendedRuntimeSessionDelegate {
   
    static let shared = HapticsEngine()

    private var timer: Timer?
    private var session = WKExtendedRuntimeSession()

    func startSessionIfNeeded() {
        guard session.state != .running else { return }

        session = WKExtendedRuntimeSession()
        session.delegate = self
        session.start()
    }

    func stopSession() {
        session.invalidate()
    }

    func tick() {
        WKInterfaceDevice.current().play(.stop)
    }
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("start")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("expire")
    }
    
}
