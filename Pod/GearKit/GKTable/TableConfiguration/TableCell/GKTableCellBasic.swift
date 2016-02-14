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

/// Table cell with only the basic information (system defined cells in XCode).  Title, subtitle, accessory view
public class GKTableCellBasic : GKTableCellBase {
    
    //
    // MARK: Stored properties
    //
    
    /// Title for the cell. Corresponds to textLabel.
    public var title: String?
    
    /// Subtitle for the cell.  Corresponds to detailTextLabel.
    public var subTitle: String?
    
    /// Accessory for the cell. Corresponds to
    public var accessoryView: UIView?
    
    //
    // MARK: Initializers
    //

    /// Intialize the basic cell (see Interface Builder basic types)
    ///
    /// - parameter identifier: Cell identifier for reuse.
    /// - parameter title: String to use textLabel.
    /// - parameter subTitle: String to use for detailTextLabel.
    /// - parameter cellTouchedFunction: Function to call when the cell is pressed.
    /// - parameter deselectOnSelected: Whether to remove the selected background automaticallt when the cell is deselected.
    public init(identifier: String
        , title: String? = nil
        , subTitle: String? = nil
        , cellTouchedFunction: CellTouchedFunction? = nil
        , deselectOnSelected: Bool = true) {
            
            self.title = title
            self.subTitle = subTitle
            
            super.init(identifier: identifier
                , deselectOnSelected: deselectOnSelected)
            
            self.cellTouchedFunction = cellTouchedFunction
            self.configureCellFunction = defaultBasicCellConfiguration
    }
}

//
// MARK: Cell configuration methods
//
extension GKTableCellBasic {

    /// Default cell configuration function for basic cells.
    ///
    /// - parameter tableView: TableView in which the cell is contained.
    /// - parameter indexPath: Index of the cell to configure.
    ///
    /// - returns The generated cell from the provided configuration information.
    public func defaultBasicCellConfiguration(tableView: UITableView, indexPath: NSIndexPath, cellInfo: GKTableCellBase) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellInfo.identifier)
        
        guard let basicCellInfo = cellInfo as? GKTableCellBasic else {
            
            return cell ?? UITableViewCell()
        }
        
        cell?.textLabel?.text = basicCellInfo.title
        cell?.detailTextLabel?.text = basicCellInfo.subTitle
        cell?.accessoryView = basicCellInfo.accessoryView
        
        return cell ?? UITableViewCell()
    }
}

