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
        
        /// Empty initializer.
        public init() {
            
        }
        
        /// Fill mode for the serie.
        public var fillMode: FillMode = .SOLID(UIColor.blackColor())
        
        /// Serie's name.
        public var name: String?
        
        /// Stroke color for the serie
        public var strokeColor: UIColor?
        
        /// Stroke width for the serie.
        public var strokeWidth: CGFloat = 1.0
        
        /// Percentage of the max value for each of the serie's attributes.  This must follow
        /// the same order as the owning graph parameters.
        public var percentageValues: [CGFloat] = []
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
        
        /// Offset of where to render the text.
        public var textOffset: CGPoint = CGPoint(x: 0, y: 0)
        
        /// Point where the spoke is located on the graph.
        private var point: CGPoint?
    }
    
    /// Function to execute when adding a vertex to a polygon.
    private typealias OnAddVertex = (CGPoint, Parameter) -> Void
    
    //
    // MARK: Stored properties
    //
    
    /// Array of parameters to generate the graph.
    public var parameter: [Parameter] = []
    
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
    public var outerStrokeWidth: CGFloat = 1.0

    /// Color of the inner (gradation) polygons's edges.
    @IBInspectable
    public var gradationStrokeColor: UIColor = UIColor.grayColor()
    
    /// Width of the inner (gradation0 polygons's edges.
    @IBInspectable
    public var gradationStrokeWidth: CGFloat = 1.0
    
    /// Maximum value of the chart's parameters
    @IBInspectable
    public var maxValue: CGFloat = 100
    
    /// Number of gradations (inner polygons) to assign to the chart.
    @IBInspectable
    public var numberOfGradations: Int = 3
    
    
    //
    // MARK: Private stored properties
    //
    
    /// Center of the graph's circle.  The circle is used to draw the regular polygons inside.
    private var circleCenter: CGPoint = CGPoint(x: 0, y: 0)
    
    /// Radius of the circle.  Will be the full radius for the outer polygon and a smaller
    /// radius for the inner gradations.
    private var circleRadius: CGFloat = 0

    /// Used to override UIView's background color property.
    private var _backgroundColor: UIColor?
}

extension GKRadarGraphView {

    //
    // MARK: Class variables
    //

    /// Default offset of the polygon.  -PI/2 insures that
    /// the polygon is always vertically symmetrical.
    /// Override this to rotate your polygon.
    public class var DEFAULT_OFFSET: CGFloat {
        return CGFloat(-M_PI_2)
    }
    
    /// Margin for auto-adjust
    private var AUTO_ADJUST_MARGIN: CGFloat {
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
    // MARK: UIView overrides
    //
    override public var backgroundColor: UIColor? {
        
        get {
            
            return _backgroundColor
        }
        
        set {
            
            super.backgroundColor = UIColor.clearColor()
            _backgroundColor = newValue
        }
    }
}

extension GKRadarGraphView {
    
    //
    // MARK: Drawing functions
    //
    
    /// Calculate the outer vertices for the regular polygon.
    ///
    /// - parameter radiusRatio: The percentage of the full radius to use.  1.0 for the outermost polygon.
    private func calculateOuterVertices(radiusRatio: CGFloat = 1.0,
        rect: CGRect) {
        
        var adjustedCircleRadius: CGFloat = circleRadius
        
        for i in 0..<parameter.count {
            
            let angle: CGFloat = exteriorAngleValue * CGFloat(i) + GKRadarGraphView.DEFAULT_OFFSET
            
            let xPosition = circleCenter.x + (circleRadius * radiusRatio) * cos(angle)
            let yPosition = circleCenter.y + (circleRadius * radiusRatio) * sin(angle)
            
            let vertex: CGPoint = CGPoint(x: xPosition, y: yPosition)
            parameter[i].point = vertex
            
            let font = UIFont.systemFontOfSize(14.0)
            let stringAttributes: NSDictionary = [NSFontAttributeName: font]
            
            let attributedString: NSAttributedString = NSAttributedString(string: parameter[i].name, attributes: stringAttributes as? [String : AnyObject])
            
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
                    
                    let topLeftX = vertex.x + textMargin
                    let topLeftY = vertex.y - stringRect.height / 2
                    
                    // Right position
                    adjustedPosition = CGPoint(x: topLeftX, y: topLeftY)
                    
                    
                } else {
                    
                    // Left position
                    adjustedPosition = CGPoint(x: vertex.x - (stringRect.width + textMargin), y: vertex.y - stringRect.height / 2)
                }
            }
            
            adjustedPosition.x += parameter[i].textOffset.x
            adjustedPosition.y += parameter[i].textOffset.y
            
            let minimumRadius = calculateMinimumCircleRadius(adjustedPosition, vertexPosition: vertex, drawRect: rect, stringRect: stringRect, angle: angle)
            
            adjustedCircleRadius = min(adjustedCircleRadius, minimumRadius)
        }
        
