//
//  MapView.swift
//  Telemetry
//
//  Created by feelsgood on 21.04.2020.
//  Copyright © 2020 feelsgood. All rights reserved.
//

import SwiftUI
import CoreMotion

struct MapView: View {
    @Binding var points:[CMAcceleration]
    
    var body: some View {
        GeometryReader { (geometry) in
            Path { path in
                let paddingWidth:CGFloat = 10,
                    paddingHeight:CGFloat = 10

                let containerWidth:CGFloat = geometry.size.width,
                    containerHeight:CGFloat = geometry.size.height

                let width = containerWidth - paddingWidth,
                    height = containerHeight - paddingHeight

                let center = CGPoint(x: containerWidth / 2,
                                     y: containerHeight / 2)
                let totalWidth = self.getTotalMaxDisplacement(self.points.map({ (p) -> CGFloat in
                    return CGFloat(p.x)
                }))

                let totalHeight = self.getTotalMaxDisplacement(self.points.map({ (p) -> CGFloat in
                    return CGFloat(p.y)
                }))

                let widthFactor:CGFloat = width / 2 / totalWidth,
                    heightFactor:CGFloat = height / 2 / totalHeight

                var prevPoint:CGPoint = center
                path.move(to: center)
                for point in self.points {
                    prevPoint = CGPoint(x: prevPoint.x + CGFloat(point.x) * widthFactor,
                                        y: prevPoint.y + CGFloat(point.y) * heightFactor)
                    path.addLine(to: prevPoint)
                    
                    print(prevPoint.x, prevPoint.y)
                }

            }
            .stroke(Color.black)
        }
    }
    
    func getTotalMaxDisplacement(_ numbers:[CGFloat]) -> CGFloat {
        var current = CGFloat(0),
            min = CGFloat(0),
            max = CGFloat(0)
        for number in numbers {
            current = current + number
            
            if current > max {
                max = current
            }
            
            if current < min {
                min = current
            }
        }
        
        return max - min
    }
}

struct MapView_Previews: PreviewProvider {
    @State static var sessionData = [
        CMAcceleration(x: -2, y: 1, z: 0),
        CMAcceleration(x: 1, y: 0, z: 0),
        CMAcceleration(x: -2, y: 1, z: 0),
        CMAcceleration(x: 1, y: 0, z: 0),
        CMAcceleration(x: -2, y: 1, z: 0),
        CMAcceleration(x: 3, y: 0, z: 0),
        CMAcceleration(x: 0, y: 1, z: 0),
        CMAcceleration(x: 2, y: 0, z: 0),
        CMAcceleration(x: 0, y: -1, z: 0),
        CMAcceleration(x: 3, y: 0, z: 0),
        CMAcceleration(x: -2, y: -1, z: 0),
        CMAcceleration(x: 1, y: 0, z: 0),
        CMAcceleration(x: -2, y: -1, z: 0),
        CMAcceleration(x: 1, y: 0, z: 0),
        CMAcceleration(x: -2, y: -1, z: 0),
    ]
    
    static var previews: some View {
        MapView(points: $sessionData)
    }
}
