//
//  Telemetry.swift
//  Telemetry
//
//  Created by feelsgood on 20.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI

struct TelemetryView: View {
    var body: some View {
        TabView {
            RecordingTabView()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Recording")
                }
            MapTabView()
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
