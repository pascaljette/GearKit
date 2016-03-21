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

class GKKeyboardScrollViewController: UIViewController {
    
    //
    // MARK: Stored properties
    //
    
    /// Scroll view for the whole screen.
    @IBOutlet weak var scrollView: UIScrollView?
    
    /// 1st textfield from the top.
    @IBOutlet weak var textField1: UITextField?
    
    /// 2nd textfield from the top.
    @IBOutlet weak var textField2: UITextField?
    
    /// 3rd textfield from the top.
    @IBOutlet weak var textField3: UITextField?
    
    /// 4th textfield from the top.
    @IBOutlet weak var textField4: UITextField?
    
    //
    // MARK: GKScrollingKeyboardListener properties
    //

    /// Current active text input field.
    var activeField: UITextInputTraits?
    
    /// Whether the keyboard is being displayed or not.
    var keyboardVisible: Bool = false
    
    //
    // MARK: Initialization
    //
    
    /// Empty initializer, picks the nib automatically.
    init() {
        
        super.init(nibName: "GKKeyboardScrollViewController", bundle: nil)
    }
    
    /// Required initialiser with a coder.
    /// We generate a fatal error to underline the fact that we do not want to support storyboards.
    ///
    /// - parameter coder: Coder used to serialize the object.
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    /// Deinit.
    deinit {
        
        removeKeyboardObserver()
    }

}

extension GKKeyboardScrollViewController {

    //
    // MARK: UIViewController overrides
    //
    
    /// View did load.
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        addKeyboardObserver()
        
        textField1?.delegate = self
        textField2?.delegate = self
        textField3?.delegate = self
        textField4?.delegate = self
    }
    
    /// View will disappear or be dismissed.
    /// Remove the keyboard observer here as well, in case the view is not deinitialised right away.
    ///
    /// - parameter animated: Whether the view dismissal is animated or not.
    override func viewWillDisappear(animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        removeKeyboardObserver()
    }
}

extension GKKeyboardScrollViewController: GKScrollingKeyboardListener {
    
    //
    // MARK: GKScrollingKeyboardListener implementation
    //

    /// Keyboard did appear
    ///
    /// - parameter notification: The notification triggering the keyboard event.
    func keyboardDidAppear(notification: NSNotification) {

        adjustInsetsOnKeyboardShow(notification)
    }
    
    /// Keyboard Will disappear
    ///
    /// - parameter notification: The notification triggering the keyboard event.
    func keyboardWillDisappear(notification: NSNotification) {
        
        adjustInsetsOnKeyboardHide(notification)
    }

}

extension GKKeyboardScrollViewController: UITextFieldDelegate {
    
    //
    // MARK: UITextFieldDelegate implementation
    //

    /// Return button has been pressed.
    ///
    /// - parameter textField: Textfield owning the return button.
    ///
    /// - returns: True if it should process the return event, false otherwise.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    /// Textfield has begun editing (became first responder).
    ///
    /// - parameter textField: Textfield reference that began editing..
    func textFieldDidBeginEditing(textField: UITextField) {
        
        activeField = textField
    }
    
    /// Textfield has ended editing (resigned first responder).
    ///
    /// - parameter textField: Textfield reference that ended editing..
    func textFieldDidEndEditing(textField: UITextField) {
        
        activeField = nil
    }
}
