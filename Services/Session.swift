//
//  Session.swift
//  CheckTheNotifications
//
//  Created by feelsgood on 16.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import Foundation
import Combine

class Session: Hashable
{
    static func == (lhs: Session, rhs: Session) -> Bool {
        return lhs.id == rhs.id
            && lhs.name == rhs.name
            && lhs.date == rhs.date
    }
    
    let id:String
    public var name:String
    public let date:Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id   )
        hasher.combine(name)
        hasher.combine(date)
    }
    
    convenience init() {
        self.init(id: UUID().uuidString, name: "NO-NAME", date: Date())
    }
    
    init(id:String, name:String, date:Date) {
        self.id = id
        self.name = name;
        self.date = date;
    }
}
