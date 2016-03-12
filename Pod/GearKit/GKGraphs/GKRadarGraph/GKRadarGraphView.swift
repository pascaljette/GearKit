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
public class GKRadarGraphView : UIView {
    
    //
    // MARK: Inner types
    //
    
    /// A serie in the graph.  This represents the actual data.
    public class Serie {
        
        /// Fill mode for the serie.  Can be either filled or not.
        public enum FillMode {
            
            /// Fill the Serie with the provided UIColor
            case SOLID(UIColor)
            
            /// The Serie will not be filled.
            case NONE
        }
        
        /// Type for decorations on each vertex of the serie
        public enum DecorationType {
            
            /// Square shape.  Takes the shape radius as a parameter.
            case SQUARE(CGFloat)
            
            /// Diamond shape (square rotated 45 degrees). Takes the shape radius as a parameter.
            case DIAMOND(CGFloat)
            
            /// Circle shape. Takes the shape radius as a parameter.
            case CIRCLE(CGFloat)
        }
        
        /// Empty initializer.
        public init() {
            
        }
        
        /// Fill mode for the serie.
        public var fillMode: FillMode = .SOLID(UIColor.blackColor())
        
        /// Serie's name.
        public var name: String?
        
        /// Stroke color for the serie.  Also controls the color of the vertex decorations.
        public var strokeColor: UIColor?
        
        /// Stroke width for the serie.
        public var strokeWidth: CGFloat = 1.0
        
        /// Percentage of the max value for each of the serie's attributes.  This must follow
        /// the same order as the owning graph parameters.
        public var percentageValues: [CGFloat] = []
        
        /// Decoration to put on each of the serie's vertices.
        public var decoration: DecorationType?
        
        /// Array of verties for that serie
        private var vertices: [CGPoint] = []
    }
    
    /// Parameter for the Radar Graph View.  A parameter correspondes to a spoke
    /// in radar chart language.
    public class Parameter {
        
        /// Empty initializer.
        public init() {
            
        }
        
        /// Initialize with a name.
        ///
        /// - parameter name: Name of the parameter.  This will be rendered as text.
        public init(name: String) {
            
            self.name = name
        }
        
        /// Initialize with a name.
        ///
        /// - parameter name: Name of the parameter.  This will be rendered as text.
        /// - parameter nameOffset: Offset of where to render the name, relative to the spoke to which
        /// it is associated.
        public init(name: String, nameOffset: CGPoint) {
            
            self.name = name
            self.textOffset = nameOffset
        }

        /// Name of the parameter.  Will be rendered next to its spoke
        public var name: String = ""
        
        /// Font for the name label in the graph
        public var nameFont: UIFont = UIFont.systemFontOfSize(14)
        
        /// Font for the name label in the graph
        public var nameFontColor: UIColor = UIColor.blackColor()
        
        /// Offset of where to render the text.
        public var textOffset: CGPoint = CGPoint(x: 0, y: 0)
        
        /// Location of the outer vertex
        internal class OuterVertex {
            
            /// Initialize with a point and angle.
            ///
            /// - parameter point: The point where the vertex is located.
            /// - parameter angle: The angle with respect to the polygon's outlying circle.
            init(point: CGPoint, angle: CGFloat) {
                
                self.point = point
                self.angle = angle
            }
            
            /// Point where the vertex is located.
            var point: CGPoint
            
            /// Angle with respect to the polygon's outlying circle.
            var angle: CGFloat = 0
        }
        
        /// Point where the spoke is located on the graph.
        internal var outerVertex: OuterVertex?
        
        /// Point of the top left of the text label
        internal var textTopLeftPoint: CGPoint?
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        containerLayer.contentsScale = self.layer.contentsScale
        containerLayer.backgroundColor = backgroundColor?.CGColor
        self.layer.addSublayer(containerLayer)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        containerLayer.contentsScale = self.layer.contentsScale
        containerLayer.backgroundColor = backgroundColor?.CGColor
        self.layer.addSublayer(containerLayer)
    }
    
