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

/// Representation for a color, with the more standard RGBA values ranging from 0 to 255
public class GKColorRGB {
    
    //
    // MARK: Stored properties
    //
    
    /// Red value, ranged from 0 to 255
    public var red: CGFloat
    
    /// Green value, ranged from 0 to 255
    public var green: CGFloat
    
    /// Blue value, ranged from 0 to 255
    public var blue: CGFloat
    
    /// Alpha value, ranged from 0 to 255
    public var alpha: CGFloat
    
    //
    // MARK: Initializers
    //
    
    /// Instantiate a color with explicit parameters for RGB values
    ///
    /// - parameter red Value of the red component, ranged from 0 to 255
    /// - parameter green Value of the green component, ranged from 0 to 255
    /// - parameter blue Value of the blue component, ranged from 0 to 255
    /// - parameter alpha Value of the alpha component, ranged from 0 to 255.  Defaults to 255 (opaque)
    public init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 255.0) {
        
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }
    
    /// Instantiate a color with an integer including alpha
    ///
    /// - parameter rgba: An int of the 0xRRGGBBAA form
    public init(rgba: UInt32) {
        
        red =   CGFloat((rgba & 0xFF000000) >> 24)
        green = CGFloat((rgba & 0x00FF0000) >> 16)
        blue =  CGFloat((rgba & 0x0000FF00) >> 8)
        alpha = CGFloat((rgba & 0x000000FF) >> 0)
    }
    
    /// Instantiate a color with an integer excluding alpha
    ///
    /// - parameter rgba: An int of the 0xRRGGBB form
    /// - parameter alpha: Alpha value.  Range between 0.0 and 255.0, where 255.0 is opaque.
    public init(rgb: UInt32, alpha: CGFloat = 255.0) {
        
        red =   CGFloat((rgb & 0xFF0000) >> 16)
        green = CGFloat((rgb & 0x00FF00) >> 8)
        blue =  CGFloat((rgb & 0x0000FF) >> 0)
        self.alpha = alpha
    }
    
    /// Instantiate a color with an hex string including alpha.  The prefix can be either
    /// '#' or '0x'.
    ///
    /// - parameter rgbaString: A string of the "#RRGGBBAA" format.
    public convenience init?(rgbaString: String) {
        
        guard let intValue = GKColorRGB.integerFromHexString(rgbaString, length: 8) else {
            
            return nil
        }
        
        self.init(rgba: intValue)
    }
    
    /// Instantiate a color with an hex string excluding alpha.  The prefix can be either
    /// '#' or '0x'.
    ///
    /// - parameter rgbString: A string of the "#RRGGBB" format.
    /// - parameter alpha: Alpha value.  Range between 0.0 and 255.0, where 255.0 is opaque.
    public convenience init?(rgbString: String, alpha: CGFloat = 255.0) {
        
        guard let intValue = GKColorRGB.integerFromHexString(rgbString, length: 6) else {
            
            return nil
        }
        
        self.init(rgb: intValue, alpha: alpha)
    }
}

extension GKColorRGB {
    
    //
    // MARK: Computed properties
    //
    
    /// Generate UIColor from our components
    public var uiColor: UIColor {
        
        return UIColor(red: self.red / 255.0
            , green: self.green / 255.0
            , blue: self.blue / 255.0
            , alpha: self.alpha / 255.0)
    }
}

extension GKColorRGB {
    
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
            
        } else if trimmedString.hasPrefix("0X") {
            
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

