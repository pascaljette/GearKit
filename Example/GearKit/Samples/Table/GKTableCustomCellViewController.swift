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

class GKTableCustomCellViewController : GKTableViewControllerBase {

    //
    // MARK: Nested Types
    //
    
    enum CellIdentifiers: String {
        
        case TRIPLE_LABEL = "GKTableCustomTripleLabelCell"
        case LABEL_BUTTON = "GKTableCustomLabelButtonCell"
    }
    
    //
    // MARK: Initialization
    //
    
    /// Empty initializer, picks the nib automatically.
    init() {
        
        super.init(nibName: "GKTableCustomCellViewController", bundle: nil)
    }
    
    /// Required initialiser with a coder.
    /// We generate a fatal error to underline the fact that we do not want to support storyboards.
    ///
    /// - parameter coder: Coder used to serialize the object.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
}

extension GKTableCustomCellViewController {
    
    //
    // MARK: UIViewController overrides
    //

    /// View did load.
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationItem.title = "GKTableCustomCell"
    }
}
