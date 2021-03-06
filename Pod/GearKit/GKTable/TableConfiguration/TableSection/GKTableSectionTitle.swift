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

/// Represents a section in the table view.  Header and footer are simple strings.  Use GKTableSectionView if you want
/// custom headers and footers.
public class GKTableSectionTitle : GKTableSectionBase {

    //
    // MARK: Stored properties
    //

    /// Title for the section header
    public var headerTitle: String?
    
    /// Title for the section header
    public var footerTitle: String?
    
    //
    // MARK: Initializers
    //
    
    /// Initialization
    ///
    /// - parameter cells: The cell array that comprise the section.  Empty array will have an empty section (no crash)
    /// - parameter headerView: View for the section header.  Nil for no header (default)
    /// - parameter footerView: View for the section footer.  Nil for no footer (default)
    public init(cells: [GKTableCellBase], headerTitle: String? = nil, footerTitle: String? = nil) {
        
        super.init(cells: cells)
        
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
    }
}
