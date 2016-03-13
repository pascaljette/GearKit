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
        internal var vertices: [CGPoint] = []
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
        containerLayer.parameterDatasource = self.parameterDatasource
        containerLayer.plotApperanceDelegate = self.plotApperanceDelegate
        
        self.layer.addSublayer(containerLayer)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        containerLayer.contentsScale = self.layer.contentsScale
        containerLayer.backgroundColor = backgroundColor?.CGColor
        containerLayer.parameterDatasource = self.parameterDatasource
        containerLayer.plotApperanceDelegate = self.plotApperanceDelegate

        self.layer.addSublayer(containerLayer)
    }
    
    //
    // MARK: Stored properties
    //
    
    /// Array of parameters to generate the graph.
    public var parameter: [Parameter] {
        
        get {
            
            return parameterDatasource.parameters
        }
        
        set {
            
            parameterDatasource.parameters = newValue
        }
    }
    
    private var containerLayer = GKRadarGraphContainerLayer()
    internal var parameterDatasource: GKRadarGraphParameterDatasource = GKRadarGraphParameterDatasource()

    internal var plotApperanceDelegate: GKRadarGraphPlotAppearanceDelegate = GKRadarGraphPlotAppearanceDelegate()
    
    /// Array of series populating the graph's data.
    public var series: [Serie] = [] {
        
        didSet {
            
            let difference = series.count - (containerLayer.sublayers?.count ?? 0)
            
            // Adjust number of slices
            if (difference > 0) {
                
                for _: Int in 0..<difference {
                    
                    let serieLayer = GKRadarGraphSerieLayer()
                    serieLayer.frame = self.bounds;
                    
                    containerLayer.addSublayer(serieLayer)
                }
            }
            else if (difference < 0) {
                
                for _: Int in 0..<abs(difference) {
                
                    containerLayer.sublayers?.removeAtIndex(0)
                }
            }
            
            // Set the serie on each slice
            for i: Int in 0..<series.count {
                
                let singleSerie = series[i]
                
                if let sublayerInstance = containerLayer.sublayers?[i] as? GKRadarGraphSerieLayer {
                    
                    sublayerInstance.containerLayer = containerLayer
                    sublayerInstance.serie = singleSerie
                    sublayerInstance.parameterDatasource = self.parameterDatasource
                }
            }
        }
    }
    
    //
    // MARK: IBInspectable stored properties
    //
    
    //
    // NOTE: IBInspectable properties cannot be computed properties.  Therefore, we need
    // to keep both a copy in the plot appearance delegate and here.
    //
    
    /// Margin of the chart relative to it's containing view's edge.
    @IBInspectable
    public var margin: CGFloat = GKRadarGraphPlotAppearanceDelegate.MARGIN_DEFAULT {
        didSet {
            plotApperanceDelegate.margin = margin
        }
    }
    
    /// Margin between the vertices and the text rendering.
    @IBInspectable
    public var textMargin: CGFloat = GKRadarGraphPlotAppearanceDelegate.TEXT_MARGIN_DEFAULT {
        didSet {
            plotApperanceDelegate.textMargin = textMargin
        }
    }
    
    /// Color of the outermost polygon's edges.
    @IBInspectable
    public var outerStrokeColor: UIColor = GKRadarGraphPlotAppearanceDelegate.OUTER_STROKE_COLOR_DEFAULT {
        didSet {
            plotApperanceDelegate.outerStrokeColor = outerStrokeColor
        }
    }
    
    /// Width of the outermost polygon's edges.
    @IBInspectable
    public var outerStrokeWidth: CGFloat = GKRadarGraphPlotAppearanceDelegate.OUTER_STROKE_WIDTH_DEFAULT {
        didSet {
            plotApperanceDelegate.outerStrokeWidth = outerStrokeWidth
        }
    }

    /// Color of the inner (gradation) polygons's edges.
    @IBInspectable
    public var gradationStrokeColor: UIColor = GKRadarGraphPlotAppearanceDelegate.GRADATION_STROKE_COLOR_DEFAULT
    
    /// Width of the inner (gradation0 polygons's edges.
    @IBInspectable
    public var gradationStrokeWidth: CGFloat = GKRadarGraphPlotAppearanceDelegate.GRADATION_STROKE_WIDTH_DEFAULT
    
    /// Number of gradations (inner polygons) to assign to the chart.
    @IBInspectable
    public var numberOfGradations: Int = GKRadarGraphPlotAppearanceDelegate.NUMBER_OF_GRADATIONS_DEFAULT {
        
        didSet {
            plotApperanceDelegate.numberOfGradations = numberOfGradations
        }
    }
    
    @IBInspectable
    public var graphBackgroundColor: UIColor = UIColor.clearColor() {
        didSet {
            plotApperanceDelegate.graphBackgroundColor = graphBackgroundColor
        }
    }
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
    internal class var DEFAULT_OFFSET: CGFloat {
        return VERTICAL_OFFSET
    }
    
    /// Margin for auto-adjust
    internal class var AUTO_ADJUST_MARGIN: CGFloat {
        return 2.0
    }
}

extension GKRadarGraphView {
    
    //
    // MARK: Drawing functions
    //
    
    /// Called with the UIView requires new rendering.
    ///
    /// - parameter rect: The rectangle in which the UIView is to be rendered.
    override public func drawRect(rect: CGRect) {
        
        super.drawRect(rect)
    }
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
