//
//  RecordingTabView.swift
//  Telemetry
//
//  Created by feelsgood on 20.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI
import Combine
import CoreMotion
import Resolver

struct RecordingTabView: View {
    @State var session:Session = Session()
    @State var isRecording = false
    @ObservedObject var accelerationDataSource: AccelerationDataSource
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Enter session name...", text: $session.name)
                }
                    
                Section {
                    Button(action: onStartRecordingClick) {
                        HStack {
                            Image(systemName: isRecording ? "play" : "play.fill")
                            Text("Start recording")
                        }
                    }
                    .disabled(isRecording)
                    
                    Button(action: onStopRecordingClick) {
                        HStack {
                            Image(systemName: isRecording ? "stop" : "stop.fill")
                            Text("Stop recording")
                        }
                    }
                    .disabled(isRecording)
                }
                
                Section {
                    HStack {
                        Text("X:")
                        Text(String(format: "%.2f", accelerationDataSource.accel.x))
                    }
                    HStack {
                        Text("Y:")
                        Text(String(format: "%.2f", accelerationDataSource.accel.y))
                    }
                    HStack {
                        Text("Z:")
                        Text(String(format: "%.2f", accelerationDataSource.accel.z))
                    }
                }
            }
            .navigationBarTitle("Record Session")
        }
    }
    
    func onStartRecordingClick() {
        accelerationDataSource.start()
    }
    
    func onStopRecordingClick() {
        accelerationDataSource.stop()
    }
}

struct RecordingTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingTabView(accelerationDataSource: .moq())
    }
}
