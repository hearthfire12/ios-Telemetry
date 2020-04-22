//
//  BindingView.swift
//  Telemetry
//
//  Created by feelsgood on 19.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI
import Combine
import Resolver
import CoreMotion

class SessionsSource: ObservableObject {
    @Injected private var repo:ITelemetryRepository
    @Injected private var motionManager:CMMotionManager
    
    @Published public var sessions:[Session] = []
    @Published public var currentSessionIndex:Int = -1 {
        didSet {
            if currentSessionIndex >= 0 {
                currentSession = sessions[currentSessionIndex]
            }
        }
    }
    @Published public var currentSession:Session?
    @Published public var points:[CMAcceleration] = []
    @Published public var accel:CMAcceleration = CMAcceleration()
    
    public func create(_ session:Session) {
        repo.createSession(session)
        sessions.append(session)
        currentSessionIndex = sessions.firstIndex(of: session)!
        loadPointsFor(session)
        objectWillChange.send()
    }
    
    public func loadPointsFor(_ session:Session){
        currentSession = session
        points = repo.getSessionData(sessionId: session.id)
        objectWillChange.send()
    }
    
    public func startRecording() {
        print("started")
        motionManager.startAccelerometerUpdates(to: OperationQueue.current ?? OperationQueue()) { (accelData, err) in
            if let accel = accelData?.acceleration {
                let threshold = 0.01
                if accel.x > threshold || accel.y > threshold || accel.z > threshold {
                    print(self.accel.x - accel.x,
                          self.accel.y - accel.y,
                          self.accel.z - accel.z)
                    self.repo.updateSession(sessionId: self.currentSession!.id, point: accel)
                }
                self.accel = accel
            }
            
            if err != nil {
                print(err!.localizedDescription)
            }
        }
    }
    
    public func stopRecording() {
        motionManager.stopAccelerometerUpdates()
        self.objectWillChange.send()
    }
    
    init() {
        sessions = repo.getAllSessions().sorted(by: { (s1, s2) -> Bool in
            return s1.date > s2.date
        })
        
        if sessions.count > 0 {
            currentSessionIndex = 0
        }
        
        motionManager.accelerometerUpdateInterval = 0.2
    }
}

struct TelemetryView2: View {
    
    @ObservedObject var dataSource:SessionsSource = SessionsSource()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button("Create session") {
                        self.dataSource.create(Session())
                    }
                    Button("Start recording", action: dataSource.startRecording).disabled(dataSource.currentSession == nil)
                    Button("Stop recording", action: dataSource.stopRecording).disabled(dataSource.currentSession == nil)
                }
                
                Section {
//                    Picker("Select session", selection: $dataSource.currentSession) {
//                        Text("None")
//                        ForEach(dataSource.sessions, id: \.self) { session in
//                            Text(session.name).tag(session.self).id(session.self)
//                        }
//                    }
//                    .id(self.dataSource.sessions)
                    
                    Picker("Session", selection: $dataSource.currentSessionIndex) {
                        Text("None").tag(-1)
                        ForEach(0..<dataSource.sessions.count) {index in
                            Text(self.dataSource.sessions[index].formattedDate).tag(index)
                        }
                    }
                    .id(self.dataSource.sessions)
                }
                
                Section {
                    Button("Draw map") {
                        if let session = self.dataSource.currentSession {
                            self.dataSource.loadPointsFor(session)
                        }
                    }
                }
                
                Section {
                    MapView(points: self.$dataSource.points)
                        .frame(width: 345, height: 100)
                }
            }
        }
    }
}

struct Preview: PreviewProvider {
    static var previews: some View {
        TelemetryView2()
    }
}

struct NaviView: View {
    @Binding var names:[String]
//    @Binding var message:String
    @ObservedObject var message:ObserveMe
    @State var selectedNames = Set<String>()
    
    var body: some View {
        NavigationView {
            List(names, id: \.self, selection: $selectedNames){ name in
                Text(name)
            }
            .navigationBarItems(trailing: EditButton())
            .navigationBarTitle(Text("\(message.text) \(selectedNames.count)"))
        }
    }
}

class ObserveMe: ObservableObject {
//    @Published
    var text:String = "hello" {
        willSet {
            print(newValue)
            objectWillChange.send()
        }
    }
    
    func changeText(_ newText:String) {
        text = newText
    }
}

struct BindingView: View {
    @State var names = ["first", "second"]
    @ObservedObject var message = ObserveMe()
    @EnvironmentObject var env:ObserveMe
    
    var body: some View {
        VStack {
            Text(message.text)
            Button("Change", action: onChangeTextClick)
            NaviView(names: $names, message: message)
        }
    }
    
    func onChangeTextClick(){
        message.changeText("changed")
        names.append("third")
    }
}

//struct BindingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BindingView()
//        .environmentObject(ObserveMe())
//    }
//}
