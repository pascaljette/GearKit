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

/// Layer that draws a serie in the radar graph.
internal class GKRadarGraphSerieDecorationLayer: CALayer {
    
    //
    // MARK: Initialization
    //
    
    /// Parameterless constructor.
    override init() {
        super.init()
        
        // Default is false, meaning the layer is not re-drawn when its bounds change.
        needsDisplayOnBoundsChange = true
    }
    
    /// Required initializer with coder.
    ///
    /// - param coder The coder used to initialize.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Default is false, meaning the layer is not re-drawn when its bounds change.
        needsDisplayOnBoundsChange = true
    }
    
    //
    // MARK: Stored properties
    //
    
    /// Global data source
    var parameterDatasource: GKRadarGraphParameterDatasource?
    
    /// Serie containing the data and draw info for this layer.
    var serie: GKRadarGraphView.Serie?
    
    /// Animation type for the serie
    internal var animationType: GKRadarGraphView.SeriesAnimation = .NONE
}

extension GKRadarGraphSerieDecorationLayer {
    
    //
    // MARK: Computed properties
    //
    
    /// Array of parameters to generate the graph.
    private var parameters: [GKRadarGraphView.Parameter] {
        
        return parameterDatasource?._parameters ?? []
    }
    
    
    /// Center of the graph's circle.  The circle is used to draw the regular polygons inside.
    private var circleCenter: CGPoint {
        return parameterDatasource?._circleCenter ?? CGPointZero
    }
    
    /// Radius of the circle.  Will be the full radius for the outer polygon and a smaller
    /// radius for the inner gradations.
    private var circleRadius: CGFloat {
        return parameterDatasource?._circleRadius ?? 0
    }
}

extension GKRadarGraphSerieDecorationLayer {
    
    //
    // MARK: Drawing functions
    //
    
    /// Draw a decoration on each of the serie's vertices.
    ///
    /// - parameter ctx: The context in which to draw the decorations.
    /// - parameter serie: The serie for which to draw decorations.
    private func drawAllVertexDecorations(ctx: CGContext, serie: GKRadarGraphView.Serie) {
        
        guard let decorationInstance = serie.decoration, decorationColor = serie.strokeColor else {
            
            return
        }
        
        for vertex in serie.vertices {
            
            drawVertexDecoration(ctx, decorationType: decorationInstance, decorationColor: decorationColor, decorationCenter: vertex)
        }
    }
    
    /// Draw the vertex decorations (shape or image at each serie's vertex)
    ///
    /// - parameter ctx: The context in which to draw the decoration.
    /// - parameter decorationType: The decoration type to draw.
    /// - parameter decorationColor: Color used to fill the decoration.
    /// - parameter decorationCenter: It will act as the circle center.
    private func drawVertexDecoration(ctx: CGContext, decorationType: GKRadarGraphView.Serie.DecorationType, decorationColor: UIColor, decorationCenter: CGPoint) {
        
        let bezierPath: UIBezierPath
        
        switch(decorationType) {
            
        case .CIRCLE(let radius):
            bezierPath = UIBezierPath(arcCenter: decorationCenter, radius: radius, startAngle: 0, endAngle: CGFloat(M_2_PI), clockwise: false)
        case .DIAMOND(let radius):
            bezierPath = traceDecorationPolygonBezierPath(4, radius: radius, center: decorationCenter, rotation: GKRadarGraphView.VERTICAL_OFFSET)
        case .SQUARE(let radius):
            bezierPath = traceDecorationPolygonBezierPath(4, radius: radius, center: decorationCenter, rotation: GKRadarGraphView.SQUARE_OFFSET)
        }
        
        bezierPath.closePath()
        bezierPath.lineJoinStyle = .Round
        
        CGContextAddPath(ctx, bezierPath.CGPath)
        CGContextSetFillColorWithColor(ctx, decorationColor.CGColor)
        CGContextDrawPath(ctx, .Fill)
    }
    
    /// Generate the bezier path for the decorations at the bottom of the series vertices.
    ///
    /// - parameter numEdges: Number of edges for the decoration.
    /// - parameter radius: Radius of the decoration's outlying circle.
    /// - parameter center: Center point of the decoration.
    /// - parameter rotation: Rotation of the decoration shape.
    ///
    /// - returns: The unclosed bezier path generated for the given decoration.
    private func traceDecorationPolygonBezierPath(numEdges: Int, radius: CGFloat, center: CGPoint, rotation: CGFloat) -> UIBezierPath {
        
        let angle = CGFloat.degreesToRadians(degrees: (360 / CGFloat(numEdges)))
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<numEdges {
            
            let vertexAngle = angle * CGFloat(i) + rotation
            
            let xPosition = center.x + (radius * cos(vertexAngle))
            let yPosition = center.y + (radius * sin(vertexAngle))
            
            let vertex: CGPoint = CGPoint(x: xPosition, y: yPosition)
            
            if i == 0 {
                
                bezierPath.moveToPoint(vertex)
                
            } else {
                
                bezierPath.addLineToPoint(vertex)
            }
        }
        
        return bezierPath
    }
}

extension GKRadarGraphSerieDecorationLayer {
    
    //
    // MARK: CAAnimation delegate implementation
    //
    
    /// Called when an animation on this layer stops.
    ///
    /// - parameter anim: Instance of the animation that just stopped.
    /// - parameter finished: Whether the animation is finished or was interrupted.
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        
        switch animationType {
            
        case .PARAMETER_BY_PARAMETER:
            break
            
        case .SCALE_ONE_BY_ONE:
            break
            
        case .SCALE_ALL:
            break
            
        case .NONE:
            break
        }
    }
}

extension GKRadarGraphSerieDecorationLayer {
    
    //
    // MARK: CALayer override
    //
    
    /// Draw the layer in the given context.
    ///
    /// - parameter ctx: The context in which to draw the layer.
    internal override func drawInContext(ctx: CGContext) {
        
        if let serieInstance = serie {
            
            // Vertex decorations have to be drawn after the serie itself.
            // This is because the decoration have to be drawn on top of
            // the serie itself.
            drawAllVertexDecorations(ctx, serie: serieInstance)
        }
    }
}

