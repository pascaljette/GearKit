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

/// Draw a fully customizable radar graph.  A simple preview is also visible in
/// Interface Builder thanks tot he IBDesignable property.
internal class GKRadarGraphContainerLayer : CALayer {
    
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
    
    /// Global data source
    internal var parameterDatasource: GKRadarGraphParameterDatasource?
    
    /// Array of parameters to generate the graph.  Shortcut to access the datasource.
    private var parameters: [GKRadarGraphView.Parameter] {
        return parameterDatasource?._parameters ?? []
    }
    
    /// Delegate for plot appearance.
    internal var plotApperanceDelegate: GKRadarGraphPlotAppearanceDelegate?

    //
    // MARK: Initialization
    //

    /// Parameterless constructor.
    override internal init() {
        super.init()
        
        // Default is false, meaning the layer is not re-drawn when its bounds change.
        needsDisplayOnBoundsChange = true
    }

    /// Required initializer with coder.
    ///
    /// - param coder The coder used to initialize.
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Default is false, meaning the layer is not re-drawn when its bounds change.
        needsDisplayOnBoundsChange = true
    }
    
    /// Init from another layer.  Needed to implement for layer copy when setNeedsDisplay is called.
    ///
    /// - parameter layer; Layer to copy.
    override init(layer: AnyObject) {
        super.init(layer: layer)
        
        // Default is false, meaning the layer is not re-drawn when its bounds change.
        needsDisplayOnBoundsChange = true
    }
}

extension GKRadarGraphContainerLayer {
    
    //
    // MARK: Computed properties
    //
    
    /// Value of the exterior angle to have between all the vertices of the regular polygon.
    private var exteriorAngleValue: CGFloat {
        return CGFloat.degreesToRadians(degrees: (360 / CGFloat(parameters.count)))
    }
    
    /// Epsilon to respect for equality of vertex positions.
    private var positionEpsilon: CGFloat {
        return 0.01
    }
    
    //
    // MARK: Computed properties (shortcuts)
    //

    /// Margin of the chart relative to it's containing view's edge.
    private var margin: CGFloat {
        return plotApperanceDelegate?._margin
            ?? GKRadarGraphView.MARGIN_DEFAULT
    }
    
    /// Margin between the vertices and the text rendering.
    private var textMargin: CGFloat {
        return plotApperanceDelegate?._textMargin
            ?? GKRadarGraphView.TEXT_MARGIN_DEFAULT
    }
    
    /// Color of the outermost polygon's edges.
    private var outerStrokeColor: UIColor {
        return plotApperanceDelegate?._outerStrokeColor
            ?? GKRadarGraphView.OUTER_STROKE_COLOR_DEFAULT
    }
    
    /// Width of the outermost polygon's edges.
    private var outerStrokeWidth: CGFloat {
        return plotApperanceDelegate?._outerStrokeWidth
            ?? GKRadarGraphView.OUTER_STROKE_WIDTH_DEFAULT
    }
    
    /// Color of the inner (gradation) polygons's edges.
    private var gradationStrokeColor: UIColor {
        return plotApperanceDelegate?._gradationStrokeColor
            ?? GKRadarGraphView.GRADATION_STROKE_COLOR_DEFAULT
    }
    
    /// Width of the inner (gradation0 polygons's edges.
    private var gradationStrokeWidth: CGFloat {
        return plotApperanceDelegate?._gradationStrokeWidth
            ?? GKRadarGraphView.GRADATION_STROKE_WIDTH_DEFAULT
    }
    
    /// Number of gradations (inner polygons) to assign to the chart.
    private var numberOfGradations: Int {
        return plotApperanceDelegate?._numberOfGradations
            ?? GKRadarGraphView.NUMBER_OF_GRADATIONS_DEFAULT
    }
    
    /// Override the view's background color to be the background of the graph only.
    internal var graphBackgroundColor: CGColor {
        return plotApperanceDelegate?._graphBackgroundColor.CGColor
            ?? GKRadarGraphView.GRAPH_BACKGROUND_COLOR_DEFAULT.CGColor
    }
    
