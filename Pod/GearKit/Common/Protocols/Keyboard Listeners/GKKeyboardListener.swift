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

/// Protocol for a listener on a screen that can display the keyboard. Provides
/// a standard UIVIewController-like interface for keyboard events.


/// Protocol for a listener on a screen that can display the keyboard. Provides
/// a standard UIVIewController-like interface for keyboard events.
@objc
public protocol GKKeyboardListener : class {

    // We need to force implementation of these methods because
    // we cannot declare selectors in protocol extensions.
    var activeField: UITextInputTraits? { get set }
    
    // The keyboard visibility isn't automatically updated.  It must be implemented
    // by implementing classes.
    var keyboardVisible: Bool { get set }
    
    optional func keyboardWillAppear(notification: NSNotification)
    optional func keyboardDidAppear(notification: NSNotification)
    optional func keyboardWillDisappear(notification: NSNotification)
    optional func keyboardDidDisappear(notification: NSNotification)
}

extension GKKeyboardListener where Self : AnyObject {
    
    //
    // MARK: Observers
    //
    
    /// Add the keyboard observers based on what optional functions were actually implemented
    /// by the class
    public func addKeyboardObserver() {
        
        // Setup keyboard observers.  No need to add an observer if the method
        // is not implemented.
        if let _ = keyboardWillAppear {
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "keyboardWillAppear:",
                name: UIKeyboardWillShowNotification,
                object: nil)
        }
        
        if let _ = keyboardDidAppear {
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "keyboardDidAppear:",
                name: UIKeyboardDidShowNotification,
                object: nil)
        }
        
        if let _ = keyboardWillDisappear {
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "keyboardWillDisappear:",
                name: UIKeyboardWillHideNotification,
                object: nil)
        }
        
        if let _ = keyboardDidDisappear {
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "keyboardDidDisappear:",
                name: UIKeyboardDidHideNotification,
                object: nil)
        }
    }
    
    /// Call this in both viewWillDisappear and deinit if self is a ViewController.
    /// This removed all the observers we added earlier in the NSNotificationCenter.
    public func removeKeyboardObserver() {
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
