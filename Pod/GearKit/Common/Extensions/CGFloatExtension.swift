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

/// Extension for Swift Standard CGFloat type
public extension CGFloat {
    
    /// Check whether self is equal to another float provided with an epsilon (margin of error)
    ///
    /// - parameter otherFloat: Other value used for comparison
    /// - parameter epsilon: The accepted margin of error for which we will accept equality.
    ///
    /// - returns True if the values are considered equal with the given epison as margin of error, false otherwise.
    public func isEqualWithEpsilon(otherFloat: CGFloat, epsilon: CGFloat) -> Bool {
        
        return fabs(self - otherFloat) <= epsilon
    }
    
    /// Convert degrees to radians
    ///
    /// - parameter degrees: The degree value to convert to radians.
    ///
    /// - returns The value converted to radians.
    public static func degreesToRadians(degrees degrees: CGFloat) -> CGFloat {
        
        return CGFloat(M_PI) * (degrees/180)
    }
    
    /// Convert radians to degrees
    ///
    /// - parameter radians: The radian value to convert to degrees.
    ///
    /// - returns The value converted to degrees.
    public static func radiansToDegrees(radians radians: CGFloat) -> CGFloat {
        
        return (radians * 180) / CGFloat(M_PI)
    }
}
