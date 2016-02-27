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

/// Protocol for a listener on a screen that can display the keyboard and also contains
/// a scrollView.  Handles automatic scrollling of the scroll view to display 
/// fields over the keyboard when it is shown.
public protocol GKScrollingKeyboardListener : GKKeyboardListener {
    
    /// ScrollView for the keyboard listener.
    var scrollView: UIScrollView? { get set }
}

extension GKScrollingKeyboardListener where Self : UIViewController {

    //
    // MARK: Auto-scrolling implementations
    //
    
    /// Call in keyboardDidAppear
    public final func adjustInsetsOnKeyboardShow(notification: NSNotification) {
        
        defer {
            
            keyboardVisible = true
        }
        
        guard let scrollViewInstance = scrollView else {
            
            return
        }
        
        if !keyboardVisible {
            
            var contentInsets: UIEdgeInsets = scrollViewInstance.contentInset
            contentInsets.bottom += notification.keyboardSize.height
            
            scrollViewInstance.contentInset = contentInsets;
            scrollViewInstance.scrollIndicatorInsets = contentInsets
        }
        
        var aRect: CGRect = self.view.frame
        aRect.size.height -= notification.keyboardSize.height
        
        guard let activeView = activeField as? UIView else {
            
            return
        }
        
        scrollViewInstance.scrollRectToVisible(activeView.frame, animated: true)
    }
    
    /// Call in keyboardWillDisappear
    public final func adjustInsetsOnKeyboardHide(notification: NSNotification) {
        
        defer {
            
            keyboardVisible = false
        }
        
        // If the first view is not a scroll view, do nothing
        guard let scrollViewInstance = scrollView else {
            
            return
        }
        
        if keyboardVisible {
            
            var contentInsets: UIEdgeInsets = scrollViewInstance.contentInset
            contentInsets.bottom -= notification.keyboardSize.height
            
            scrollViewInstance.contentInset = contentInsets;
            scrollViewInstance.scrollIndicatorInsets = contentInsets
        }
    }
}
