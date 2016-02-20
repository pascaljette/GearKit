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

/// Miscellaneous utilities for threads
public class GKThread {
    
    //
    // MARK: Types
    //
    
    /// Function type for dispatching on another thread.
    public typealias DispatchFunction = () -> Void
}

extension GKThread {
    
    //
    // MARK: Class functions
    //
    
    /// Dispatch a closure on the UI thread
    ///
    /// - parameter function: Closure to dispatch on the UI thread.
    public class func dispatchOnUiThread(function: DispatchFunction) {
        
        dispatch_async(dispatch_get_main_queue()) {
            function()
        }
    }
    
    /// Dispatch after interval
    ///
    /// - parameter function: Closure to dispatch on the UI thread.
    public class func dispatchOnUiThreadAfterMilliseconds(interval: Double, function: DispatchFunction) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_MSEC))), dispatch_get_main_queue(), function)
    }
    
    /// Sleep the current thread for a time specified in milliseconds
    ///
    /// - parameter milliseconds: Time interval in milliseconds to sleep the thread.
    public class func sleepForMilliseconds(milliseconds: Double) {
        
        NSThread.sleepForTimeInterval(milliseconds * Double(1000))
    }
}
