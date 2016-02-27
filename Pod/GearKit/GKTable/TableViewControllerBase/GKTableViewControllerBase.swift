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


/// Base ViewController class to use for functional table views.  Derive your UIViewController from this.
/// UITableViewController is not supported.
public class GKTableViewControllerBase : GKViewControllerBase {
    
    //
    // MARK: IBOutlets
    //
    
    /// IBOutlet for the table view.  Make sure to connect it from the storyboard/xib.
    /// Setting the delegate and datasource is not required and will be overridden in viewDidLoad anyways.
    @IBOutlet public var tableView: UITableView!
    
    //
    // MARK: Stored properties
    //

    /// An array of sections that contain all the configuration information to draw the table.
    public var tableSections: [GKTableSectionBase] = [] {
        
        didSet {
            
            tableView.reloadData()
        }
    }
}
extension GKTableViewControllerBase {
    
    //
    // MARK: Constants
    //
    
    /// Default height for row height estimation.
    private class var DEFAULT_ROW_HEIGHT: CGFloat {
        return 44
    }
    
    //
    // MARK: Computed properties
    //
    
    /// Override this to provide the default estimated row height for your table view.
    /// Remember to make it fast!  This is used esssentially for optimization.
    public var estimatedRowHeight: CGFloat  {
        
        return GKTableViewControllerBase.DEFAULT_ROW_HEIGHT
    }
}

extension GKTableViewControllerBase {
    
    //
    // MARK: Methods
    //
    
    /// Get cell info corresponding to an index path.
    ///
    /// - parameter indexPath: Index path used to retrieve to cell configuration info from the array.
    ///
    /// - returns The cell retrieved from the configuration array.
    public func getCellInfo(indexPath: NSIndexPath) throws -> GKTableCellBase {
        
        return try getCellInfo(indexPath.section, row: indexPath.row)
    }
    
    /// Get cell info corresponding to an index path.
    ///
    /// - parameter section: Section index.
    /// - parameter row: Row index.
    ///
    /// - returns The cell retrieved from the configuration array.
    public func getCellInfo(section: Int, row: Int) throws -> GKTableCellBase {
        
        if tableSections.isInBounds(section)  {
            
            if tableSections[section].cells.isInBounds(row) {
                
                return tableSections[section].cells[row]
            }
        }
        
        throw GKTableViewControllerException.IndexOutOfBounds(section, row)
    }
    
    /// Register a nib from the main bundle (shortcut function)
    ///
    /// - parameter nibName: Name of the nib (filename of the .xib file normally) to register
    /// - parameter forCellReuseIdentifier: Identifier to use for the cell.  Will use the nibName if set to nil (default)
    public func registerNibName(nibName: String, fromBundle: NSBundle = NSBundle.mainBundle(), forCellReuseIdentifier: String? = nil) {
        
        let nib: UINib = UINib(nibName: nibName, bundle: fromBundle)
        let identifier = forCellReuseIdentifier ?? nibName
        
        tableView.registerNib(nib, forCellReuseIdentifier: identifier)
    }
    
    /// Dequeues a cell with a provided identifier, or an empty cell if it fails.
    ///
    /// - parameter identifier: Identifier registered in the table view for the cell.
    ///
    /// - returns The generated UITableView if properly registered or an empty UITableViewCell otherwise.
    public func dequeueCellWithIdentifierOrEmpty(identifier: String) -> UITableViewCell {
        
        return tableView.dequeueReusableCellWithIdentifier(identifier) ?? UITableViewCell()
    }
    
    /// Reload rows after modifying them.
    ///
    /// - parameter indexPaths: Array of indexPaths to reload
    public func reloadRows(indexPaths: [NSIndexPath]) {
        
        tableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Automatic)
    }
}

extension GKTableViewControllerBase {
    
    //
    // MARK: UIViewController overrides
    //
    
    /// viewDidLoad.  Sets the delegate and datasource as well as setting up the table for automatic cell sizing.
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = estimatedRowHeight
        
        let bundle: NSBundle = NSBundle(forClass: GKTableCellErrorBasic.self)
        registerNibName(GKTableCellErrorBasic.NIB_NAME, fromBundle: bundle)
    }
}

