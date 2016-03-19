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

/// Delegate for plot appearance.  Typically, passed to the layer that draws the plot
/// from the GKRadarGraphView
internal protocol GKRadarGraphPlotAppearanceDelegate {

    /// Margin of the chart relative to it's containing view's edge.
    var _margin: CGFloat { get }
    
    /// Margin between the vertices and the text rendering.
    var _textMargin: CGFloat { get }
    
    /// Color of the outermost polygon's edges.
    var _outerStrokeColor: UIColor { get }
    
    /// Width of the outermost polygon's edges.
    var _outerStrokeWidth: CGFloat { get }
    
    /// Color of the inner (gradation) polygons's edges.
    var _gradationStrokeColor: UIColor { get }
    
    /// Width of the inner (gradation0 polygons's edges.
    var _gradationStrokeWidth: CGFloat { get }
    
    /// Number of gradations (inner polygons) to assign to the chart.
    var _numberOfGradations: Int { get }
    
    /// Override the view's background color to be the background of the graph only.
    var _graphBackgroundColor: UIColor { get }
    
    /// How to animate the series.
    var _seriesAnimation:  GKRadarGraphView.SeriesAnimation { get }
}
