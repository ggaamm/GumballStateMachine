//
//  GumballModel.swift
//  Gumball_StateMachine
//
//  Created by Gorker Alp Malazgirt on 11/24/20.
//

import Foundation
import Combine

enum GumballState: String, Identifiable, CustomStringConvertible {
    case NoQuarter, HasQuarter, GumballSold, OutOfGumballs
    var id: String { self.rawValue }
    
    var description: String {
        switch self.self {
        case .NoQuarter:
            return "No Quarter"
        case .HasQuarter:
            return "Has Quarter"
        case .GumballSold:
            return "Gumball Sold"
        case .OutOfGumballs:
            return "Out of Gamballs"
        }
    }
}

enum Action: String, Identifiable, CustomStringConvertible {
    
    case turnCrank, dispenseGumball, ejectsQuarter, insertsQuarter, loadGumballs
    var id: String { self.rawValue }
    
    var description: String {
        switch self {
        case .turnCrank:
            return "Turn Crank"
        case .dispenseGumball:
            return "Dispense Gumball"
        case .ejectsQuarter:
            return "Eject Quarter"
        case .insertsQuarter:
            return "Insert Quarter"
        case .loadGumballs:
            return "Load Gumball"
            
        }
    }
}

final class GumballModel: ObservableObject {
    @Published var currentState: String = String(describing: GumballState.NoQuarter.description)
    
    private var state: GumballState = GumballState.NoQuarter {
        willSet {
            print(self.state)
            statePublisher.send(self.state)
        }
    }
    private let actionPublisher = PassthroughSubject<Action, Never>()
    private let statePublisher = CurrentValueSubject<GumballState, Never>(.NoQuarter)

    private var cancellable = Set<AnyCancellable>()
    private var gumballs = 2
    
    func actionTaken(action: Action) {
        actionPublisher.send(action)
    }
    
    func loadGumballs(_ moreGumbals: Int) {
        gumballs += moreGumbals
    }
    
    init() {
        actionPublisher
            .sink { action in
                let oldState = self.state.rawValue
                
                switch self.state {
                case .NoQuarter:
                    if action == .insertsQuarter {
                        self.state = .HasQuarter
                    }
                case .HasQuarter:
                    if action == .turnCrank {
                        self.state = .GumballSold
                    } else if action == .ejectsQuarter {
                        self.state = .NoQuarter
                    }
                case .GumballSold:
                    if action == .dispenseGumball {
                        self.gumballs -= 1
                        if self.gumballs > 0 {
                            self.state = .NoQuarter
                        // gumball is dispensed
                            print("Gumball is dispensed")
                            print("Number of Gumballs: \(self.gumballs)")
                        } else {
                            self.state = .OutOfGumballs
                        }
                    }
                case .OutOfGumballs:
                    if action == .loadGumballs && self.gumballs > 0 {
                        self.state = .NoQuarter
                        self.state = .NoQuarter
                    }
                }

                let newState = self.state.rawValue
                print("Old State: ", oldState, " New State: ", newState)
                self.currentState = String(describing: self.state.description)
             }
            .store(in: &cancellable)
    }
}
