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


/// Base class for creating functional table cells.
public class GKTableCellBase {
    
    //
    // MARK: Type aliases
    //
    
    /// Function called when the cell is pressed
    public typealias CellTouchedFunction = (UITableView, NSIndexPath, GKTableCellBase) -> Void
    
    /// Function called to draw the cell
    public typealias ConfigureCellFunction = (UITableView, NSIndexPath, GKTableCellBase) -> UITableViewCell
    
    //
    // MARK: Stored properties
    //
    
    /// Cell identifier for reuse
    public var identifier: String
    
    /// Function called when the cell is pressed
    public var cellTouchedFunction: CellTouchedFunction?
    
    /// Function called to draw the cell
    public var configureCellFunction: ConfigureCellFunction?
    
    /// Override to determine whether the cell selected status should be animated to non-selected
    /// when it is pressed.  This is to make sure non-persistent selections have a slick UI.
    public var deselectOnSelected: Bool
    
    //
    // MARK: Initializers
    //
    
    /// Basic Initializer
    ///
    /// - parameter identifer: Cell identifier for reuse
    /// - parameter deselectOnSelected:  Whether to animate a deselection animation for non-persistent cell
    public init(identifier: String
        , deselectOnSelected: Bool) {
            
            self.identifier = identifier
            self.deselectOnSelected = deselectOnSelected
    }

}
