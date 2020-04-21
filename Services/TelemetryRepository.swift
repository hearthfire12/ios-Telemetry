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

protocol ITelemetryRepository {
    func createSession(_ session:Session) -> Void
    func updateSession(sessionId:String, x:Double, y:Double, z:Double) -> Void
    func getSessionData(sessionId:String) -> EventLoopFuture<[CGPoint]>
    func getAllSessions() -> EventLoopFuture<[Session]>
    func getSession(sessionId:String) -> EventLoopFuture<Session>
}

class TelemetryRepository: ITelemetryRepository {
    
    let db:MongoDatabase?
    
    init() {
        do {
            let connectionString = "mongodb://root:rootpassword@192.168.0.101:27017/Telemetry"
            db = try MongoDatabase.synchronousConnect(connectionString)
        }
        catch {
            print("can't initialize repository")
            db = nil
        }
    }
    
    func createSession(_ session:Session) {
        let result = db!["Session"].insert(["_id":session.id, "name":session.name, "date":session.date])
        
        result.whenSuccess({(InsertReply) in
            print("session created ok:" + String(InsertReply.ok) + " updated:" + String(InsertReply.insertCount))
        })
        result.whenFailure { (Error) in
            print("session creation failed "+Error.localizedDescription)
        }
    }
    
    func updateSession(sessionId:String, x:Double, y:Double, z:Double) {
        let result = db!["SessionData"].insert(["sessionId":sessionId, "x":x, "y":y, "z":z]);
        
        result.whenSuccess({ (InsertReply) in
            print("session updated ok:"+String(InsertReply.ok)+" updated:"+String(InsertReply.insertCount))
        })
        result.whenFailure { (Error) in
            print("session upfation failed "+Error.localizedDescription)
        }
    }
    
    func getSessionData(sessionId:String) -> EventLoopFuture<[CGPoint]> {
        return db!["SessionData"].find("sessionId" == sessionId).map { (document) -> CGPoint in
                return CGPoint(x: document["x"] as! Double, y: document["y"] as! Double)
            }.allResults()
    }
    
    func getAllSessions() -> EventLoopFuture<[Session]> {
        return db!["Session"].find().map { (document) -> (Session) in
                    return Session(id: (document["_id"] as! String),
                                   name: document["name"] as! String,
                                   date: document["date"] as! Date)
          }.allResults();
    }
    
    func getSession(sessionId:String) -> EventLoopFuture<Session> {
        return db!["Session"].findOne("_id" == sessionId).map { (document) -> (Session) in
            return Session(id: (document!["_id"] as! String),
                           name: document!["name"] as! String,
                           date: document!["date"] as! Date)
        }
    }
}
