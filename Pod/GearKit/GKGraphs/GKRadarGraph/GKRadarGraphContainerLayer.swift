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

//
// TODO: Make all calculations in a background thread and then draw everything in the main thread
//

//
// TODO: Add a circle type as well as a polygon type
//


/// Draw a fully customizable radar graph.  A simple preview is also visible in
/// Interface Builder thanks tot he IBDesignable property.
@IBDesignable
public class GKRadarGraphContainerLayer : CALayer {
    
    //
    // MARK: Inner types
    //
    
    /// Enum to determine what to do in the rendering functions
    private enum PassMode {
        
        /// Auto-adjust the circle radius (no rendering).
        case AUTO_ADJUST
        
        /// Buffer the vertices before rendering.  Draw text at the same time.
        case DRAW_TEXT(CGContextRef)
    }
    
    //
    // MARK: Stored properties
    //
    
    /// Array of parameters to generate the graph.
    public var parameter: [GKRadarGraphView.Parameter] = []
    
    //
    // MARK: IBInspectable stored properties
    //
    
    /// Margin of the chart relative to it's containing view's edge.
    public var margin: CGFloat = 0
    
    /// Margin between the vertices and the text rendering.
    public var textMargin: CGFloat = 3.0
    
    /// Color of the outermost polygon's edges.
    public var outerStrokeColor: UIColor = UIColor.blackColor()
    
    /// Width of the outermost polygon's edges.
    public var outerStrokeWidth: CGFloat = 1.0
    
    /// Color of the inner (gradation) polygons's edges.
    public var gradationStrokeColor: UIColor = UIColor.grayColor()
    
    /// Width of the inner (gradation0 polygons's edges.
    public var gradationStrokeWidth: CGFloat = 1.0
    
    /// Number of gradations (inner polygons) to assign to the chart.
    @IBInspectable
    public var numberOfGradations: Int = 3
    
    /// Override the view's background color to be the background of the graph only.
    internal var graphBackgroundColor: CGColor = UIColor.clearColor().CGColor
    
    override init() {
        super.init()
        
        setNeedsDisplay()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setNeedsDisplay()
    }
    
    //
    // MARK: Private stored properties
    //
    
    /// Center of the graph's circle.  The circle is used to draw the regular polygons inside.
    private var circleCenter: CGPoint = CGPoint(x: 0, y: 0)
    
    /// Radius of the circle.  Will be the full radius for the outer polygon and a smaller
    /// radius for the inner gradations.
    private var circleRadius: CGFloat = 0
}

extension GKRadarGraphContainerLayer {
    
    //
    // MARK: Class variables
    //
    
    /// Vertical offset of the polygon.  -PI/2 insures that
    /// the polygon is always vertically symmetrical.
    private class var VERTICAL_OFFSET: CGFloat {
        return CGFloat(-M_PI_2)
    }
    
    /// Square offset for a polygon.  Make sure that it contains
    /// only lines parallel to the x and y axis.
    private class var SQUARE_OFFSET: CGFloat {
        return CGFloat(M_PI_4)
    }
    
    
    /// Default offset of the polygon.
    /// Override this to rotate your polygon.
    public class var DEFAULT_OFFSET: CGFloat {
        return VERTICAL_OFFSET
    }
    
    /// Margin for auto-adjust
    private var AUTO_ADJUST_MARGIN: CGFloat {
        return 2.0
    }
}

extension GKRadarGraphContainerLayer {
    
    //
    // MARK: Computed properties
    //
    
    /// Value of the exterior angle to have between all the vertices of the regular polygon.
    private var exteriorAngleValue: CGFloat {
        return CGFloat.degreesToRadians(degrees: (360 / CGFloat(parameter.count)))
    }
    
    /// Epsilon to respect for equality of vertex positions.
    private var positionEpsilon: CGFloat {
        return 0.01
    }
}

extension GKRadarGraphContainerLayer {
    
    //
    // MARK: Drawing functions
    //
    
