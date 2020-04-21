//
//  ContentView.swift
//  Telemetry
//
//  Created by feelsgood on 16.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var accelDataSource:AccelerationDataSource
    @ObservedObject var sessionsDataSource:SessionsDataSource
    @State private var selectedSession:Session?
    
    init() {
        sessionsDataSource = SessionsDataSource() //.moq()
        accelDataSource = AccelerationDataSource() //.moq()
        
        // DispatchQueue.main.async
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Start recording", action: onStartRecordingClick)
                Image(systemName: "video.circle")
                Button("Stop recording", action: onStopRecordingClick)
            }
            
            HStack {
                HStack {
                    Text("X")
                    Text(String(format: "%.2f", accelDataSource.accel?.x ?? 0))
                }
                HStack {
                    Text("Y")
                    Text(String(format: "%.2f", accelDataSource.accel?.y ?? 0))
                }
                HStack {
                    Text("Z")
                    Text(String(format: "%.2f", accelDataSource.accel?.z ?? 0))
                }
            }
            
            Picker("Select session", selection: $selectedSession) {
                ForEach(sessionsDataSource.sessions, id: \.self) { session in
                    Text(session.name)
                }
            }
            
            SessionMap($selectedSession)
        }
    }
    
    func onStartRecordingClick() -> Void {
        accelDataSource.start()
    }

    func onStopRecordingClick() -> Void {
        accelDataSource.stop()
    }

    func onDrawMapClick() -> Void {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
