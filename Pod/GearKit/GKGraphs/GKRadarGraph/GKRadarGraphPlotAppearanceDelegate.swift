//
//  GKRadarGraphPlotAppearanceDelegate.swift
//  Pods
//
//  Created by Pascal Jette on 3/13/16.
//
//

import Foundation
import UIKit

internal class GKRadarGraphPlotAppearanceDelegate {
    
    internal class var MARGIN_DEFAULT: CGFloat {
        return 0
    }
    
    internal class var TEXT_MARGIN_DEFAULT: CGFloat {
        return 3
    }

    internal class var OUTER_STROKE_COLOR_DEFAULT: UIColor {
        return UIColor.blackColor()
    }

    internal class var OUTER_STROKE_WIDTH_DEFAULT: CGFloat {
        return 1
    }

    internal class var GRADATION_STROKE_COLOR_DEFAULT: UIColor {
        return UIColor.grayColor()
    }

    internal class var GRADATION_STROKE_WIDTH_DEFAULT: CGFloat {
        return 1
    }

    internal class var NUMBER_OF_GRADATIONS_DEFAULT: Int {
        return 4
    }

    internal class var GRAPH_BACKGROUND_COLOR_DEFAULT: UIColor {
        return UIColor.clearColor()
    }

    
    /// Margin of the chart relative to it's containing view's edge.
    internal var margin: CGFloat = MARGIN_DEFAULT
    
    /// Margin between the vertices and the text rendering.
    internal var textMargin: CGFloat = TEXT_MARGIN_DEFAULT
    
    /// Color of the outermost polygon's edges.
    internal var outerStrokeColor: UIColor = OUTER_STROKE_COLOR_DEFAULT
    
    /// Width of the outermost polygon's edges.
    internal var outerStrokeWidth: CGFloat = OUTER_STROKE_WIDTH_DEFAULT
    
    /// Color of the inner (gradation) polygons's edges.
    internal var gradationStrokeColor: UIColor = GRADATION_STROKE_COLOR_DEFAULT
    
    /// Width of the inner (gradation0 polygons's edges.
    internal var gradationStrokeWidth: CGFloat = GRADATION_STROKE_WIDTH_DEFAULT
    
    /// Number of gradations (inner polygons) to assign to the chart.
    internal var numberOfGradations: Int = NUMBER_OF_GRADATIONS_DEFAULT
    
    /// Override the view's background color to be the background of the graph only.
    internal var graphBackgroundColor: UIColor = GRAPH_BACKGROUND_COLOR_DEFAULT
}
