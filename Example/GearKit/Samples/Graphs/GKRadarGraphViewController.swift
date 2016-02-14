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
        
        let hpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "HP")
        let mpParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "MP")
        let strengthParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Strength")
        let defenseParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Defense")
        let magicParameter: GKRadarGraphView.Parameter = GKRadarGraphView.Parameter(name: "Magic", nameOffset: CGPoint(x: 10, y: -20))
        
        radarGraphView.parameter = [hpParameter, mpParameter, strengthParameter, defenseParameter, magicParameter]
        
        // We only support gradients for a single serie radar graph
        let firstSerie = GKRadarGraphView.Serie()
        firstSerie.strokeColor = UIColor.blackColor()
        
        let firstColor: UIColor = UIColor(red: 0.8, green: 0.6, blue: 0.0, alpha: 0.96)
        let finalColor: UIColor = UIColor(red: 1.0, green: 0.8, blue: 0.0, alpha: 0.96)
        
        firstSerie.fillMode = .GRADIENT(firstColor, finalColor)
        
        firstSerie.percentageValues = [0.9, 0.5, 0.6, 0.2, 0.9]
        
        radarGraphView.margin = 36
        radarGraphView.series = [firstSerie]
    }
}
