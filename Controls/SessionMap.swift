//
//  SessionMap.swift
//  Telemetry
//
//  Created by feelsgood on 19.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI

struct SessionMap: View {
    @State private var session:Binding<Session?>?
    
    var body: some View {
        Text("map")
    }
    
    init(_ session:Binding<Session?>) {
        self.session = session
    }
}

struct SessionMap_Previews: PreviewProvider {
    static var previews: some View {
        SessionMap(.constant(Session(id: "1", name: "session 1", date: Date())))
    }
}
