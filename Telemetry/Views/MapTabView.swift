//
//  MapTabView.swift
//  Telemetry
//
//  Created by feelsgood on 20.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI
import Combine
import CoreMotion
import Resolver

class SessionObservable : ObservableObject {
    @Published var session:Session?
}

struct MapTabView: View {
    @ObservedObject private var observalbeSession:SessionObservable {
        didSet {
            sessionData = self.repo.getSessionData(sessionId: observalbeSession.session!.id)
        }
    }
    @State private var sessionData:[CMAcceleration] = []
    @ObservedObject var sessionsDataSource:SessionsDataSource
    @Injected var repo: ITelemetryRepository
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select session", selection: $observalbeSession.session) {
                        ForEach(sessionsDataSource.sessions, id: \.self) { item in
                            Text(item.name)
                        }
                    }
                }
                MapView(points: $sessionData)
                    .frame(width: 250, height: 100)
            }
            .navigationBarTitle("Map")
        }
    }
    
    init(sessionsDataSource:SessionsDataSource) {
        self.sessionsDataSource = sessionsDataSource
        observalbeSession = SessionObservable()
    }
}

struct MapTabView_Previews: PreviewProvider {
    static var previews: some View {
        MapTabView(sessionsDataSource: .moq())
    }
}
