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

/// Inherit for this class instead of UIView if you put autolayout constraints in a .xib
/// file and want them to be transferred to the storyboard in which the .xib is to be
/// inserted.
class GKAutolayoutNib : UIView {
    
    /// Required init for initializating from interface builder.
    ///
    /// - parameter aDecoder: Codex used to decode from the nib.
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    /// Setup the view when loading.  This will apply auto-layout even when the nib is directly
    /// setup as a child view in interface builder.
    private func setupView() {
        
        let view = NSBundle.mainBundle().loadNibNamed(String(self.dynamicType), owner: self, options: nil).first as! UIView
        
        self.addSubview(view)
        
        // Restore constraints when loaded in interface builder.
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterY , metrics: nil, views: ["view": view]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions.AlignAllCenterX , metrics: nil, views: ["view": view]))
    }
}
