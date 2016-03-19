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
public class GKRadarGraphView : UIView, GKRadarGraphParameterDatasource {
    
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
        public var fillMode: FillMode = Serie.FILL_MODE_DEFAULT
        
        /// Serie's name.
        public var name: String?
        
        /// Stroke color for the serie.  Also controls the color of the vertex decorations.
        public var strokeColor: UIColor?
        
        /// Stroke width for the serie.
        public var strokeWidth: CGFloat = Serie.STROKE_WIDTH_DEFAULT
        
        /// Percentage of the max value for each of the serie's attributes.  This must follow
        /// the same order as the owning graph parameters.
        public var percentageValues: [CGFloat] = []
        
        /// Decoration to put on each of the serie's vertices.
        public var decoration: DecorationType?
        
        /// Array of verties for that serie
        internal var vertices: [CGPoint] = []
        
        //
        // MARK: Series default values
        //
        
        /// Default fill mode for a series.
        internal class var FILL_MODE_DEFAULT: FillMode {
            return .SOLID(UIColor.blackColor())
        }
        
        /// Default width for strokes
        internal class var STROKE_WIDTH_DEFAULT: CGFloat {
            return 0.0
        }
        
        /// Default color for strokes
        internal class var STROKE_COLOR_DEFAULT: UIColor {
            return UIColor.blackColor()
        }
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
        public var nameFont: UIFont = Parameter.FONT_DEFAULT
        
        /// Font for the name label in the graph
        public var nameFontColor: UIColor = Parameter.FONT_COLOR_DEFAULT
        
        /// Offset of where to render the text.
        public var textOffset: CGPoint = Parameter.TEXT_OFFSET_DEFAULT
        
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
        
        //
        // MARK: Parameter default values.
        //
        
        /// Default value for a parameter's font.
        internal class var FONT_DEFAULT: UIFont {
            return UIFont.systemFontOfSize(14)
        }
        
        /// Default value for a parameter's font.
        internal class var FONT_COLOR_DEFAULT: UIColor {
            return UIColor.blackColor()
        }
        
        /// Default value for a parameter's text offset.
        internal class var TEXT_OFFSET_DEFAULT: CGPoint {
            return CGPointZero
        }
    }
    
    /// Animation type for the series.
    public enum SeriesAnimation {
        
        /// Do not animate
        case NONE
        
        /// Scale all series simultaneously
        case SCALE_ALL(CGFloat)
        
        /// Scale series one by one
        case SCALE_ONE_BY_ONE(CGFloat)
        
        /// draw the series parameter by parameter.
        case PARAMETER_BY_PARAMETER(CGFloat)
    }
    
    //
    // MARK: Initialization
    //

    /// Init with frame.
    ///
    ///  - parameter frame: Frame with which to initialize.  This is used when initializing the view 
    /// programatically.
    override init(frame: CGRect) {
        super.init(frame: frame)

        doInit()
        
        self.layer.addSublayer(containerLayer)
    }

    /// Init with coder (required).
    ///
    ///  - parameter coder: Coder with which to initialize.  This is used when initializing the view
    /// from a nib/storyboard.
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        doInit()

        self.layer.addSublayer(containerLayer)
    }
    
    /// Common setup function
    private func doInit() {
    
        containerLayer.contentsScale = self.layer.contentsScale
        containerLayer.backgroundColor = backgroundColor?.CGColor
        containerLayer.parameterDatasource = self
        containerLayer.plotApperanceDelegate = self
    }
    
    //
    // MARK: Stored properties
    //
    
    /// Array of parameters to generate the graph.
    public var parameters: [Parameter] = [] {
        
        didSet {
            
            setNeedsDisplay()
        }
    }
    
    /// Animation type for series
    public var seriesAnimation: SeriesAnimation = GKRadarGraphView.SERIES_ANIMATION_DEFAULT
    
    /// Array of series populating the graph's data.
    public var series: [Serie] = [] {
        
        didSet {
            
            let difference = series.count - (containerLayer.sublayers?.count ?? 0)
            
            // Adjust number of slices
            if (difference > 0) {
                
                for _: Int in 0..<difference {
                    
                    let serieLayer = GKRadarGraphSerieLayer()
                    serieLayer.frame = self.bounds
                    
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
                
                guard let allSublayers = containerLayer.sublayers else {
                    
                    // This is actually a fatal error, sublayers should not be nil here.
                    continue
                }
                
                if let sublayerInstance = allSublayers[i] as? GKRadarGraphSerieLayer {
                    
                    sublayerInstance.serie = singleSerie
                    sublayerInstance.parameterDatasource = self
                    
                    sublayerInstance.nextSerieLayer = allSublayers.isInBounds(i + 1)
                        ? allSublayers[i + 1] as? GKRadarGraphSerieLayer
                        : nil                    
                }
            }
            
            setNeedsDisplay()
        }
    }
    
    /// Container layer
    private var containerLayer = GKRadarGraphContainerLayer()
    
    //
    // MARK: GKRadarGraphParameterDatasource implementation
    //
    
    //
    // NOTE: This contains stored properties so it cannot be put into an extension.
    //
    
    /// Parameters (read-only)
    var _parameters: [GKRadarGraphView.Parameter] {
        return parameters
    }
    
    /// Circle center for plot adjustments.
    var _circleCenter: CGPoint = CGPointZero
    
    /// Circle radius for plot adjustments.  Needs to be settable for when we auto-adjust.
    var _circleRadius: CGFloat = 0.0
    
    //
    // MARK: IBInspectable stored properties
    //
    
    //
    // NOTE: IBInspectable properties cannot be computed properties.  Therefore, we need
    // to keep both a copy in the plot appearance delegate and here.
    //
    
    /// Margin of the chart relative to it's containing view's edge.
    @IBInspectable
    public var margin: CGFloat = MARGIN_DEFAULT
    
    /// Margin between the vertices and the text rendering.
    @IBInspectable
    public var textMargin: CGFloat = TEXT_MARGIN_DEFAULT
    
    /// Color of the outermost polygon's edges.
    @IBInspectable
    public var outerStrokeColor: UIColor = OUTER_STROKE_COLOR_DEFAULT
    
    /// Width of the outermost polygon's edges.
    @IBInspectable
    public var outerStrokeWidth: CGFloat = OUTER_STROKE_WIDTH_DEFAULT

    /// Color of the inner (gradation) polygons's edges.
    @IBInspectable
    public var gradationStrokeColor: UIColor = GRADATION_STROKE_COLOR_DEFAULT
    
    /// Width of the inner (gradation0 polygons's edges.
    @IBInspectable
    public var gradationStrokeWidth: CGFloat = GRADATION_STROKE_WIDTH_DEFAULT
    
    /// Number of gradations (inner polygons) to assign to the chart.
    @IBInspectable
    public var numberOfGradations: Int = NUMBER_OF_GRADATIONS_DEFAULT
    
    /// Background color of the polygon that delimits the plot itself, not the full view.
    @IBInspectable
    public var graphBackgroundColor: UIColor = GRAPH_BACKGROUND_COLOR_DEFAULT
}

