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

//
// MARK: Class declaration
//
class GKKeyboardScrollViewController: UIViewController {
    
    
    //
    // MARK: Stored properties
    //
    @IBOutlet weak var scrollView: UIScrollView?
    @IBOutlet weak var textField1: UITextField?
    @IBOutlet weak var textField2: UITextField?
    @IBOutlet weak var textField3: UITextField?
    @IBOutlet weak var textField4: UITextField?
    
    //
    // MARK: GKScrollingKeyboardListener properties
    //

    var activeField: UITextInputTraits?
    var keyboardVisible: Bool = false
    
    //
    // MARK: Initialization
    //
    deinit {
        
        removeKeyboardObserver()
    }

}

//
// MARK: UIViewController overrides
//
extension GKKeyboardScrollViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        addKeyboardObserver()
        
        textField1?.delegate = self
        textField2?.delegate = self
        textField3?.delegate = self
        textField4?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
}

//
// MARK: GKScrollingKeyboardListener implementation
//
extension GKKeyboardScrollViewController: GKScrollingKeyboardListener {
    
    func keyboardDidAppear(notification: NSNotification) {

        adjustInsetsOnKeyboardShow(notification)
    }
    
    
    func keyboardWillDisappear(notification: NSNotification) {
        
        adjustInsetsOnKeyboardHide(notification)
    }

}

//
// MARK: UITextFieldDelegate implementation
//
extension GKKeyboardScrollViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeField = nil
    }
}
