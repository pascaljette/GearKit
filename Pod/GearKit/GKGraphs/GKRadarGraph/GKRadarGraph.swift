// The MIT License (MIT)
//
// Copyright (c) 2015 pascaljette
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation
import UIKit

public class GKRadarGraphView : UIView {
    
    public class Serie {
        
        public enum FillMode {
            
            case SOLID(UIColor)
            case GRADIENT(UIColor, UIColor)
        }
        
        public init() {
            
        }
        
        public var fillMode: FillMode = .SOLID(UIColor.blackColor())
        public var name: String?
        public var strokeColor: UIColor?
        
        public var percentageValues: [CGFloat] = []
    }
    
    public class Parameter {
        
        public init() {
            
        }
        
        public init(name: String) {
            
            self.name = name
        }
        
        public init(name: String, nameOffset: CGPoint) {
            
            self.name = name
            self.textOffset = nameOffset
        }

        public var name: String = ""
        public var textOffset: CGPoint = CGPoint(x: 0, y: 0)
        
        private var point: CGPoint?
    }
    
    public class var MINIMUM_RADIUS: CGFloat {
        return 20
    }
    
    public class var DEFAULT_OFFSET: CGFloat {
        return CGFloat(-M_PI_2)
    }
    
    public var parameter: [Parameter] = []
    public var series: [Serie] = []
    
    // Space between the UIView delimitation and the outer limit of the spider graph.
    
    public var margin: CGFloat = 10
    public var textMargin: CGFloat = 3.0
    
    public var strokeColor: UIColor = UIColor.blackColor()
    
    public var maxValue: CGFloat = 100
    public var numberOfGradations: Int = 3
    
    private typealias OnAddVertex = (CGPoint, Parameter) -> Void
    
    private var circleCenter: CGPoint = CGPoint(x: 0, y: 0)
    private var circleRadius: CGFloat = 0
    
    private var angle: CGFloat {
        return CGFloat.degreesToRadians(degrees: (360 / CGFloat(parameter.count)))
    }
    
    private func drawOuterPolygon(radiusRatio: CGFloat = 1.0
        , fillColor: UIColor?
        , strokeColor: UIColor?
        , onAddVertex: OnAddVertex? = nil) {
            
            let bezierPath: UIBezierPath = UIBezierPath()
            
            for i in 0..<parameter.count {
                
                let xPosition = circleCenter.x + (circleRadius * radiusRatio) * cos(angle * CGFloat(i) + GKRadarGraphView.DEFAULT_OFFSET)
                let yPosition = circleCenter.y + (circleRadius * radiusRatio) * sin(angle * CGFloat(i) + GKRadarGraphView.DEFAULT_OFFSET)
                
                let vertex: CGPoint = CGPoint(x: xPosition, y: yPosition)
                onAddVertex?(vertex, parameter[i])
                
                if i == 0 {
                    
                    bezierPath.moveToPoint(vertex)
                    
                } else {
                    
                    bezierPath.addLineToPoint(vertex)
                }
            }
            
            bezierPath.closePath()
            
            if let fillColor: UIColor = fillColor {
                
                fillColor.setFill()
                bezierPath.fill()
            }
            
            if let stokeColor: UIColor = strokeColor {
                
                stokeColor.setStroke()
                bezierPath.stroke()
            }
    }
    
    private func serieBezierPath(serie: Serie) -> UIBezierPath {
        
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<parameter.count {
            
            guard let point = parameter[i].point else {
                
                continue
            }
            
            let differenceX = point.x - circleCenter.x
            let differenceY = point.y - circleCenter.y
            
            // scalar multiplication
            let scalarMultiplier = serie.percentageValues.count > i
                ? serie.percentageValues[i]
                : 0
            
            let pointX = circleCenter.x + (differenceX * scalarMultiplier)
            let pointY = circleCenter.y + (differenceY * scalarMultiplier)
            
            let vertex: CGPoint = CGPoint(x: pointX, y: pointY)
            
            if i == 0 {
                
                bezierPath.moveToPoint(vertex)
                
            } else {
                
                bezierPath.addLineToPoint(vertex)
            }
        }
        
        bezierPath.closePath()

        return bezierPath
    }
    
