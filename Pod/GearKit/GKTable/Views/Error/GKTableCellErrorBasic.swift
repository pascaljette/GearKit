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

/// Basic cell to represent an error while loading the table view controller
public class GKTableCellErrorBasic : UITableViewCell {
    
    /// Default error message
    public class var DEFAULT_ERROR_MESSAGE: String {
        return "ERROR"
    }
    
    /// Default configuration when the cell is created.
    override public func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.textLabel?.text = GKTableCellErrorBasic.DEFAULT_ERROR_MESSAGE
        self.textLabel?.textColor = UIColor.redColor()
        
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        self.detailTextLabel?.textColor = UIColor.redColor()
    }
}

/// GKNibInstance implementation
extension GKTableCellErrorBasic : GKNibInstance {

    /// Name of the associated .xib file
    static var NIB_NAME: String {
        
        return "GKTableCellErrorBasic"
    }
    
}
