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
    // MARK: Nested types
    //
    enum AnimationPickerType: String {
        
        /// Scale all series simultaneously.
        case SCALE_ALL = "Scale all"
        
        /// Scale series one by one.
        case SCALE_ONE_BY_ONE = "Scale one by one"
        
        /// Parameter one by one.
        case PARAMETER_BY_PARAMETER = "Parameter one by one"
        
        /// Get the corresponding series animation enum from the picker data.
        var seriesAnimation: GKRadarGraphView.SeriesAnimation {
            
            switch self {
                
            case .SCALE_ALL:
                return .SCALE_ALL(GKRadarGraphViewController.ANIMATION_DEFAULT_DURATION)
                
            case .SCALE_ONE_BY_ONE:
                return .SCALE_ONE_BY_ONE(GKRadarGraphViewController.ANIMATION_DEFAULT_DURATION)
                
            case .PARAMETER_BY_PARAMETER:
                return .PARAMETER_BY_PARAMETER(GKRadarGraphViewController.ANIMATION_DEFAULT_DURATION)
            }
        }
    }
    
    //
    // MARK: IBOutlets
    //
    
    @IBOutlet weak var radarGraphView: GKRadarGraphView!

    //
    // MARK: Stored properties
    //
    
    /// Model containing info about generating the graph.
    let model: GKRadarGraphModel
    
    /// Animation picker view data
    let pickerViewData: [AnimationPickerType] = [.SCALE_ALL, .SCALE_ONE_BY_ONE, .PARAMETER_BY_PARAMETER]
    
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
    // MARK: Class variables.
    //
    
    /// Default duration for an animation.
    class var ANIMATION_DEFAULT_DURATION: CGFloat {
        return 0.4
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
    
    /// View will appear.
    ///
    /// - parameter animated: Whether the view should be animated.
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        radarGraphView.parameters = model.parameters
        radarGraphView.backgroundColor = GKColorRGB(red: 0, green: 200, blue: 100, alpha: 150).uiColor
        
        radarGraphView.series = model.series
    }
}

extension GKRadarGraphViewController: UIPickerViewDataSource {
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerViewData.count
    }
}

extension GKRadarGraphViewController: UIPickerViewDelegate {
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row].rawValue
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let selection = pickerViewData[row]
        radarGraphView.animateWithType(selection.seriesAnimation)
    }
}


extension GKRadarGraphViewController {
    
    //
    // MARK: IBAction.
    //

    /// Animate button tapped.
    ///
    /// - parameter sender: The "Animate" button itself.
    @IBAction func animateButtonTapped(sender: AnyObject) {
        
        let alertController: UIAlertController = UIAlertController(title: "Select Animation", message: nil, preferredStyle: .ActionSheet)
     
        // TODO-pk there is a better to do this than this ugly enum.
        let scaleAllAction: UIAlertAction = UIAlertAction(title: AnimationPickerType.SCALE_ALL.rawValue, style: .Default, handler: { [weak self] _ in
            
            guard let strongSelf = self else {
                
                return
            }
            
            let action = AnimationPickerType.SCALE_ALL
            strongSelf.radarGraphView.animateWithType(action.seriesAnimation)
            
        })
        
        let scaleOneByOneAction: UIAlertAction = UIAlertAction(title: AnimationPickerType.SCALE_ONE_BY_ONE.rawValue, style: .Default, handler: { [weak self] _ in
            
            guard let strongSelf = self else {
                
                return
            }
            
            let action = AnimationPickerType.SCALE_ONE_BY_ONE
            strongSelf.radarGraphView.animateWithType(action.seriesAnimation)
            
        })
        
        let parameterOneByOneAction: UIAlertAction = UIAlertAction(title: AnimationPickerType.PARAMETER_BY_PARAMETER.rawValue, style: .Default, handler: { [weak self] _ in
            
            guard let strongSelf = self else {
                
                return
            }
            
            let action = AnimationPickerType.PARAMETER_BY_PARAMETER
            strongSelf.radarGraphView.animateWithType(action.seriesAnimation)
            
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        
        alertController.addAction(scaleAllAction)
        alertController.addAction(scaleOneByOneAction)
        alertController.addAction(parameterOneByOneAction)
        alertController.addAction(cancelAction)

        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    /// Edit series button tapped.
    ///
    /// - parameter sender: The "Edit Series" button itself.
    @IBAction func editSeriesButtonTapped(sender: AnyObject) {
        
        showViewController(GKRadarGraphEditSeriesViewController(graphData: model), sender: self)
    }
}
