//
//  GKRadarGraphSerieLayer.swift
//  Pods
//
//  Created by Pascal Jette on 3/13/16.
//
//

import Foundation
import UIKit

class GKRadarGraphSerieLayer: CALayer {
    
    internal var containerLayer: GKRadarGraphContainerLayer?
    
    override init() {
        super.init()
        
        needsDisplayOnBoundsChange = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        needsDisplayOnBoundsChange = true
    }
    
    /// Global data source
    internal weak var parameterDatasource: GKRadarGraphParameterDatasource?

    /// Array of parameters to generate the graph.
    private var parameters: [GKRadarGraphView.Parameter] {
        
        return parameterDatasource?.parameters ?? []
    }

    var serie: GKRadarGraphView.Serie?
    
    //
    // MARK: Private stored properties
    //
    
    /// Center of the graph's circle.  The circle is used to draw the regular polygons inside.
    private var circleCenter: CGPoint {
        return parameterDatasource?.circleCenter ?? CGPointZero
    }
    
    /// Radius of the circle.  Will be the full radius for the outer polygon and a smaller
    /// radius for the inner gradations.
    private var circleRadius: CGFloat {
        return parameterDatasource?.circleRadius ?? 0
    }
    
    /// Draw a serie in the radar chart.
    ///
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
        
        
        CGContextAddPath(ctx, bezierPath.CGPath)
        
        if let strokeColorInstance = serie.strokeColor {
            
            CGContextSetStrokeColorWithColor(ctx, strokeColorInstance.CGColor)
            CGContextSetLineWidth(ctx, serie.strokeWidth)
        }
        
        switch serie.fillMode {
            
        case .NONE:
            CGContextDrawPath(ctx, .Stroke)
            
        case .SOLID(let color):
            CGContextSetFillColorWithColor(ctx, color.CGColor)
            CGContextDrawPath(ctx, .FillStroke)
        }
        
    }
    
    /// Draw the vertex decorations (shape or image at each serie's vertex)
    ///
    /// - parameter serie: Serie containing information on how to draw the shape.
    /// - parameter vertex: The vertex on which to draw the shape.  It will act as the circle center.
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
    
    /// Draw a decoration on each of the serie's vertices.
    ///
    /// - parameter serie: The serie for which to draw decorations.
    private func drawSerieVertexDecoration(ctx: CGContext, serie: GKRadarGraphView.Serie) {
        
        guard let decorationInstance = serie.decoration, decorationColor = serie.strokeColor else {
            
            return
        }
        
        for vertex in serie.vertices {
            
            drawVertexDecoration(ctx, decorationType: decorationInstance, decorationColor: decorationColor, decorationCenter: vertex)
        }
    }
    
    internal override func drawInContext(ctx: CGContext) {
        
        if let serieInstance = serie {
            
            drawSerie(ctx, serie: serieInstance)
            
            // Vertex decorations have to be drawn after the serie itself.
            // This is because the decoration have to be drawn on top of
            // the serie itself.
            drawSerieVertexDecoration(ctx, serie: serieInstance)
        }
    }
}