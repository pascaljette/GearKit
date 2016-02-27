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

/// Button with a solid color that shows an highlighted state.  UIButton with a background
/// color does not support a different color on highlighted and disabled states by default.
/// Therefore, we create a single pixel of a certain color and set it as background image.
/// That way, we can set a different color for highlighted and disabled states.
public class GKSolidColorButton: UIButton {
    
    //
    // MARK: Stored properties
    //

    /// Store the current highlighted background color
    private var _highlightedBackgroundColor: UIColor?
    
    /// Store the current disabled background color
    private var _disabledBackgroundColor: UIColor?
}

extension GKSolidColorButton {
    
    //
    // MARK: UIButton overrides
    //
    
    /// Sets the background color as a single pixel image of the given color for the
    /// NORMAL state.
    override public var backgroundColor: UIColor? {
        
        get {
            
            return super.backgroundColor
        }
        
        set {
            
            super.backgroundColor = newValue
            
            guard let colorInstance = newValue else {
                
                return
            }
            
            self.setBackgroundImage(UIImage.fromColor(colorInstance), forState: .Normal)
        }
    }
}

extension GKSolidColorButton {
    
    //
    // MARK: Computed properties
    //
    
    /// Sets the background color as a single pixel image of the given color for the
    /// Highlighted state.
    @IBInspectable
    public var highlightedBackgroundColor: UIColor? {
        
        get {
            
            return _highlightedBackgroundColor
        }
        
        set {
            
            _highlightedBackgroundColor = newValue
            
            if let colorInstance = _highlightedBackgroundColor {
                
                self.setBackgroundImage(UIImage.fromColor(colorInstance), forState: .Highlighted)
                
            } else {
                
                self.setBackgroundImage(nil, forState: .Highlighted)
            }
        }
    }
    
    /// Sets the background color as a single pixel image of the given color for the
    /// Disabled state.
    @IBInspectable
    public var disabledBackgroundColor: UIColor? {
        
        get {
            
            return _disabledBackgroundColor
        }
        
        set {
            
            _disabledBackgroundColor = newValue
            
            if let colorInstance = _disabledBackgroundColor {
                
                self.setBackgroundImage(UIImage.fromColor(colorInstance), forState: .Disabled)
                
            } else {
                
                self.setBackgroundImage(nil, forState: .Disabled)
            }
            
        }
    }
}
