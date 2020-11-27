//
//  Gumball_StateMachineApp.swift
//  Gumball_StateMachine
//
//  Created by Gorker Alp Malazgirt on 11/24/20.
//

import SwiftUI

@main
struct Gumball_StateMachineApp: App {
    @StateObject private var model = GumballModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(model)
        }
    }
}
