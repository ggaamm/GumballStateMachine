//
//  ContentView.swift
//  Gumball_StateMachine
//
//  Created by Gorker Alp Malazgirt on 11/24/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var model: GumballModel
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 25) {
                HStack {
                    Text("Current State:")
                    Text(String(describing: model.currentState.description))
                        .foregroundColor(Color.red)
                        .font(.headline)
                }
                GumballButton(text: String(describing: Action.insertsQuarter.description)) {
                    model.actionTaken(action: .insertsQuarter)
                }
                GumballButton(text: String(describing:Action.turnCrank.description)) {
                    model.actionTaken(action: .turnCrank)
                }
                GumballButton(text: String(Action.dispenseGumball.description)) {
                    model.actionTaken(action: .dispenseGumball)
                }
                GumballButton(text: String(Action.ejectsQuarter.description)) {
                    model.actionTaken(action: .ejectsQuarter)
                }
            Image("gumball_sm")
                .resizable()
                .aspectRatio(contentMode: .fit)
            }
            .padding()
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var model: GumballModel = GumballModel()
        static var previews: some View {
            ContentView().environmentObject(model)
        }
    }
}

struct GumballButton: View {
    var text: String = ""
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
        }
        .foregroundColor(Color.primary)
        .padding()
        .background(Color.secondary)
    }
}
