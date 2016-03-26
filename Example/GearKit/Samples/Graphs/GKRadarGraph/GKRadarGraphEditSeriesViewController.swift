//
//  GKRadarGraphEditSeriesViewController.swift
//  GearKit
//
//  Created by Pascal Jette on 3/21/16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import Foundation
import UIKit
import GearKit

class GKRadarGraphEditSeriesViewController : GKTableViewControllerBase {
    
    //
    // MARK: Nested types
    //
    
    /// Identifiers for table cells in this table view.
    enum TableCellIdentifiers: String {
        
        case SERIE_VALUE = "GKRadarGraphSerieValueCell"
    }

    private typealias SerieValueCell = GKTableCellCustom<GKRadarGraphModel>
    
    //
    // MARK: Stored properties
    //

    let graphData: GKRadarGraphModel
    
    //
    // MARK: Initialisation.
    //
    
    /// Initialise with a model.
    ///
    /// - parameter model: Model to use to initialise the view controller.
    init(graphData: GKRadarGraphModel) {
        
        self.graphData = graphData
        super.init(nibName: "GKRadarGraphEditSeriesViewController", bundle: nil)
    }
    
    /// Required initialiser with a coder.
    /// We generate a fatal error to underline the fact that we do not want to support storyboards.
    ///
    /// - parameter coder: Coder used to serialize the object.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension GKRadarGraphEditSeriesViewController {
    
    //
    // MARK: UIViewController overrides
    //
    
    /// View did load.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Edit Series"
        
        registerNibName(TableCellIdentifiers.SERIE_VALUE.rawValue, fromBundle: NSBundle.mainBundle())
        
        generateTableSections()
    }
}

extension GKRadarGraphEditSeriesViewController {
    
    //
    // MARK: Private methods
    //
    
    /// View did load.
    private func generateTableSections() {
        
        var localTableSections: [GKTableSectionTitle] = []
        
        for serie in graphData.series {
        
            var valueCells: [SerieValueCell] = []
            
            for _: Int in 0..<graphData.parameters.count {
                
                let singleCell = SerieValueCell(identifier: TableCellIdentifiers.SERIE_VALUE.rawValue
                    , model: graphData
                    , configureCellFunction: configureValueCell
                    , cellTouchedFunction: valueCellTapped
                    , deselectOnSelected: true)
                
                valueCells.append(singleCell)
            }
            
            let newSection = GKTableSectionTitle(cells: valueCells, headerTitle: serie.name ?? "<Unnamed>")
            
            localTableSections.append(newSection)
        }
        
        tableSections = localTableSections
    }
    
    func configureValueCell(tableView: UITableView, indexPath: NSIndexPath, cellInfo: GKTableCellBase) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCellWithIdentifier(cellInfo.identifier) as? GKRadarGraphSerieValueCell else {
            
            // TODO-pk return the error cell here.
            return UITableViewCell()
        }
        
        guard let model = (cellInfo as? SerieValueCell)?.model else {
            
            // TODO-pk return the error cell here.
            return cell ?? UITableViewCell()
        }
        
        cell.model = model
        
        cell.parameterNameButton.setTitle(model.parameters[indexPath.row].name, forState: .Normal)
        
        cell.parameterValueField.text = String(model.series[indexPath.section].percentageValues[indexPath.row])
        
        return cell ?? UITableViewCell()
    }

    
    private func valueCellTapped(tableView: UITableView, indexPath: NSIndexPath, cellInfo: GKTableCellBase) {
     
        
        print(graphData.series[indexPath.section].percentageValues[indexPath.row])
    }
}
