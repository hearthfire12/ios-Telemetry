//
//  MapControl.swift
//  CheckTheNotifications
//
//  Created by feelsgood on 16.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import UIKit

class MapControl : UIView {
    private let repository = TelemetryRepository()
    private var session:Session?;
    
    func setSession(_ session:Session) {
        self.session = session
        self.setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        if session == nil {
            return
        }
        
        let path = UIBezierPath()
        
        // start point
        let startPoint = CGPoint(x: self.frame.height/2, y: self.frame.height/1.2)
        path.move(to: startPoint)
        
        let points = repository.getSessionData(sessionId: session!.id)
        
        let frameH:CGFloat = self.frame.height,
            frameW:CGFloat = self.frame.width;
        
//        let maxH:CGFloat = CGFloat(points.max { (pointA, pointB) -> Bool in return pointA.y > pointB.y;}!.y)
//        let maxW:CGFloat = CGFloat(points.max { (pointA, pointB) -> Bool in return pointA.x > pointB.x;}!.x)
        let maxH = CGFloat(0), maxW = CGFloat(0)
        
        let diffH:CGFloat = frameH - maxH,
            diffW:CGFloat = frameW - maxW;
        
        var HFactor:CGFloat = 1,
            WFactor:CGFloat = 1;
        
        if diffH < 0 {
            HFactor = maxH * frameH / CGFloat(100.0) - CGFloat(100.0)
        }
        
        if diffW < 0 {
            WFactor = maxW * frameW / CGFloat(100.0) - CGFloat(100.0)
        }
        
        for point in points {
            let p = CGPoint(x: CGFloat(point.x) * HFactor, y: CGFloat(point.y) * WFactor)
            path.addLine(to: p)
            print("Drawing point \(p.x) \(p.y)")
        }
        
        UIColor.red.setFill()
        path.fill()
        
        UIColor.white.setStroke()
        path.stroke()
    }
}
