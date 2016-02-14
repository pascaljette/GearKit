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

//
// MARK: Stored properties
//

/// Base class for a view controller with login.
public class GKManualLoginViewControllerBase: GKViewControllerBase {
    
    @IBOutlet weak public var userNameTextField: UITextField?
    @IBOutlet weak public var passwordTextField: UITextField?
    
    @IBOutlet weak public var loginButton: UIButton?

    @IBOutlet weak public var rememberMeSwitch: UISwitch?
    
    public var userName: String?
    public var password: String?
    
    public weak var loginDelegate: GKManualLoginDelegate?
    
    private var _activeField: UITextInputTraits?
}

//
// MARK: Computed properties
//
/// Base class for a view controller with login.
extension GKManualLoginViewControllerBase {

    public var rememberMe: Bool {
        return rememberMeSwitch?.on ?? false
    }
}

/// IBActions
extension GKManualLoginViewControllerBase {
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        loginDelegate?.performLogin()
    }
}

//
// MARK: UIViewController overrides
//
extension GKManualLoginViewControllerBase {
    
    /// View did load
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the selectors for when the text value changes.  This provides an immediate update to the username/password
        // variables whenever something is changed in the text field.  Note that this will not be called when
        // the text is auto-corrected or programatically changed.
        userNameTextField?.addTarget(self, action: "usernameTextFieldValueChanged:", forControlEvents: .EditingChanged)
        passwordTextField?.addTarget(self, action: "passwordTextFieldValueChanged:", forControlEvents: .EditingChanged)
        
        // enable the clear button while editing for both fields
        userNameTextField?.clearButtonMode = .WhileEditing
        passwordTextField?.clearButtonMode = .WhileEditing
        
        // Auto-correct should not be needed for either fields
        userNameTextField?.autocorrectionType = .No
        passwordTextField?.autocorrectionType = .No

        // Set the secure text entry fields
        userNameTextField?.secureTextEntry = false
        passwordTextField?.secureTextEntry = true
        
        // Set the delegates for the done button
        userNameTextField?.delegate = self
        
        passwordTextField?.delegate = self
        
        // When the view loads, both fields are empty so the login button shouldn't be enabled
        loginButton?.enabled = !isUsernameOrPasswordEmpty()
    }
    
    /// View did appear
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userNameTextField?.becomeFirstResponder()
    }
    
    /// View did disappear
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        view.endEditing(true)
    }
}

//
// MARK: UITextFieldDelegate implementation
//
extension GKManualLoginViewControllerBase: UITextFieldDelegate {
    
    /// Executed when the 'Return' or 'Done' button is pressed
    public func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        guard !String.isNilOrEmpty(textField.text) else {
            
            return false
        }
        
        if textField === userNameTextField {
            
            passwordTextField?.becomeFirstResponder()

        } else if textField === passwordTextField {
            
            passwordTextField?.resignFirstResponder()
            
            if String.isNilOrEmpty(userName) {
                
                userNameTextField?.becomeFirstResponder()
                
            } else {
                
                loginDelegate?.performLogin()
            }
        }
        
        return true
    }
    
    // became first responder
    public func textFieldDidBeginEditing(textField: UITextField) {
        
        _activeField = textField
    }
    
    public func textFieldDidEndEditing(textField: UITextField)  {
        
        _activeField = nil
    }

}

//
// MARK: Value changed methods
//
extension GKManualLoginViewControllerBase {
    
    /// Called when the username text field value changed
    ///
    /// - parameter sender: The textfield sending the event
    internal func usernameTextFieldValueChanged(sender: AnyObject) {
        
        guard let usernameField = sender as? UITextField else {
            return
        }
        
        userName = usernameField.text ?? ""
        
        loginButton?.enabled = !isUsernameOrPasswordEmpty()
    }
    
    /// Called when the username text field value changed
    ///
    /// - parameter sender: The textfield sending the event
    internal func passwordTextFieldValueChanged(sender: AnyObject) {
        
        guard let passwordField = sender as? UITextField else {
            return
        }
        
        password = passwordField.text ?? ""
        
        loginButton?.enabled = !isUsernameOrPasswordEmpty()
    }
}

//
// MARK: Private methods
//
extension GKManualLoginViewControllerBase {

    /// Check whether the username and password fields are empty.
    ///
    /// - returns True if either the username or password values are empty, false otherwise.
    private func isUsernameOrPasswordEmpty() -> Bool {
        
        return (String.isNilOrEmpty(userName) || String.isNilOrEmpty(password))
    }
}
