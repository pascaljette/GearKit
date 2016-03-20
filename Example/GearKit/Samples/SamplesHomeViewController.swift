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
   
    init() {
        
        super.init(nibName: "SamplesHomeViewController", bundle: nil)
        navigationItem.title = "Home"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported (no storyboard support)")
    }
}

//
// MARK: UIViewControllerOverrides
//
extension SamplesHomeViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableSections = [tableSection, graphSection, manualLoginSection, keyboardSection]
    }
}

//
// MARK: Computed Properties
//
extension SamplesHomeViewController {
    
    // Table section for table
    var tableSection: GKTableSectionTitle {
        
        get {
            
            // Graph section
            let customTableCell: GKTableCellBasic = GKTableCellBasic(identifier: "RootViewControllerBasicCell"
                , title: "GKTable"
                , subTitle: "CustomCell"
                , cellTouchedFunction: { [weak self] _ in
                }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [customTableCell], headerTitle: "GKTable")
        }
    }
    
    // Table section for graph
    var graphSection: GKTableSectionTitle {
        
        get {
            
            // Graph section
            let radarGraphCell: GKTableCellBasic = GKTableCellBasic(identifier: "RootViewControllerBasicCell"
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
            let manualLoginCell: GKTableCellBasic = GKTableCellBasic(identifier: "RootViewControllerBasicCell"
                , title: "GKManualLogin"
                , subTitle: "GKManualLoginViewController"
                , cellTouchedFunction: { [weak self] _ in }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [manualLoginCell], headerTitle: "GKLogin")
        }
    }
    
    // Table section for keyboard and auto-scrolling
    var keyboardSection: GKTableSectionTitle {
        
        get {
            
            // Manual login section
            let manualLoginCell: GKTableCellBasic = GKTableCellBasic(identifier: "RootViewControllerBasicCell"
                , title: "Keyboard"
                , subTitle: "ScrollView"
                , cellTouchedFunction: { [weak self] _ in }
                , deselectOnSelected: true)
            
            return GKTableSectionTitle(cells: [manualLoginCell], headerTitle: "Keyboard")
        }
    }
    
}