    //
    // MARK: Stored properties
    //
    
    /// Array of parameters to generate the graph.
    public var parameter: [Parameter] = [] {
        
        didSet {
            
            containerLayer.parameter = parameter
        }
    }
    
    private var containerLayer = GKRadarGraphContainerLayer()
    
    /// Array of series populating the graph's data.
    public var series: [Serie] = []
    
    //
    // MARK: IBInspectable stored properties
    //
    
    /// Margin of the chart relative to it's containing view's edge.
    @IBInspectable
    public var margin: CGFloat = 0
    
    /// Margin between the vertices and the text rendering.
    @IBInspectable
    public var textMargin: CGFloat = 3.0
    
    /// Color of the outermost polygon's edges.
    @IBInspectable
    public var outerStrokeColor: UIColor = UIColor.blackColor()
    
    /// Width of the outermost polygon's edges.
    @IBInspectable
    public var outerStrokeWidth: CGFloat = 1.0 {
        
        didSet {
            
            containerLayer.outerStrokeWidth = outerStrokeWidth
        }
    }

    /// Color of the inner (gradation) polygons's edges.
    @IBInspectable
    public var gradationStrokeColor: UIColor = UIColor.grayColor()
    
    /// Width of the inner (gradation0 polygons's edges.
    @IBInspectable
    public var gradationStrokeWidth: CGFloat = 1.0
    
    /// Number of gradations (inner polygons) to assign to the chart.
    @IBInspectable
    public var numberOfGradations: Int = 3
    
    @IBInspectable
    public var graphBackgroundColor: UIColor = UIColor.clearColor() {
        
        didSet {
            
            containerLayer.graphBackgroundColor = graphBackgroundColor.CGColor
        }
    }
    //
    // MARK: Private stored properties
    //
    
    /// Center of the graph's circle.  The circle is used to draw the regular polygons inside.
    internal var circleCenter: CGPoint = CGPoint(x: 0, y: 0)
    
    /// Radius of the circle.  Will be the full radius for the outer polygon and a smaller
    /// radius for the inner gradations.
    internal var circleRadius: CGFloat = 0
}

extension GKRadarGraphView {

    //
    // MARK: Class variables
    //

    /// Vertical offset of the polygon.  -PI/2 insures that
    /// the polygon is always vertically symmetrical.
    internal class var VERTICAL_OFFSET: CGFloat {
        return CGFloat(-M_PI_2)
    }
    
    /// Square offset for a polygon.  Make sure that it contains
    /// only lines parallel to the x and y axis.
    internal class var SQUARE_OFFSET: CGFloat {
        return CGFloat(M_PI_4)
    }

    
    /// Default offset of the polygon.
    /// Override this to rotate your polygon.
    public class var DEFAULT_OFFSET: CGFloat {
        return VERTICAL_OFFSET
    }
    
    /// Margin for auto-adjust
    internal var AUTO_ADJUST_MARGIN: CGFloat {
        return 2.0
    }
}

extension GKRadarGraphView {
    
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

extension GKRadarGraphView {
    
    //
    // MARK: Drawing functions
    //
    
