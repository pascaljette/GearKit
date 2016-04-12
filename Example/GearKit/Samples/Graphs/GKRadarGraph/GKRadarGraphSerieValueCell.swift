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

class GKRadarGraphSerieValueCell : UITableViewCell {
    
    @IBOutlet weak var parameterNameLabel: UILabel!
    
    @IBOutlet weak var parameterValueField: UITextField!
    
    /// TODO-pk change this to a proper delegate
    weak var tableView: UITableView?
    
    // TODO-pk awful waste of memory, fix this.
    var model: GKRadarGraphModel?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 50))
        numberToolbar.barStyle = .Default
        
        numberToolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .Done, target: self, action: #selector(GKRadarGraphSerieValueCell.keyboardDoneButtonTapped))]
        
        numberToolbar.sizeToFit()
        
        parameterValueField.delegate = self
        parameterValueField.inputAccessoryView = numberToolbar
    }
}

extension GKRadarGraphSerieValueCell : UITextFieldDelegate {
    
    //
    // MARK: UITextFieldDelegate implementation
    //
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        guard let tableViewInstance = tableView else {
            
            return
        }
        
        guard let indexPath = tableViewInstance.indexPathForCell(self) else {
            
            return
        }

        var contentInsets: UIEdgeInsets = tableViewInstance.contentInset
        contentInsets.bottom += (tableViewInstance.frame.height - self.frame.height)
        tableView?.contentInset = contentInsets
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        guard let tableViewInstance = tableView else {
            
            return
        }
        
        var contentInsets: UIEdgeInsets = tableViewInstance.contentInset
        contentInsets.bottom -= (tableViewInstance.frame.height - self.frame.height)
        tableView?.contentInset = contentInsets
    }

}

extension GKRadarGraphSerieValueCell {
    
    //
    // MARK: Keyboard Toolbar buttons selectors
    //
    
    func keyboardDoneButtonTapped(sender: UIBarButtonItem!) {
        
        print("Done")
        parameterValueField.resignFirstResponder()
    }
}