    /// Center of the graph's circle.  The circle is used to draw the regular polygons inside.
    private var circleCenter: CGPoint {
        
        get {
            
            return parameterDatasource?._circleCenter ?? CGPointZero
        }
        
        set {
            
            parameterDatasource?._circleCenter = newValue
        }
    }
    
    /// Radius of the circle.  Will be the full radius for the outer polygon and a smaller
    /// radius for the inner gradations.
    private var circleRadius: CGFloat {
        
        get {
            
            return parameterDatasource?._circleRadius ?? 0
        }
        
        set {
            
            parameterDatasource?._circleRadius = newValue
        }
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
        
        for i in 0..<parameters.count {
            
            let angle: CGFloat = calculateExteriorAngleForVertexIndex(i)
            
            let xPosition = circleCenter.x + (circleRadius * cos(angle))
            let yPosition = circleCenter.y + (circleRadius * sin(angle))
            
            let vertex: CGPoint = CGPoint(x: xPosition, y: yPosition)
            parameters[i].outerVertex = GKRadarGraphView.Parameter.OuterVertex(point: vertex, angle: angle)
            
            let fontColor: UIColor = parameters[i].nameFontColor
            let stringAttributes: NSDictionary = [NSFontAttributeName: parameters[i].nameFont, NSForegroundColorAttributeName: fontColor]
            
            let attributedString: NSAttributedString = NSAttributedString(string: parameters[i].name, attributes: stringAttributes as? [String : AnyObject])
            
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
            
            adjustedPosition.x += parameters[i].textOffset.x
            adjustedPosition.y += parameters[i].textOffset.y
            
            parameters[i].textTopLeftPoint = adjustedPosition
            
            switch(passmode) {
                
            case .AUTO_ADJUST:
                let minimumRadius = calculateMinimumCircleRadius(adjustedPosition, outerVertex: parameters[i].outerVertex!, drawRect: rect, stringRect: stringRect)
                
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
                
        let topPositionDifference = textTopLeft.y - GKRadarGraphView.AUTO_ADJUST_MARGIN
        let bottomPositionDifference = drawRect.maxY - (textTopLeft.y + stringRect.height + GKRadarGraphView.AUTO_ADJUST_MARGIN)
        
        let leftPositionDifference = textTopLeft.x - GKRadarGraphView.AUTO_ADJUST_MARGIN
        let rightPositionDifference = drawRect.maxX - (textTopLeft.x + stringRect.width + GKRadarGraphView.AUTO_ADJUST_MARGIN)
        
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
    ///
    /// - parameter ctx: The context in which the gradations are drawn.
    private func drawOuterPolygon(ctx: CGContextRef) {
        
        guard parameters.count > 0 else {
            
            return
        }
        
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<parameters.count {
            
            guard let outerVertex = parameters[i].outerVertex?.point else {
                
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
    ///
    /// - parameter ctx: The context in which the gradations are drawn.
    private func drawGradations(ctx: CGContextRef) {
        
        guard let strokeColor: CGColor = gradationStrokeColor.CGColor else {
            
            return
        }
        
        guard numberOfGradations > 0 && parameters.count > 0 else {
            
            return
        }
        
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<numberOfGradations {
            
            let radiusRatio: CGFloat = (1.0 / (CGFloat(numberOfGradations) + 1.0)) * CGFloat(i + 1)
            
            for i in 0..<parameters.count {
                
                let xPosition = circleCenter.x + (circleRadius * radiusRatio * cos(parameters[i].outerVertex!.angle))
                let yPosition = circleCenter.y + (circleRadius * radiusRatio * sin(parameters[i].outerVertex!.angle))
                
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
    
    /// Draw the layer in the given context.
    ///
    /// - parameter ctx: The context in which to draw the layer.
    override func drawInContext(ctx: CGContext) {
                
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

extension GKRadarGraphContainerLayer {

    //
    // MARK: CALayer overrides
    //

    /// Override set needs display in order to redraw the children layers
    /// when the parent view is changed.
    override func setNeedsDisplay() {
        
        super.setNeedsDisplay()
        
        guard let allSublayers = sublayers else {
            
            return
        }
        
        // For all sublayers (typically series layers), redraw as well.
        for sublayer in allSublayers {
            
            sublayer.setNeedsDisplay()
        }
    }
}

