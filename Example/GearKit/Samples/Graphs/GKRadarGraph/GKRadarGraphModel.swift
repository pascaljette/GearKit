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

import UIKit
import GearKit

/// Model containing the data necessary to display the radar graph view controller.
struct GKRadarGraphModel {
    
    //
    // MARK: Stored properties
    //

    /// Array of parameters for the plot.
    var parameters: [GKRadarGraphView.Parameter] = []
    
    /// Series representing the data in the plot.
    var series: [GKRadarGraphView.Serie] = []

    //
    // MARK: Initialisation
    //

    /// Initialize with default values.
    init() {
        
        let hpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "HP")
        let mpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "MP")
        let strengthParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "STR")
        let defenseParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "DF")
        let magicParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "MGC")
        
        parameters = [hpParameter, mpParameter, strengthParameter, defenseParameter, magicParameter]
        
        // We only support gradients for a single serie radar graph
        var firstSerie = GKRadarGraphView.Serie()
        firstSerie.strokeColor = UIColor.blueColor()
        firstSerie.strokeWidth = 4.0
        firstSerie.name = "blue"
        let firstFillColor: UIColor = UIColor(red: 0.1, green: 0.1, blue: 0.7, alpha: 0.7)
        
        firstSerie.fillMode = .SOLID(firstFillColor)
        firstSerie.percentageValues = [0.9, 0.5, 0.6, 0.2, 0.9]
        firstSerie.decoration = .SQUARE(8.0)
        
        var secondSerie = GKRadarGraphView.Serie()
        secondSerie.strokeColor = UIColor.greenColor()
        secondSerie.strokeWidth = 4.0
        secondSerie.name = "green"
        let secondFillColor: UIColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 0.7)
        
        secondSerie.fillMode = .SOLID(secondFillColor)
        secondSerie.percentageValues = [0.9, 0.1, 0.2, 0.9, 0.3]
        secondSerie.decoration = .CIRCLE(6.0)
        
        var thirdSerie = GKRadarGraphView.Serie()
        thirdSerie.strokeColor = UIColor.redColor()
        thirdSerie.strokeWidth = 4.0
        thirdSerie.name = "red"
        let thirdSerieFillColor: UIColor = UIColor(red: 0.7, green: 0.1, blue: 0.1, alpha: 0.7)
        
        thirdSerie.fillMode = .SOLID(thirdSerieFillColor)
        thirdSerie.percentageValues = [0.5, 0.9, 0.5, 0.5, 0.6]
        thirdSerie.decoration = .DIAMOND(8.0)
                
        series = [firstSerie, secondSerie, thirdSerie]
    }
}
