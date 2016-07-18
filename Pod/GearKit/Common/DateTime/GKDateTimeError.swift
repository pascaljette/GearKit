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

/// Describes errors thrown by the DateTime struct.
public enum DateTimeError : ErrorType {
    
    /// Format provided to build a date from a string is invalid.
    case InvalidDateFormat(string: String, format: String)
    
    /// The string provided to try auto-detecting the format could not be parsed.
    case InvalidStringForAutoDetect(string: String)
    
    /// Components provided to build a date are invalid.
    case InvalidDateComponents(year: Int, month: Int, day: Int)
    
    /// Components provided to build a DateTime array for a given year/month are invalid.
    case InvalidComponentsForDateArray(year: Int, month: Int)
}

/// Print the description of a DateTimeError
extension DateTimeError :  CustomStringConvertible {
    
    public var description: String {
        
        switch self {
        
        case .InvalidDateFormat(let string, let format):
            return "Invalid Date Format: for STRING:\(string), FORMAT:\(format)"
            
        case .InvalidStringForAutoDetect(let string):
            return "Could not auto-detect format for STRING:\(string)"
            
        case .InvalidDateComponents(let year, let month, let day):
            return "Invalid Date Components: for YEAR:\(year), MONTH:\(month), DAY:\(day)"

        case .InvalidComponentsForDateArray(let year, let month):
            return "Invalid Date Array Components: for YEAR:\(year), MONTH:\(month)"
        }
    }
}

/// Print the debug description of a DateTimeError
extension DateTimeError :  CustomDebugStringConvertible {
    
    public var debugDescription: String {
        
        switch self {
        
        case .InvalidDateFormat(let string, let format):
            return "Invalid Date Format: for STRING:\(string), FORMAT:\(format)"
            
        case .InvalidStringForAutoDetect(let string):
            return "Could not auto-detect format for STRING:\(string)"
            
        case .InvalidDateComponents(let year, let month, let day):
            return "Invalid Date Components: for YEAR:\(year), MONTH:\(month), DAY:\(day)"
            
        case .InvalidComponentsForDateArray(let year, let month):
            return "Invalid Date Array Components: for YEAR:\(year), MONTH:\(month)"
        }
    }
}

