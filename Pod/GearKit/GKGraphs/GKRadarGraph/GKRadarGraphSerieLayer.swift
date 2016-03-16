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
internal class GKRadarGraphSerieLayer: CALayer {
    
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
    
    /// Scale key used for animation.
    var scale: CGFloat = 1.0
    
    /// A reference on the next layer in the series queue.
    var nextSerieLayer: GKRadarGraphSerieLayer?
}

extension GKRadarGraphSerieLayer {
    
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

extension GKRadarGraphSerieLayer {
    
    //
    // MARK: Drawing functions
    //

    /// Draw a serie in the radar chart.
    ///
    /// - parameter ctx The context in which to draw the serie.
    /// - parameter serie; The serie containing all the info to render.
    private func drawSerie(ctx: CGContext, serie: GKRadarGraphView.Serie) {
        
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<parameters.count {
            
            guard let point = parameters[i].outerVertex?.point else {
                
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
            
            serie.vertices.append(vertex)
            
            if i == 0 {
                
                bezierPath.moveToPoint(vertex)
                
            } else {
                
                bezierPath.addLineToPoint(vertex)
            }
        }
        
        bezierPath.closePath()
        
        guard let strokeColorInstance = serie.strokeColor else {
        
            switch serie.fillMode {
                
            case .NONE:
                break
                
            case .SOLID(let fillColor):
                CGContextAddPath(ctx, bezierPath.CGPath)
                CGContextSetFillColorWithColor(ctx, fillColor.CGColor)
                CGContextDrawPath(ctx, .Fill)
            }
            
            return
        }
        
        CGContextAddPath(ctx, bezierPath.CGPath)
        
        CGContextSetStrokeColorWithColor(ctx, strokeColorInstance.CGColor)
        CGContextSetLineWidth(ctx, serie.strokeWidth)

        switch serie.fillMode {
            
        case .NONE:
            CGContextDrawPath(ctx, .Stroke)
            
        case .SOLID(let color):
            CGContextSetFillColorWithColor(ctx, color.CGColor)
            CGContextDrawPath(ctx, .FillStroke)
        }
    }
    
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
    
    /// Make a scale animation that will grow the serie from nothing to its full scale.
    ///
    /// - parameter duration: Duration of the scale animation.
    ///
    /// - returns: A scale animation that can be applied to the layer using addAnimation.
    internal func makeScaleAnimation(duration: CGFloat) -> CABasicAnimation {
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 1.0
        scaleAnimation.duration = CFTimeInterval(duration)
        scaleAnimation.removedOnCompletion = false
        scaleAnimation.fillMode = kCAFillModeForwards
        scaleAnimation.delegate = self
        scaleAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        return scaleAnimation
    }
    
    /// Called when an animation on this layer stops.
    ///
    /// - parameter anim: Instance of the animation that just stopped.
    /// - parmaeter finished: Whether the animation is finished or was interrupted.
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {

        // If there is a next layer in the series queue.
        if let nextSerieLayerInstance = nextSerieLayer {
            
            // Show the layer.
            nextSerieLayerInstance.hidden = false
            
            // Animate the layer so that the animations are chained from serie to serie.
            // The duration is reused and is therefore the same for all series.
            let scaleAnimation = nextSerieLayerInstance.makeScaleAnimation(CGFloat(anim.duration))
            nextSerieLayerInstance.addAnimation(scaleAnimation, forKey: "scale")
        }
    }
    
    /// Draw the layer in the given context.
    ///
    /// - parameter ctx: The context in which to draw the layer.
    internal override func drawInContext(ctx: CGContext) {
        
        if let serieInstance = serie {
            
            drawSerie(ctx, serie: serieInstance)
            
            // Vertex decorations have to be drawn after the serie itself.
            // This is because the decoration have to be drawn on top of
            // the serie itself.
            drawAllVertexDecorations(ctx, serie: serieInstance)
        }
    }
}