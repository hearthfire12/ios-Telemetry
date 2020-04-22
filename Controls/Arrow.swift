//
//  Arrow.swift
//  CheckTheNotifications
//
//  Created by feelsgood on 13.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import UIKit

class Arrow : UIView {
    
    private var displacementVector:CGPoint?
    
    func setDisplacementVectot(_ vector:CGPoint) {
        displacementVector = vector;
        self.setNeedsDisplay()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
     
        self.backgroundColor = UIColor.darkGray
    }
     
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // start point
        let startPoint = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        path.move(to: startPoint)
        
        if let vector = displacementVector {
            path.addLine(to: CGPoint(x: startPoint.x + vector.x, y: startPoint.y + vector.y))
        }
        
        UIColor.orange.setFill()
        path.fill()
        
        UIColor.purple.setStroke()
        path.stroke()
    }
}
