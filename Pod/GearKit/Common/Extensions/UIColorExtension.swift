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

/// Extension to instantiate a color with RGBA values
extension UIColor {
    
    /// Instantiate a color with an integer including alpha
    ///
    /// - parameter rgba: An int of the 0xAABBCCDD form
    convenience init(rgba: UInt32) {
        
        let red =   CGFloat((rgba & 0xFF000000) >> 24) / 255.0
        let green = CGFloat((rgba & 0x00FF0000) >> 16) / 255.0
        let blue =  CGFloat((rgba & 0x0000FF00) >> 8) / 255.0
        let alpha = CGFloat((rgba & 0x000000FF) >> 0) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Instantiate a color with an integer excluding alpha
    ///
    /// - parameter rgba: An int of the 0xAABBCC form
    /// - parameter alpha: Alpha value (default is 0)
    convenience init(rgb: UInt32, alpha: CGFloat = 0.0) {
        
        let red =   CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue =  CGFloat((rgb & 0x0000FF) >> 0) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// Instantiate a color with an hex string excluding alpha.
    /// The expected format is #RRGGBB
    convenience init?(rgbString: String, alpha: CGFloat = 1) {
        
        guard let intValue = UIColor.integerFromHexString(rgbString, length: 6) else {
            
            return nil        }
        
        self.init(rgb: intValue, alpha: alpha)
    }
    
    /// Instantiate a color with an hex string excluding alpha.
    /// The expected format is #RRGGBBAA
    convenience init?(rgbaString: String) {
        
        guard let intValue = UIColor.integerFromHexString(rgbaString, length: 8) else {
            
            return nil
        }
        
        self.init(rgba: intValue)
    }
    
    // TODO-pk SwiftDoc
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
