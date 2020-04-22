//
//  SessionsDataSource.swift
//  Telemetry
//
//  Created by feelsgood on 19.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import Foundation
import Combine
import Resolver

class SessionsDataSource: ObservableObject {
    @Injected private var repo:ITelemetryRepository
    private let didChange = PassthroughSubject<Void, Never>()
    
    private let shouldUpdate:Bool
    
    private var _sessions:[Session]
    public var sessions:[Session] {
        get {
            if shouldUpdate {
                _sessions = repo.getAllSessions()
            }
            return _sessions
        }
        set {
            _sessions = newValue.sorted(by: { (s1, s2) -> Bool in
                return s1.date < s2.date
            })
            objectWillChange.send()
            didChange.send()
        }
    }
    
    init() {
        shouldUpdate = true
        _sessions = []
    }
    
    init(_ sessions:[Session]) {
        shouldUpdate = false
        _sessions = sessions
    }
}

extension SessionsDataSource {
    static func moq() -> SessionsDataSource {
        var sessions:[Session] = []
        for i in 1...3 {
            sessions.append(Session(id: String(i), name: "session \(i)", date: Date()))
        }
        
        return SessionsDataSource(sessions)
    }
}

