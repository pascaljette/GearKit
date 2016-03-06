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

/// Stored properties
class GKRadarGraphViewController: UIViewController {
    
    @IBOutlet weak var radarGraphView: GKRadarGraphView!
    
}

/// UIViewController overrides
extension GKRadarGraphViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let hpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Serie 1")
        let mpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Serie 2")
        let strengthParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Serie 3")
        let defenseParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Serie 4")
        let magicParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "abcdefghijkl")
        
        radarGraphView.parameter = [hpParameter, mpParameter, strengthParameter, defenseParameter, magicParameter]
        
        // We only support gradients for a single serie radar graph
        let firstSerie = GKRadarGraphView.Serie()
        firstSerie.strokeColor = UIColor.blackColor()
        
        let fillColor: UIColor = UIColor.blueColor()
        
        firstSerie.fillMode = .SOLID(fillColor)
        
        firstSerie.percentageValues = [0.9, 0.5, 0.6, 0.2, 0.9]
        
        radarGraphView.margin = 0
        radarGraphView.series = [firstSerie]
    }
}
