//
//  SessionRepositoy.swift
//  CheckTheNotifications
//
//  Created by feelsgood on 16.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import Foundation
import MongoKitten
import UIKit
import CoreMotion

protocol ITelemetryRepository {
    func createSession(_ session:Session) -> Void
    func updateSession(sessionId:String, point:CMAcceleration) -> Void
    func getSessionData(sessionId:String) -> [CMAcceleration]
    func getAllSessions() -> [Session]
    func getSession(sessionId:String) -> Session
}

class MoqTelemetryRepository: ITelemetryRepository {
    var sessions:[Session] = []
    var sessionData = Dictionary<String, [CMAcceleration]>()
    
    func createSession(_ session:Session) -> Void {
        sessions.append(session)
        sessionData[session.id] = []
    }
    func updateSession(sessionId:String, point:CMAcceleration) -> Void {
        var points = sessionData[sessionId]!
        points.append(point)
        sessionData[sessionId] = points
    }
    func getSessionData(sessionId:String) -> [CMAcceleration] {
        return sessionData[sessionId]!
    }
    func getAllSessions() -> [Session] {
        return sessions
    }
    func getSession(sessionId:String) -> Session {
        return sessions.first { (session) -> Bool in
            return session.id == sessionId
        }!
    }
}

class TelemetryRepository: ITelemetryRepository {
    
    let db:MongoDatabase
    
    init() {
        let connectionString = "mongodb://root:rootpassword@192.168.0.101:27017/Telemetry"
        db = try! MongoDatabase.synchronousConnect(connectionString)
    }
    
    func createSession(_ session:Session) {
        let result = db["Session"].insert(["_id":session.id, "name":session.name, "date":session.date])
    }
    
    func updateSession(sessionId:String, point: CMAcceleration) {
        let result = db["SessionData"].insert(["sessionId":sessionId, "x":Double(point.x), "y":Double(point.y), "z":Double(point.z)]);
    }
    
    func getSessionData(sessionId:String) -> [CMAcceleration] {
        return try! db["SessionData"].find("sessionId" == sessionId).map { (document) -> CMAcceleration in
            return CMAcceleration(x: document["x"] as! Double, y: document["y"] as! Double, z: document["z"] as! Double)
        }.allResults().wait()
    }
    
    func getAllSessions() -> [Session] {
        return try! db["Session"].find().map { (document) -> (Session) in
                    return Session(id: (document["_id"] as! String),
                                   name: document["name"] as! String,
                                   date: document["date"] as! Date)
            }.allResults().wait();
    }
    
    func getSession(sessionId:String) -> Session {
        return try! db["Session"].findOne("_id" == sessionId).map { (document) -> (Session) in
            return Session(id: (document!["_id"] as! String),
                           name: document!["name"] as! String,
                date: document!["date"] as! Date)
        }.wait()
    }
}