        circleRadius = adjustedCircleRadius
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
    private func calculateMinimumCircleRadius(textTopLeft: CGPoint, vertexPosition: CGPoint, drawRect: CGRect, stringRect: CGRect, angle: CGFloat) -> CGFloat {
        
        var newRadius: CGFloat = circleRadius
        
        let topPositionDifference = textTopLeft.y - AUTO_ADJUST_MARGIN
        let bottomPositionDifference = drawRect.maxY - (textTopLeft.y + stringRect.height + AUTO_ADJUST_MARGIN)
        
        let leftPositionDifference = textTopLeft.x - AUTO_ADJUST_MARGIN
        let rightPositionDifference = drawRect.maxX - (textTopLeft.x + stringRect.width + AUTO_ADJUST_MARGIN)
        
        if topPositionDifference < 0 {
         
            newRadius = ((vertexPosition.y - topPositionDifference) - circleCenter.y) / sin(angle)
        }
        
        if bottomPositionDifference < 0 {
            
            newRadius = ((vertexPosition.y + bottomPositionDifference) - circleCenter.y) / sin(angle)
        }
        
        if leftPositionDifference < 0 {
            
            newRadius = ((vertexPosition.x - leftPositionDifference) - circleCenter.x) / cos(angle)
        }
        
        if rightPositionDifference < 0 {
            
            newRadius = ((vertexPosition.x + rightPositionDifference) - circleCenter.x) / cos(angle)
        }
        
        return newRadius
    }
    
    /// Draw the outer polygon.  This draws the outmost edge of the polygon as well as
    /// the inner gradations.
    ///
    ///
    /// - parameter radiusRatio: The percentage of the full radius to use.  1.0 for the outermost polygon.
    /// - parameter fillColor: Color to use when filling the polygon.
    /// - parameter strokeColor: The color used for the polygon's strokes (edges).
    /// - parameter strokeWidth: The width of the polygon's stroked (edges).
    private func drawOuterPolygon(radiusRatio: CGFloat = 1.0
        , fillColor: UIColor?
        , strokeColor: UIColor?
        , strokeWidth: CGFloat
        , onAddVertex: OnAddVertex? = nil) {
            
            let bezierPath: UIBezierPath = UIBezierPath()
            
            for i in 0..<parameter.count {
                
                let xPosition = circleCenter.x + (circleRadius * radiusRatio) * cos(exteriorAngleValue * CGFloat(i) + GKRadarGraphView.DEFAULT_OFFSET)
                let yPosition = circleCenter.y + (circleRadius * radiusRatio) * sin(exteriorAngleValue * CGFloat(i) + GKRadarGraphView.DEFAULT_OFFSET)
                
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
    
    /// Calculate the bezier path for a given serie to render in the radar chart.
    ///
    /// - parameter serie: The serie info to render.
    ///
    /// - returns: The generated bezier path.
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
    
    /// Draw a serie in the radar chart.
    ///
    /// - parameter serie; The serie containing all the info to render.
    private func drawSerie(serie: Serie) {
        
        let bezierPath = serieBezierPath(serie)
        
        bezierPath.addClip()
        
        //　 Add gradient to the series
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
    
    /// Draw the text on the spokes of the radar chart.
    ///
    /// - parameter rect: The rectangle in which the UIView is to be rendered.
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
    
    /// Called with the UIView requires new rendering.
    ///
    /// - parameter rect: The rectangle in which the UIView is to be rendered.
    override public func drawRect(rect: CGRect) {
        
        circleCenter = CGPoint(x: rect.midX, y: rect.midY)
        circleRadius = min(rect.width / 2.0, rect.height / 2.0) - margin
        
        calculateOuterVertices(rect: rect)
        
        // draw outer polygon
        drawOuterPolygon(fillColor: backgroundColor
            , strokeColor: outerStrokeColor
            , strokeWidth: outerStrokeWidth
            , onAddVertex: { point, parameter in
                
                parameter.point = point
        })
        
        for i in 0..<numberOfGradations {
            
            let radiusRatio: CGFloat = (1.0 / (CGFloat(numberOfGradations) + 1.0)) * CGFloat(i + 1)
            drawOuterPolygon(radiusRatio
                , fillColor: nil
                , strokeColor: gradationStrokeColor
                , strokeWidth: gradationStrokeWidth)
        }
        
        drawText(rect)
        
        // Draw values
        for serie in series {
            
            drawSerie(serie)
        }
    }
}

extension GKRadarGraphView {
    
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
        firstSerie.strokeColor = UIColor.blackColor()
        firstSerie.strokeWidth = 4.0

        let fillColor: UIColor = UIColor.blueColor()
        
        firstSerie.fillMode = .SOLID(fillColor)
        
        firstSerie.percentageValues = [0.9, 0.5, 0.6, 0.2, 0.9]
        
        self.margin = 0
        self.series = [firstSerie]
    }
}