    /// Calculate the outer vertices for the regular polygon.
    ///
    /// - parameter radiusRatio: The percentage of the full radius to use.  1.0 for the outermost polygon.
    private func calculateOuterVertices(rect: CGRect, passmode: PassMode) {
        
        for i in 0..<parameter.count {
            
            let angle: CGFloat = calculateExteriorAngleForVertexIndex(i)
            
            let xPosition = circleCenter.x + (circleRadius * cos(angle))
            let yPosition = circleCenter.y + (circleRadius * sin(angle))
            
            let vertex: CGPoint = CGPoint(x: xPosition, y: yPosition)
            parameter[i].outerVertex = GKRadarGraphView.Parameter.OuterVertex(point: vertex, angle: angle)
            
            let fontColor: UIColor = parameter[i].nameFontColor
            let stringAttributes: NSDictionary = [NSFontAttributeName: parameter[i].nameFont, NSForegroundColorAttributeName: fontColor]
            
            let attributedString: NSAttributedString = NSAttributedString(string: parameter[i].name, attributes: stringAttributes as? [String : AnyObject])
            
            // Get the size of the string
            let stringRect: CGRect = attributedString.boundingRectWithSize(CGSize(width: CGFloat.max, height: CGFloat.max), options: [.UsesLineFragmentOrigin, .UsesFontLeading], context: nil)
            
            // Normally, the drawAtPoint chooses the top left position of the string to draw.
            var adjustedPosition: CGPoint
            
            // For the top and bottom string, we want to center the string horizontally with the vertex.
            if vertex.x.isEqualWithEpsilon(circleCenter.x, epsilon: positionEpsilon) {
                
                if vertex.y < circleCenter.y {
                    
                    // Top position
                    let topLeftX = vertex.x - stringRect.width / 2
                    let topLeftY = vertex.y - (stringRect.height + textMargin + outerStrokeWidth)
                    
                    adjustedPosition = CGPoint(x: topLeftX, y: topLeftY)
                    
                } else {
                    
                    // Bottom position
                    let topLeftX = vertex.x - stringRect.width / 2
                    let topLeftY = vertex.y + textMargin - outerStrokeWidth

                    adjustedPosition = CGPoint(x: topLeftX, y: topLeftY)
                }
                
            } else {
                
                if vertex.x > circleCenter.x {
                    
                    // Right position
                    let topLeftX = vertex.x + textMargin + outerStrokeWidth
                    let topLeftY = vertex.y - stringRect.height / 2
                    
                    adjustedPosition = CGPoint(x: topLeftX, y: topLeftY)
                    
                    
                } else {
                    
                    // Left position
                    let topLeftX = vertex.x - (stringRect.width + textMargin + outerStrokeWidth)
                    let topLeftY = vertex.y - stringRect.height / 2
                    
                    adjustedPosition = CGPoint(x: topLeftX, y: topLeftY)
                }
            }
            
            adjustedPosition.x += parameter[i].textOffset.x
            adjustedPosition.y += parameter[i].textOffset.y
            
            parameter[i].textTopLeftPoint = adjustedPosition
            
            switch(passmode) {
                
            case .AUTO_ADJUST:
                let minimumRadius = calculateMinimumCircleRadius(adjustedPosition, outerVertex: parameter[i].outerVertex!, drawRect: rect, stringRect: stringRect)
                
                circleRadius = min(minimumRadius, minimumRadius)
                
            case .DRAW_TEXT(let context):
                
                self.contentsScale = UIScreen.mainScreen().scale
                
                UIGraphicsPushContext(context)
                attributedString.drawAtPoint(adjustedPosition)
                UIGraphicsPopContext()
            }
        }
    }
    
    /// Auto-calculate the new maximum radius based on the strings.  The radar chart will
    /// always fit in its parent view with this.
    ///
    /// - parameter textTopLeft: Top left corner of the text.
    /// - parameter vertexPosition: Vertex position of the radar chart to which the text should be attached
    /// - parameter drawRect: The rectangle in which the radar chart is drawn.
    /// - parameter stringRect: The rectangle in which the string is rendered.
    /// - parameter angle: Angle of the vertex with respect to the polygon outlying circle.
    ///
    /// - returns: The new maximum radius of the polygon's outlying circle.
    private func calculateMinimumCircleRadius(textTopLeft: CGPoint, outerVertex: GKRadarGraphView.Parameter.OuterVertex, drawRect: CGRect, stringRect: CGRect) -> CGFloat {
        
        var newRadius: CGFloat = circleRadius
        
        let topPositionDifference = textTopLeft.y - AUTO_ADJUST_MARGIN
        let bottomPositionDifference = drawRect.maxY - (textTopLeft.y + stringRect.height + AUTO_ADJUST_MARGIN)
        
        let leftPositionDifference = textTopLeft.x - AUTO_ADJUST_MARGIN
        let rightPositionDifference = drawRect.maxX - (textTopLeft.x + stringRect.width + AUTO_ADJUST_MARGIN)
        
        if topPositionDifference < 0 {
            
            newRadius = ((outerVertex.point.y - topPositionDifference) - circleCenter.y) / sin(outerVertex.angle)
        }
        
        if bottomPositionDifference < 0 {
            
            newRadius = ((outerVertex.point.y + bottomPositionDifference) - circleCenter.y) / sin(outerVertex.angle)
        }
        
        if leftPositionDifference < 0 {
            
            newRadius = ((outerVertex.point.x - leftPositionDifference) - circleCenter.x) / cos(outerVertex.angle)
        }
        
        if rightPositionDifference < 0 {
            
            newRadius = ((outerVertex.point.x + rightPositionDifference) - circleCenter.x) / cos(outerVertex.angle)
        }
        
        return newRadius
    }
    
