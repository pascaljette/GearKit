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

/// Base class for a view controller with login.
/// Uses IBOutlets for all fields.
public class GKManualLoginViewControllerBase: GKViewControllerBase {

    //
    // MARK: IBOutlets
    //

    /// Textfield for the username box.
    @IBOutlet weak public var userNameTextField: UITextField?
    
    /// Textfield for the password box.
    @IBOutlet weak public var passwordTextField: UITextField?
    
    /// Button that starts the login procedure.
    @IBOutlet weak public var loginButton: UIButton?

    /// Switch to activate auto-login (remember authentication credentials)
    @IBOutlet weak public var rememberMeSwitch: UISwitch?
    
    //
    // MARK: Stored properties
    //
    
    /// Username value from the textfield.
    public var userName: String?
    
    /// Password value from the textfield.
    public var password: String?
    
    /// Delegate that performs the actual login operations
    public weak var loginDelegate: GKManualLoginDelegate?
}

extension GKManualLoginViewControllerBase {
    //
    // MARK: Computed properties
    //
    
    /// Returns the value of the remember switch.  If the switch instance is nil, returns the
    /// default value (false)
    public var rememberMe: Bool {
        return rememberMeSwitch?.on ?? false
    }
}

extension GKManualLoginViewControllerBase {
    //
    // MARK: IBActions
    //
    
    /// Called when the login button is pressed.  Attach your Touch Up Inside event from 
    /// the login button to this ib action.  The actual login action will be performed in the delegate's
    /// performLogin() implementation
    @IBAction func loginButtonPressed(sender: AnyObject) {
        
        self.view.endEditing(true)
        loginDelegate?.performLogin()
    }
}

extension GKManualLoginViewControllerBase {
    //
    // MARK: UIViewController overrides
    //
    
    /// View did load.  Setup all the actions and parameters of our UI elements.
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
    
    /// View did appear.  Make the username textfield the first responder when the view appears.
    ///
    /// - parameter animated: Whether to animate the viewDidAppear action.
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        userNameTextField?.becomeFirstResponder()
    }
    
    /// View did disappear.  Make sure the keyboard is dismissed when the view disappears
    /// (sanity check)
    ///
    /// - parameter animated: Whether to animate the viewDidDisappear action.
    public override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        view.endEditing(true)
    }
}

extension GKManualLoginViewControllerBase: UITextFieldDelegate {
    
    //
    // MARK: UITextFieldDelegate implementation
    //
    
    /// Executed when the 'Return' or 'Done' button is pressed.
    /// If the username is the currently active textfield, automatically go to the password
    /// textfield.  If the password is the currently active textfield, perform the login operation.
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
}

extension GKManualLoginViewControllerBase {
    
    //
    // MARK: Value changed callbacks
    //

    
    /// Called when the username text field value changed.  Update the userName value and
    /// change the login button's enabled status.
    ///
    /// - parameter sender: The textfield sending the event
    internal func usernameTextFieldValueChanged(sender: AnyObject) {
        
        guard let usernameField = sender as? UITextField else {
            return
        }
        
        userName = usernameField.text ?? ""
        
        loginButton?.enabled = !isUsernameOrPasswordEmpty()
    }
    
    /// Called when the password text field value changed.  Update the userName value and
    /// change the login button's enabled status.
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

extension GKManualLoginViewControllerBase {

    //
    // MARK: Private methods
    //
    
    /// Check whether the username and password fields are empty.
    ///
    /// - returns True if either the username or password values are empty, false otherwise.
    private func isUsernameOrPasswordEmpty() -> Bool {
        
        return (String.isNilOrEmpty(userName) || String.isNilOrEmpty(password))
    }
}