extension GKRadarGraphView : GKRadarGraphPlotAppearanceDelegate {
    
    /// Margin of the chart relative to it's containing view's edge.
    var _margin: CGFloat {
        return margin
    }
    
    /// Margin between the vertices and the text rendering.
    var _textMargin: CGFloat {
        return textMargin
    }
    
    /// Color of the outermost polygon's edges.
    var _outerStrokeColor: UIColor {
        return outerStrokeColor
    }
    
    /// Width of the outermost polygon's edges.
    var _outerStrokeWidth: CGFloat {
        return outerStrokeWidth
    }
    
    /// Color of the inner (gradation) polygons's edges.
    var _gradationStrokeColor: UIColor {
        return gradationStrokeColor
    }
    
    /// Width of the inner (gradation0 polygons's edges.
    var _gradationStrokeWidth: CGFloat {
        return gradationStrokeWidth
    }
    
    /// Number of gradations (inner polygons) to assign to the chart.
    var _numberOfGradations: Int {
        return numberOfGradations
    }
    
    /// Override the view's background color to be the background of the graph only.
    var _graphBackgroundColor: UIColor {
        return graphBackgroundColor
    }
    
    /// How to animate the series.
    var _seriesAnimation: SeriesAnimation {
        return seriesAnimation
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
    
    /// Default margin value.
    internal class var MARGIN_DEFAULT: CGFloat {
        return 0
    }
    
    /// Default text margin value.
    internal class var TEXT_MARGIN_DEFAULT: CGFloat {
        return 3
    }
    
    /// Default stroke color for outermost edges.
    internal class var OUTER_STROKE_COLOR_DEFAULT: UIColor {
        return UIColor.blackColor()
    }
    
    /// Default stroke width for outermost edges.
    internal class var OUTER_STROKE_WIDTH_DEFAULT: CGFloat {
        return 1
    }
    
    /// Default stroke color for inner gradation edges.
    internal class var GRADATION_STROKE_COLOR_DEFAULT: UIColor {
        return UIColor.grayColor()
    }
    
    /// Default stroke width for inner gradation edges.
    internal class var GRADATION_STROKE_WIDTH_DEFAULT: CGFloat {
        return 1
    }
    
    /// Default number of gradations.
    internal class var NUMBER_OF_GRADATIONS_DEFAULT: Int {
        return 4
    }
    
    /// Default graph background color.
    internal class var GRAPH_BACKGROUND_COLOR_DEFAULT: UIColor {
        return UIColor.clearColor()
    }
    
    /// Default series animation type
    internal class var SERIES_ANIMATION_DEFAULT: SeriesAnimation {
        return .NONE
    }
}

extension GKRadarGraphView {
    
    //
    // MARK: UIView overrides
    //

    
    /// Layout sub views.
    /// We use this to update our sublayers frames when the view lays out its subviews.
    /// Layers do not resize automatically.
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // Layers do not auto-resize!
        containerLayer.frame = self.bounds
        
        if let sublayersInstance = containerLayer.sublayers {
            
            for serieLayer in sublayersInstance {
                
                serieLayer.frame = self.bounds
            }
        }
    }
    
    /// Override set needs display in order to redraw the children layers
    /// when the parent view is changed.
    public override func setNeedsDisplay() {
        
        super.setNeedsDisplay()
        
        containerLayer.setNeedsDisplay()
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
        
        self.parameters = [hpParameter, mpParameter, strengthParameter, defenseParameter, magicParameter]

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
