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
    @State var acceleration = CMAcceleration()
    @Injected var motionManager: CMMotionManager
    @Injected var repo: TelemetryRepository
    
    
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
                        Text(String(format: "%.2f", acceleration.x))
                    }
                    HStack {
                        Text("Y:")
                        Text(String(format: "%.2f", acceleration.y))
                    }
                    HStack {
                        Text("Z:")
                        Text(String(format: "%.2f", acceleration.z))
                    }
                }
            }
            .navigationBarTitle("Record Session")
        }
    }
    
    func onStartRecordingClick() {
        self.repo.createSession(session)
        motionManager.accelerometerUpdateInterval = 0.2
        motionManager.startAccelerometerUpdates(to: OperationQueue.current ?? OperationQueue()) { (accelDataOrNil, errorOrNil) in
            if let accelData = accelDataOrNil {
                self.acceleration = accelData.acceleration
                self.repo.updateSession(sessionId: self.session.id,
                                        x: self.acceleration.x,
                                        y: self.acceleration.y,
                                        z: self.acceleration.y)
            }
            
            if let error = errorOrNil {
                print(error.localizedDescription)
            }
        }
    }
    
    func onStopRecordingClick() {
        motionManager.stopAccelerometerUpdates()
    }
}

struct RecordingTabView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingTabView()
    }
}