    private func drawSerie(serie: Serie) {
        
        let bezierPath = serieBezierPath(serie)

        
        bezierPath.addClip()
        
        //　 Add gradient to the series
        let context = UIGraphicsGetCurrentContext()
        
        switch serie.fillMode {
            
        case .SOLID(let color):
            color.setFill()
            bezierPath.fill()
            
        case .GRADIENT(let startColor, let endColor):
            
            let gradLocationsNum = 2
            let gradLocations: [CGFloat] = [0.0, 0.6]
            
            var startRed: CGFloat = 0
            var startGreen: CGFloat = 0
            var startBlue: CGFloat = 0
            var startAlpha: CGFloat = 0
            
            var endRed: CGFloat = 0
            var endGreen: CGFloat = 0
            var endBlue: CGFloat = 0
            var endAlpha: CGFloat = 0

            startColor.getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
            endColor.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)
            
            let gradColors: [CGFloat] = [
                startRed, startGreen, startBlue, startAlpha,
                endRed, endGreen, endBlue, endAlpha]
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            
            let gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum)
            
            CGContextDrawRadialGradient (context, gradient, circleCenter, 0, circleCenter, circleRadius, CGGradientDrawingOptions.DrawsBeforeStartLocation)
        }
        
        if let strokeColor: UIColor = serie.strokeColor {
            
            strokeColor.setStroke()
            bezierPath.stroke()
        }
    }
    
    private var positionEpsilon: CGFloat {
        
        return 0.01
    }
    
    private func drawText(rect: CGRect) {
        
        // Add text
        for parameterInstance in self.parameter {
            
            guard let vertex = parameterInstance.point else {
                
                continue
            }
            
            let font = UIFont.systemFontOfSize(14.0)
            let fontColor: UIColor = UIColor.blackColor()
            let stringAttributes: NSDictionary = [NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor ]
            
            let attributedString: NSAttributedString = NSAttributedString(string: parameterInstance.name, attributes: stringAttributes as? [String : AnyObject])
            
            // Get the size of the string
            let stringRect: CGRect = attributedString.boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)
            
            // Normally, the drawAtPoint chooses the top left position of the string to draw.
            
            var adjustedPosition: CGPoint
            
            // For the top and bottom string, we want to center the string horizontally with the vertex.
            if vertex.x.isEqualWithEpsilon(circleCenter.x, epsilon: positionEpsilon) {
                
                if vertex.y < circleCenter.y {
                    
                    // Top position
                    adjustedPosition = CGPoint(x: vertex.x - stringRect.width / 2, y: vertex.y - (stringRect.height + textMargin))
                
                } else {
                    
                    // Bottom position
                    adjustedPosition = CGPoint(x: vertex.x - stringRect.width / 2, y: vertex.y + textMargin)
                }
            
            } else {
                
                if vertex.x > circleCenter.x {
                    
                    // Right position
                    adjustedPosition = CGPoint(x: vertex.x + textMargin, y: vertex.y - stringRect.height / 2)

                } else {
                    
                    // Left position
                    adjustedPosition = CGPoint(x: vertex.x - (stringRect.width + textMargin), y: vertex.y - stringRect.height / 2)
                }
            }
            
            adjustedPosition.x += parameterInstance.textOffset.x
            adjustedPosition.y += parameterInstance.textOffset.y
            
            attributedString.drawAtPoint(adjustedPosition)
            
        }
    }
    
    override public func drawRect(rect: CGRect) {
        
        circleCenter = CGPoint(x: rect.midX, y: rect.midY)
        circleRadius = min(rect.width / 2.0, rect.height / 2.0) - margin

        // draw outer polygon
        drawOuterPolygon(fillColor: UIColor.lightGrayColor()
            , strokeColor: UIColor.blackColor()
            , onAddVertex: { point, parameter in
        
                parameter.point = point
        })
        
        for i in 0..<numberOfGradations {
            
            let radiusRatio: CGFloat = (1.0 / (CGFloat(numberOfGradations) + 1.0)) * CGFloat(i + 1)
            drawOuterPolygon(radiusRatio, fillColor: nil, strokeColor: UIColor.darkGrayColor())
        }
        
        drawText(rect)
        
        // Draw values
        for serie in series {
            
            drawSerie(serie)
        }
    }

    // For IBDesignable
    override public func prepareForInterfaceBuilder() {
        
    }
}
