//
//  Coordinates.swift
//  Set
//
//  Created by Andi Maroge on 11/11/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import Foundation
import UIKit
struct Coordinates {

    public func randomCoordinatesWithinBoundsOfView(of xValue: CGFloat, and yValue: CGFloat, of width: Int, and height: Int) -> CGPoint{
        let posX = Int(xValue) - width
        let posY = Int(yValue) - height
        let topSpacing = 50, bottomSpace = 80
        let leadingSpace = 16, trailingSpace = 16

        
        let randomPositionX = Int.random(in: leadingSpace ..< (posX - trailingSpace))
        let randomPositionY = Int.random(in: topSpacing ..< (posY - bottomSpace))
        
        
        return CGPoint(x: randomPositionX, y: randomPositionY)
    }

}