    /// Draw a serie in the radar chart.
    ///
    /// - parameter serie; The serie containing all the info to render.
    private func drawSerie(serie: Serie) {
        
        let bezierPath: UIBezierPath = UIBezierPath()
        
        for i in 0..<parameter.count {
            
            guard let point = parameter[i].outerVertex?.point else {
                
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
        
        switch serie.fillMode {
            
        case .NONE:
            break
            
        case .SOLID(let color):
            color.setFill()
            bezierPath.fill()
            
        }
        
        if let strokeColor: UIColor = serie.strokeColor {
            
            strokeColor.setStroke()
            bezierPath.lineWidth = serie.strokeWidth
            bezierPath.stroke()
        }
    }
    
    /// Draw the vertex decorations (shape or image at each serie's vertex)
    ///
    /// - parameter serie: Serie containing information on how to draw the shape.
    /// - parameter vertex: The vertex on which to draw the shape.  It will act as the circle center.
    private func drawVertexDecoration(decorationType: Serie.DecorationType, decorationColor: UIColor, decorationCenter: CGPoint) {
        
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
        
        decorationColor.setFill()
        bezierPath.fill()
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
    private func drawSerieVertexDecoration(serie: Serie) {
        
        guard let decorationInstance = serie.decoration, decorationColor = serie.strokeColor else {
            
            return
        }
        
        for vertex in serie.vertices {
            
            drawVertexDecoration(decorationInstance, decorationColor: decorationColor, decorationCenter: vertex)
        }
    }
    
    /// Called with the UIView requires new rendering.
    ///
    /// - parameter rect: The rectangle in which the UIView is to be rendered.
//    override public func drawRect(rect: CGRect) {
//        
//        super.drawRect(rect)
//        // Set the center of our polygon.
//        circleCenter = CGPoint(x: rect.midX, y: rect.midY)
//        
//        // Estimate the initial circle radius to half of the parent view.
//        // This estimate will be correct if there are no text labels.
//        circleRadius = min(rect.width / 2.0, rect.height / 2.0) - margin
//        
//        print(rect)
//        
//        // Draw values
//        for serie in series {
//            
//            drawSerie(serie)
//            
//            // Vertex decorations have to be drawn after the serie itself.
//            // This is because the decoration have to be drawn on top of
//            // the serie itself.
//            drawSerieVertexDecoration(serie)
//        }
//    }
}

extension GKRadarGraphView {
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Layers do not auto-resize!
        containerLayer.frame = self.bounds
    }
    
    //
    // MARK: IBDesignable implementation
    //

    /// This function is executed only when rendering the view in interface builder.
    /// It is used only to give a preview of the class.
    override public func prepareForInterfaceBuilder() {
        
        let hpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Param 1")
        let mpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Param 2")
        let strengthParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Param 3")
        let defenseParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Param 4")
        let magicParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Param 5")
        
        self.parameter = [hpParameter, mpParameter, strengthParameter, defenseParameter, magicParameter]

        // We only support gradients for a single serie radar graph
        let firstSerie = GKRadarGraphView.Serie()
        firstSerie.strokeColor = UIColor.blueColor()
        firstSerie.strokeWidth = 4.0
        let firstFillColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.7, alpha: 0.7)
        
        firstSerie.fillMode = .SOLID(firstFillColor)
        firstSerie.percentageValues = [0.9, 0.5, 0.6, 0.2, 0.9]
        firstSerie.decoration = .SQUARE(8.0)
        
        let secondSerie = GKRadarGraphView.Serie()
        secondSerie.strokeColor = UIColor.greenColor()
        secondSerie.strokeWidth = 4.0
        let secondFillColor: UIColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 0.7)
        
        secondSerie.fillMode = .SOLID(secondFillColor)
        secondSerie.percentageValues = [0.9, 0.1, 0.2, 0.9, 0.3]
        secondSerie.decoration = .CIRCLE(6.0)

        let thirdSerie = GKRadarGraphView.Serie()
        thirdSerie.strokeColor = UIColor.redColor()
        thirdSerie.strokeWidth = 4.0
        let thirdSerieFillColor: UIColor = UIColor(red: 0.7, green: 0.1, blue: 0.1, alpha: 0.7)
        
        thirdSerie.fillMode = .SOLID(thirdSerieFillColor)
        thirdSerie.percentageValues = [0.5, 0.9, 0.5, 0.5, 0.6]
        thirdSerie.decoration = .DIAMOND(8.0)
        
        self.series = [firstSerie, secondSerie, thirdSerie]
    }
}
