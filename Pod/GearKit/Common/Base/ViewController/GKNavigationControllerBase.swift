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

/// Base class for a navigation view controller.  Implements some functions
/// useful for common cases across navigation controller implementations.
public class GKNavigationControllerBase: UINavigationController {
    
    //
    // MARK: Computed properties
    //
    
    /// Navigation bar color.  Override this to set a different color in child classes.
    /// By default, this will retrieve the color in the main bundle's plist file defined by
    /// the GKPlistKeyConstants.NAVIGATION_BAR_DEFAULT_COLOR_KEY constants.  If not found, defaults
    /// defaults to white.
    public var navigationBarColor: UIColor {
        
        if let plistDefinition = NSBundle.mainBundle().objectForInfoDictionaryKey(GKPlistKeyConstants.NAVIGATION_BAR_DEFAULT_COLOR_KEY) {
            
            if let colorDefinition = plistDefinition as? String {
                                
                return GKColorRGB(rgbaString: colorDefinition)?.uiColor ?? UIColor.whiteColor()
            }
        }
        return UIColor.whiteColor()
    }
    
    /// Force white navigation text.  Forces the text on the navigation bar to be white.
    /// By default, take the grayscale value of the background color and returns true if the
    /// color is judged to be white.
    public var forceWhiteNavigationText: Bool {

        var white: CGFloat = 0.0
        
        if navigationBarColor.getWhite(&white, alpha: nil) {
        
            if white < 0.5 {
                
                return true
            }
        }
        
        return false
    }
}

extension GKNavigationControllerBase {

    //
    // MARK: UIViewController overrides
    //
    
    /// View did load.  Set the bar tint color (
    override public func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationBar.barTintColor = navigationBarColor
        
        navigationBar.tintColor = forceWhiteNavigationText
            ? UIColor.whiteColor()
            : UIColor.blackColor()
        
        navigationBar.barStyle = forceWhiteNavigationText
            ? UIBarStyle.Black
            : UIBarStyle.Default
    }
}
