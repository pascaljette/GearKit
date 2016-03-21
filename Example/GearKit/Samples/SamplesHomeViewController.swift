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

import UIKit
import GearKit

/// Root table view controller for the application.
class SamplesHomeViewController: GKTableViewControllerBase {
   
    //
    // MARK: Nested types
    //
    
    /// Identifiers for table cells in this table view.
    enum TableCellIdentifiers: String {
        
        case BASIC_CELL = "SamplesHomeBasicCell"
    }
    
    //
    // MARK: Initialisation
    //
    
    /// Empty initializer, picks the nib automatically.
    init() {
        
        super.init(nibName: "SamplesHomeViewController", bundle: nil)
        navigationItem.title = "Home"
    }

    /// Required initialiser with a coder.
    /// We generate a fatal error to underline the fact that we do not want to support storyboards.
    ///
    /// - parameter coder: Coder used to serialize the object.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported (no storyboard support)")
    }
}

extension SamplesHomeViewController {

    //
    // MARK: UIViewController overrides
    //
    
    /// View did load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerNibName(TableCellIdentifiers.BASIC_CELL.rawValue, fromBundle: NSBundle.mainBundle())
        
        tableSections = [customTableCellSection, graphSection, manualLoginSection, keyboardSection]
    }
}

extension SamplesHomeViewController {

    //
    // MARK: Computed Properties
    //
    
    /// Table section for table
    var customTableCellSection: GKTableSectionTitle {
        
        get {
            
            // Graph section
            let customTableCell: GKTableCellBasic = GKTableCellBasic(identifier: TableCellIdentifiers.BASIC_CELL.rawValue
                , title: "GKTable"
                , subTitle: "CustomCell"
                , cellTouchedFunction: { [weak self] _ in
                    self?.showViewController(GKTableCustomCellViewController(), sender: self)
                }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [customTableCell], headerTitle: "GKTable")
        }
    }
    
    // Table section for graph
    var graphSection: GKTableSectionTitle {
        
        get {
            
            // Graph section
            let radarGraphCell: GKTableCellBasic = GKTableCellBasic(identifier: TableCellIdentifiers.BASIC_CELL.rawValue
                , title: "GKGraphs"
                , subTitle: "GKRadarGraph"
                , cellTouchedFunction: { [weak self] _ in
                    
                    self?.showViewController(GKRadarGraphViewController(model: GKRadarGraphModel()), sender: self)
                }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [radarGraphCell], headerTitle: "GKGraph")
        }
    }
    
    // Table section for login
    var manualLoginSection: GKTableSectionTitle {
        
        get {
            
            // Manual login section
            let manualLoginCell: GKTableCellBasic = GKTableCellBasic(identifier: TableCellIdentifiers.BASIC_CELL.rawValue
                , title: "GKManualLogin"
                , subTitle: "GKManualLoginViewController"
                , cellTouchedFunction: { [weak self] _ in
                    self?.showViewController(GKManualLoginViewController(), sender: self)
                }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [manualLoginCell], headerTitle: "GKLogin")
        }
    }
    
    // Table section for keyboard and auto-scrolling
    var keyboardSection: GKTableSectionTitle {
        
        get {
            
            // Manual login section
            let manualLoginCell: GKTableCellBasic = GKTableCellBasic(identifier: TableCellIdentifiers.BASIC_CELL.rawValue
                , title: "Keyboard"
                , subTitle: "ScrollView"
                , cellTouchedFunction: { [weak self] _ in
                    self?.showViewController(GKKeyboardScrollViewController(), sender: self)
                }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [manualLoginCell], headerTitle: "Keyboard")
        }
    }
}
