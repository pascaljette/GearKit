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
    
    //
    // MARK: IBOutlets
    //
    
    @IBOutlet weak var radarGraphView: GKRadarGraphView!
    
    //
    // MARK: Stored properties
    //
    
    /// Model containing info about generating the graph.
    let model: GKRadarGraphModel
    
    //
    // MARK: Initialisation.
    //
    
    /// Initialise with a model.
    ///
    /// - parameter model: Model to use to initialise the view controller.
    init(model: GKRadarGraphModel) {
        
        self.model = model
        super.init(nibName: "GKRadarGraphViewController", bundle: nil)
    }

    /// Required initialiser with a coder.
    /// We generate a fatal error to underline the fact that we do not want to support storyboards.
    ///
    /// - parameter coder: Coder used to serialize the object.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension GKRadarGraphViewController {
    
    //
    // MARK: UIViewController overrides.
    //

    /// View did load
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationItem.title = "GKRadarGraph"
    }
    
    /// View did appear.
    ///
    /// - parameter animated: Whether the view should be animated.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        radarGraphView.parameters = model.parameters
        radarGraphView.backgroundColor = GKColorRGB(red: 0, green: 200, blue: 100, alpha: 150).uiColor
        
        radarGraphView.seriesAnimation = .PARAMETER_BY_PARAMETER(0.8)
        
        radarGraphView.series = model.series
    }
}
