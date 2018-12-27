//
//  CardView.swift
//  Set
//
//  Created by Andi Maroge on 11/30/18.
//  Copyright © 2018 Andi Maroge. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    //the shape of each card
    public var shape: Card.Shapes? = nil
    //color of card
    var color: UIColor? = nil
    //number of shapes of each card
    var numberOfShapes = 0
    //alpha value of each card
    var shadingAlpha: CGFloat = 0.0
    //whether the card view is selected or not by the user
    var isSelected = false
    //whether the card is face up
    var isFaceUp = false { didSet { setNeedsDisplay(); setNeedsLayout() }}
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    //draw method for the card view class. Draws the card and each shape is brought in by the controller from the model.
    override func draw(_ rect: CGRect) {
        
        if isFaceUp {
            self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.backgroundColor?.setFill()
            UIGraphicsGetCurrentContext()?.fill(rect)
            //variable for the shape that's to be drawn
            var path: UIBezierPath? = nil
            
            //the 'x' position of the Oval shape
            var xPositionOfOval = bounds.size.width / 2,
            ovalSize = bounds.size.height * 0.30 //size of Oval. the size of oval changes as more than one is added
            
            
            ovalSize =  bounds.size.height > bounds.size.width ? bounds.size.width * 0.30 : bounds.size.height * 0.30
            
            //start positions of 'x' and 'y' of the Diamond shape to be drawn
            var diamondStartX = centerOffsetX,
            diamondStartY = quarterOffsetY,
            lineLengthOfDiamond:CGFloat = bounds.size.width * 0.125 //length of the lines of the Diamond
            
            //squiggle Start and End points
            var squiggleStartPoints = CGPoint(x: thirdOffsetX, y: quarterOffsetY),
            squiggleEndPoints = CGPoint(x: thirdOffsetX + quarterOffsetX, y: quarterOffsetY * 3),
            controlPointLength: CGFloat = 75 //squiggle control point length
            
            let shapeSpacing: CGFloat = bounds.size.width * 0.33
            
            //if number of shapes is 2 or three, move the 'x' positions to the left to make room for the other shapes to draw
            if numberOfShapes == 2 {
                xPositionOfOval = thirdOffsetX
                ovalSize /= 2
                
                diamondStartX = thirdOffsetX
                
                squiggleStartPoints.x = quarterOffsetX
                squiggleEndPoints.x = squiggleStartPoints.x + quarterOffsetX
            }
            else if numberOfShapes == 3 {
                xPositionOfOval = xPositionOfOval / 3
                ovalSize *= 0.50 //change the oval shape to half the size
                
                diamondStartX = thirdOffsetX / 2
                
                squiggleStartPoints.x = thirdOffsetX / 6
                squiggleEndPoints.x = squiggleStartPoints.x + quarterOffsetX
            }
            
            //draw the shape up to the numberOfShapes, either 1, 2, or 3 shapes.
            for _ in 1...numberOfShapes {
                switch shape {
                case .Squiggle?:
                    let controlPoint1 = CGPoint(x: squiggleStartPoints.x + controlPointLength, y: quarterOffsetY)
                    let controlPoint2 = CGPoint(x: squiggleEndPoints.x - controlPointLength, y: quarterOffsetY * 3)
                    
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
        else {
            //if the card is not face up, the background color is set and no content is shown
            self.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            self.backgroundColor?.setFill()
            UIGraphicsGetCurrentContext()?.fill(rect)
        }
        
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
