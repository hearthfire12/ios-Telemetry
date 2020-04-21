//
//  Extensions.swift
//  CheckTheNotifications
//
//  Created by feelsgood on 16.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