extension GKTableViewControllerBase: UITableViewDataSource {
    
    //
    // MARK: UITableViewDataSource
    //
    
    /// Number of sections
    ///
    /// - parameter tableView: Table view instance requesting the number of sections.
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return tableSections.count
    }
    
    /// Number of rows in each section.  Simply calculated from the data in our section array.
    ///
    /// - parameter tableView: Table view instance requesting the number of rows.
    /// - parameter section: Section requesting the number of rows.
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tableSections[section].cells.count
    }
    
    /// Generate the cell from our configuration array and returns the generated instance.
    ///
    /// - parameter tableView: Table view instance requesting the cell generation function.
    /// - parameter indexPath: Index of the cell to generate
    ///
    /// - returns: The generate table view cell. Not optional.  Will return the default 
    /// UITableViewCell() on unhandled exception.
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let generatedCell: UITableViewCell
        
        do {
            
            let cellInfo =  try getCellInfo(indexPath)
            
            generatedCell = cellInfo.configureCellFunction?(tableView, indexPath, cellInfo) ?? UITableViewCell()
            
        } catch GKTableViewControllerException.IndexOutOfBounds(let section, let row) {
            
            generatedCell = dequeueCellWithIdentifierOrEmpty(GKTableCellErrorBasic.NIB_NAME)
            generatedCell.detailTextLabel?.text = "Index out of bounds: section(\(section)), row(\(row))"
            
        } catch {
            
            generatedCell = dequeueCellWithIdentifierOrEmpty(GKTableCellErrorBasic.NIB_NAME)
            generatedCell.detailTextLabel?.text = "Unexpected error"
        }
        
        return generatedCell
    }
    
    /// Generate the title for a section header.
    ///
    /// - parameter tableView: Table view instance requesting the header title.
    /// - parameter section Section for which to assign the header string.
    ///
    /// - returns: Header title string.  Nil for no header.
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        guard let sectionWithTitle = tableSections[section] as? GKTableSectionTitle else {
            
            return nil
        }
        
        return sectionWithTitle.headerTitle
    }
    
    /// Generate the title for a section footer.
    ///
    /// - parameter tableView: Table view instance requesting section title.
    /// - parameter section Section for which to assign the footer string.
    ///
    /// - returns: Footer title string.  Nil for no footer.
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        
        guard let sectionWithTitle = tableSections[section] as? GKTableSectionTitle else {
            
            return nil
        }
        
        return sectionWithTitle.footerTitle
    }

}

extension GKTableViewControllerBase: UITableViewDelegate {
    
    //
    // MARK: UITableViewDelegate
    //
    
    /// Call the callback from the cell configuration array when a row is selected.
    ///
    /// - parameter tableView: Table view instance requesting cell selection.
    /// - parameter indexPath: Index of the selected cell
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //
        if let cellInfo =  try? getCellInfo(indexPath) {
            
            if cellInfo.deselectOnSelected {
                
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
            
            cellInfo.cellTouchedFunction?(tableView, indexPath, cellInfo)
            
        }
    }
    
    /// View for a section header.  Set to nil to have no header.
    ///
    /// - parameter tableView: Table view instance requesting header view.
    /// - parameter section: The section index for which to generate the view.
    ///
    /// - returns: View for header.  Nil for no header.
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let sectionWithView = tableSections[section] as? GKTableSectionView else {
            
            return nil
        }
        
        return sectionWithView.headerView
    }
    
    /// View for a section footer.  Set to nil to have no footer.
    ///
    /// - parameter tableView: Table view instance requesting footer view.
    /// - parameter section: The section index for which to generate the view.
    ///
    /// - returns: View for footer.  Nil for no footer.
    public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        guard let sectionWithView = tableSections[section] as? GKTableSectionView else {
            
            return nil
        }
        
        return sectionWithView.headerView
    }
}

/// Error types
extension GKTableViewControllerBase {
    
    /// Exception thrown when trying to generate the cell from the cell configuration instances.
    public enum GKTableViewControllerException : ErrorType {
        
        /// Index out of bounds when trying to access the cell configuration array
        /// Parameters are (section, row)
        case IndexOutOfBounds(Int, Int)
    }
}
