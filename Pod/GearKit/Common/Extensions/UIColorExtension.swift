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

/// Extension for the Swift Standard UIColor class
extension UIColor {
    
    //
    // MARK: Initializers
    //
    
    /// Instantiate a color with an integer including alpha
    ///
    /// - parameter rgba: An int of the 0xRRGGBBAA form
    public convenience init(rgba: UInt32) {
        
        let red =   CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue =  CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat((rgba & 0x000000FF) >> 0) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Instantiate a color with an integer excluding alpha
    ///
    /// - parameter rgba: An int of the 0xRRGGBB form
    /// - parameter alpha: Alpha value (default is 1.0, lowest possible value is 0.0)
    public convenience init(rgb: UInt32, alpha: CGFloat = 1.0) {
        
        let red =   CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue =  CGFloat((rgb & 0x0000FF) >> 0) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Instantiate a color with an hex string including alpha.  The prefix can be either
    /// '#' or '0x'.
    ///
    /// - parameter rgbaString: A string of the "#RRGGBBAA" format.
    public convenience init?(rgbaString: String) {
        
        guard let intValue = UIColor.integerFromHexString(rgbaString, length: 8) else {
            
            return nil
        }
        
        self.init(rgba: intValue)
    }
    
    /// Instantiate a color with an hex string excluding alpha.  The prefix can be either
    /// '#' or '0x'.
    ///
    /// - parameter rgbString: A string of the "#RRGGBB" format.
    /// - parameter alpha: Alpha value (default is 1.0, lowest possible value is 0.0)
    public convenience init?(rgbString: String, alpha: CGFloat = 1.0) {
        
        guard let intValue = UIColor.integerFromHexString(rgbString, length: 6) else {
            
            return nil        }
        
        self.init(rgb: intValue, alpha: alpha)
    }
}

extension UIColor {
    
    //
    // MARK: Private methods
    //
    
    /// Convert a hex string to an integer.
    ///
    /// - parameter colorString: The string representing the hex value to convert.
    /// - parameter length: The length of the string to convert.
    private class func integerFromHexString(colorString: String, length: Int) -> UInt32? {
        
        var trimmedString: String = colorString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        // Require the string to start with #
        if trimmedString.hasPrefix("#") {
            
            // Skip the '#'
            let index = trimmedString.startIndex.advancedBy(1)
            trimmedString = trimmedString.substringFromIndex(index);
            
        } else if trimmedString.hasPrefix("0x") {
            
            // Skip the '0x'
            let index = trimmedString.startIndex.advancedBy(2)
            trimmedString = trimmedString.substringFromIndex(index);
            
        } else {
            
            return nil
        }
        
        return trimmedString.characters.count == length
            ? UInt32(trimmedString, radix: 16)
            : nil
    }

}
