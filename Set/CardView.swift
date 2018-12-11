//
//  CardView.swift
//  Set
//
//  Created by Andi Maroge on 11/30/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import UIKit

class CardView: UIView {
    //
    //    var width:CGFloat = 0 { didSet { setNeedsDisplay(); setNeedsLayout()}}
    //    var height:CGFloat = 0{ didSet { setNeedsDisplay(); setNeedsLayout()}}
    
    //    public var viewFrame = CGRect(x: 0, y: 0, width: 0, height: 0){
    //
    //        didSet{
    //            self.frame = viewFrame
    //            setNeedsDisplay()
    //        }
    //    }
    
    static var identifier = 0
    
    public var shape: Card.Shapes? = nil
    var color: UIColor? = nil
    var numberOfShapes = 0
    var shadingAlpha: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //        viewFrame = frame
        CardView.identifierFactory()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    static func identifierFactory() {
        self.identifier += 1
    }
    static func getIdentifier() -> Int {
        return CardView.identifier
    }
    
    override func draw(_ rect: CGRect) {
        
        var path: UIBezierPath? = nil
        var xPositionOfOval = self.frame.width / 2,
            ovalSize = self.frame.height * 0.30
        
        var diamondStartX = centerOffsetX,
            diamondStartY = quarterOffsetY,
            lineLengthOfDiamond:CGFloat = bounds.size.width * 0.125
        
        var controlPointLength: CGFloat = bounds.size.width * 0.5
        
        var squiggleStartPoints = CGPoint(x: thirdOffsetX, y: quarterOffsetY),
        squiggleEndPoints = CGPoint(x: thirdOffsetX * 2, y: quarterOffsetY * 3)
        
        let shapeSpacing: CGFloat = bounds.size.width * 0.33
        
        if numberOfShapes == 2 {
            xPositionOfOval = thirdOffsetX
            ovalSize /= 2
            
            diamondStartX = thirdOffsetX
            squiggleStartPoints.x = quarterOffsetX
            squiggleEndPoints.x *= 0.75
        }
        else if numberOfShapes == 3 {
            xPositionOfOval = xPositionOfOval / 3
            ovalSize *= 0.50
            
            diamondStartX = thirdOffsetX / 2
            
            squiggleStartPoints.x *= 0.125
            squiggleEndPoints.x = -quarterOffsetY + controlPointLength
            
        }
        for index in 1...numberOfShapes {
            switch shape {
            case .Squiggle?:
                var controlPoint1 = CGPoint(x: squiggleStartPoints.x + controlPointLength, y: quarterOffsetY)
                var controlPoint2 = CGPoint(x: squiggleEndPoints.x - controlPointLength, y: quarterOffsetY * 3)
                
                path = UIBezierPath()
                path?.move(to: squiggleStartPoints)
                path?.addCurve(to: squiggleEndPoints, controlPoint1: controlPoint1, controlPoint2: controlPoint2)
                path?.close()
                
                squiggleStartPoints.x += shapeSpacing
                squiggleEndPoints.x += shapeSpacing
                break
            case .Diamond?:
                path = UIBezierPath()
                path?.move(to: CGPoint(x: diamondStartX, y: diamondStartY))
                path?.addLine(to: (CGPoint(x: diamondStartX - lineLengthOfDiamond, y: diamondStartY * 2))) // /
                path?.addLine(to: CGPoint(x: diamondStartX, y: diamondStartY * 3)) // \
                path?.addLine(to: CGPoint(x: diamondStartX + lineLengthOfDiamond , y: diamondStartY * 2)) // \
                path?.addLine(to: CGPoint(x: diamondStartX, y: diamondStartY)) // /
                path?.close()
                
                diamondStartX += shapeSpacing
                break
            case .Oval?:
                path = UIBezierPath(arcCenter: CGPoint(x: xPositionOfOval, y: centerOffsetY), radius: ovalSize, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
                
                xPositionOfOval += shapeSpacing
                
                break
            default:
                break
                
            }
            color?.setFill()
            color?.setStroke()
            
            path?.fill(with: .normal, alpha: shadingAlpha)
            path?.stroke(with: .normal, alpha: 1)
        }
    }
    
    public func setColor(color: UIColor){
        self.color = color
    }
    
}
extension CardView {
    
    private struct SizeRatio {
        static let quarterOffsetToBoundsWidth: CGFloat = 0.25
        static let quarterOffsetToBoundsHeight: CGFloat = 0.25
        static let thirdOffsetToBoundsHeight: CGFloat = 0.33
        static let thirdOffsetToBoundsWidth: CGFloat = 0.33
        static let centerOffsetToBoundsHeight: CGFloat = 0.50
        static let centerOffsetToBoundsWidth: CGFloat = 0.50
        
    }
    private struct Diamond {
        
        static let xOffsetRatio: CGFloat = 0.50
        static let yOffsetRatio: CGFloat = 0.25
        static var lineLengthOfDiamond:CGFloat = 15
        
    }
    private var quarterOffsetX: CGFloat {
        return bounds.size.width * SizeRatio.quarterOffsetToBoundsWidth
    }
    private var quarterOffsetY: CGFloat {
        return bounds.size.height * SizeRatio.quarterOffsetToBoundsHeight
    }
    private var thirdOffsetX: CGFloat {
        return bounds.size.width * SizeRatio.thirdOffsetToBoundsWidth
    }
    private var thirdOffsetY: CGFloat {
        return bounds.size.height * SizeRatio.thirdOffsetToBoundsHeight
    }
    private var centerOffsetX: CGFloat {
        return bounds.size.width * SizeRatio.centerOffsetToBoundsWidth
    }
    private var centerOffsetY: CGFloat {
        return bounds.size.height * SizeRatio.centerOffsetToBoundsHeight
    }
    
}
