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

//
// MARK: Stored properties
//

/// Base class for a navigation view controller
public class GKNavigationControllerBase: UINavigationController {
    
    /// Navigation bar color.  Override this to set a different color in child classes.
    var navigationBarColor: UIColor {
        
        // TODO-pk put this in constants (hardcoded string)
        if let plistDefinition = NSBundle.mainBundle().objectForInfoDictionaryKey("GKNavigationBarDefaultColor") {
            
            if let colorDefinition = plistDefinition as? String {
                
                return UIColor(rgbaString: colorDefinition) ?? UIColor.whiteColor()
            }
        }
        return UIColor.whiteColor()
    }
    
    /// Force white navigation text.
    var forceWhiteNavigationText: Bool {

        // By default, we want the greatest contrast between the text color and the background color.
        // Text colors are considered to be either white or black.
        var white: CGFloat = 0.0
        
        if navigationBarColor.getWhite(&white, alpha: nil) {
        
            if white < 0.5 {
                
                return true
            }
        }
        
        return false
    }
}

//
// MARK: UIViewController overrides
//

extension GKNavigationControllerBase {
    
    /// View did loads
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationBar.barTintColor = navigationBarColor
        navigationBar.tintColor = UIColor.whiteColor()
        
        navigationBar.barStyle = forceWhiteNavigationText
            ? UIBarStyle.Black
            : UIBarStyle.Default
    }
}
