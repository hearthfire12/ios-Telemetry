//
//  ResolverRegistering.swift
//  Telemetry
//
//  Created by feelsgood on 21.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import Resolver
import Combine
import CoreMotion

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        register { TelemetryRepository() }
        register { CMMotionManager() }
//        .implements(TelemetryRepository.self)
    }
}
