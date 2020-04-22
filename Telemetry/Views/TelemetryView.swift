//
//  Telemetry.swift
//  Telemetry
//
//  Created by feelsgood on 20.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI

struct TelemetryView: View {
    @State private var sessionsDataSource = SessionsDataSource()
    @State private var accelerationDataSource = AccelerationDataSource()
    
    var body: some View {
        TabView {
            RecordingTabView(accelerationDataSource: accelerationDataSource)
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Recording")
                }
            MapTabView(sessionsDataSource: sessionsDataSource)
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Map")
                }
            Text("In Development")
                .tabItem {
                    Image(systemName: "car.fill")
                    Text("Telemetry")
                }
        }.font(.headline)
    }
}

struct TelemetryView_Previews: PreviewProvider {
    static var previews: some View {
        TelemetryView()
    }
}