    /// Calcualte the exterior angle value of a vertex based on its index.
    ///
    /// - parameter vertexIndex: Index of the vertex in the polygon.
    ///
    /// - returns The exterior angle value of the vertex.
    private func calculateExteriorAngleForVertexIndex(vertexIndex: Int) -> CGFloat {
        
        return exteriorAngleValue * CGFloat(vertexIndex) + GKRadarGraphView.DEFAULT_OFFSET
    }
    
    /// Draw the outer polygon.  This draws the outmost edge of the polygon.
    private func drawOuterPolygon(ctx: CGContextRef) {
        
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<parameter.count {
            
            guard let outerVertex = parameter[i].outerVertex?.point else {
                
                continue
            }
            
            if i == 0 {
                
                bezierPath.moveToPoint(outerVertex)
                
            } else {
                
                bezierPath.addLineToPoint(outerVertex)
            }
        }
        
        bezierPath.closePath()
        
        // Save the state

        CGContextAddPath(ctx, bezierPath.CGPath)
        
        CGContextSetFillColorWithColor(ctx, graphBackgroundColor ?? UIColor.clearColor().CGColor)
        CGContextSetStrokeColorWithColor(ctx, outerStrokeColor.CGColor)
        CGContextSetLineWidth(ctx, outerStrokeWidth)
        
        CGContextDrawPath(ctx, .FillStroke)
    }
    
    /// Draw the outer polygon.  This draws the outmost edge of the polygon.
    private func drawGradations(ctx: CGContextRef) {
        
        if let strokeColor: CGColor = gradationStrokeColor.CGColor {
        
            let bezierPath: UIBezierPath = UIBezierPath()
            
            for i in 0..<numberOfGradations {
                
                let radiusRatio: CGFloat = (1.0 / (CGFloat(numberOfGradations) + 1.0)) * CGFloat(i + 1)
                
                for i in 0..<parameter.count {
                    
                    let xPosition = circleCenter.x + (circleRadius * radiusRatio * cos(parameter[i].outerVertex!.angle))
                    let yPosition = circleCenter.y + (circleRadius * radiusRatio * sin(parameter[i].outerVertex!.angle))
                    
                    let vertex: CGPoint = CGPoint(x: xPosition, y: yPosition)
                    
                    if i == 0 {
                        
                        bezierPath.moveToPoint(vertex)
                        
                    } else {
                        
                        bezierPath.addLineToPoint(vertex)
                    }
                }
                
                bezierPath.closePath()
                
                CGContextAddPath(ctx, bezierPath.CGPath)
                CGContextSetFillColorWithColor(ctx, UIColor.clearColor().CGColor)
                CGContextSetStrokeColorWithColor(ctx, strokeColor)
                CGContextSetLineWidth(ctx, gradationStrokeWidth)
                
                CGContextDrawPath(ctx, .FillStroke)
            }
        }
    }
    
    
    public override func drawInContext(ctx: CGContext) {
                
        // Set the center of our polygon.
        circleCenter = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        
        // Estimate the initial circle radius to half of the parent view.
        // This estimate will be correct if there are no text labels.
        circleRadius = min(self.frame.width / 2.0, self.frame.height / 2.0) - margin
        
        // Do a first pass without rendering so that we can adjust the circle radius.
        calculateOuterVertices(self.frame, passmode: .AUTO_ADJUST)
        
        // Do a next pass so we can save the final position and parameters of the vertices.
        calculateOuterVertices(self.frame, passmode: .DRAW_TEXT(ctx))
        
        // Draw the gradations
        drawGradations(ctx)
        
        // Draw outer polygon.
        drawOuterPolygon(ctx)
    }
}

