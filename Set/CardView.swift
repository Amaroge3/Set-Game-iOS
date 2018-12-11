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
    
    //id value of each CardView
    static var identifier = 0
    //the shape of each card
    public var shape: Card.Shapes? = nil
    //color of card
    var color: UIColor? = nil
    //number of shapes of each card
    var numberOfShapes = 0
    //alpha value of each card
    var shadingAlpha: CGFloat = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
        
    }
    
    //creates an id value for CardView    
    static func identifierFactory() {
        self.identifier += 1
    }
    static func getIdentifier() -> Int {
        return CardView.identifier
    }
    
    override func draw(_ rect: CGRect) {
        
        //variable for the shape that's to be drawn
        var path: UIBezierPath? = nil
        
        //the 'x' position of the Oval shape
        var xPositionOfOval = self.frame.width / 2,
            ovalSize = self.frame.height * 0.30 //size of Oval. the size of oval changes as more than one is added
        
        //start positions of 'x' and 'y' of the Diamond shape to be drawn
        var diamondStartX = centerOffsetX,
            diamondStartY = quarterOffsetY,
            lineLengthOfDiamond:CGFloat = bounds.size.width * 0.125 //length of the lines of the Diamond
        
        //squiggle Start and End points
        var squiggleStartPoints = CGPoint(x: thirdOffsetX, y: quarterOffsetY),
            squiggleEndPoints = CGPoint(x: thirdOffsetX * 2, y: quarterOffsetY * 3),
            controlPointLength: CGFloat = bounds.size.width * 0.5 //squiggle control point length

        let shapeSpacing: CGFloat = bounds.size.width * 0.33
        
        //if number of shapes is 2 or three, move the 'x' positions to the left to make room for the other shapes to draw
        if numberOfShapes == 2 {
            xPositionOfOval = thirdOffsetX
            ovalSize /= 2
            
            diamondStartX = thirdOffsetX
            
            squiggleStartPoints.x = quarterOffsetX
            squiggleEndPoints.x *= 0.75
        }
        else if numberOfShapes == 3 {
            xPositionOfOval = xPositionOfOval / 3
            ovalSize *= 0.50 //change the oval shape to half the size
            
            diamondStartX = thirdOffsetX / 2
            
            squiggleStartPoints.x *= 0.125
            squiggleEndPoints.x = -quarterOffsetY + controlPointLength
            
        }
        
        //draw the shape up to the numberOfShapes, either 1, 2, or 3 shapes.
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
            
            //set color
            color?.setFill()
            color?.setStroke()
            
            
            //fill the shape with alpha value of 0, .5, or 1
            path?.fill(with: .normal, alpha: shadingAlpha)
            
            //stroke shape
            path?.stroke()
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
