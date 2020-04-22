//
//  AccelerationDataSource.swift
//  Telemetry
//
//  Created by feelsgood on 19.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import Combine
import CoreMotion
import Resolver
import UIKit

protocol AccelRecorder {
    func startRecordingForNewSession(updateInterval:Int)
    func stopAndSave() -> Session
}

protocol AccelerationSource:ObservableObject {
    var data:CMAcceleration { get }
    
}

class AccelerationDataSource: ObservableObject {
    @Injected private var repo:ITelemetryRepository
    @Injected private var motionManager:CMMotionManager
    
    public var accel:CMAcceleration = CMAcceleration()
    private var currentSession:Session = Session()
    
    init() {
        motionManager.accelerometerUpdateInterval = 0.2
    }
    
    public func start() -> Void {
        currentSession = Session()
        repo.createSession(currentSession)
        
        motionManager.startAccelerometerUpdates(to: OperationQueue.current ?? OperationQueue()) { (accelData, err) in
            if accelData != nil {
                self.accel = accelData!.acceleration
                self.repo.updateSession(sessionId: self.currentSession.id,
                                        point: accelData!.acceleration)
                
                self.objectWillChange.send()
            }
            
            if err != nil {
                print(err!.localizedDescription)
            }
        }
    }
    
    public func stop() {
        motionManager.stopAccelerometerUpdates()
    }
}

extension AccelerationDataSource {
    static func moq() -> AccelerationDataSource {
        return AccelerationDataSource()
    }
}
