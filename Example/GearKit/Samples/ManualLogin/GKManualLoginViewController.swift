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

class GKManualLoginViewController: GKManualLoginViewControllerBase {
    
    @IBOutlet weak var scrollView: UIScrollView!
}

//
// MARK: UIViewController overrides
//
extension GKManualLoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//
// MARK: GKManualLoginDelegate implementation
//
extension GKManualLoginViewController: GKManualLoginDelegate {
    
    // Perform login
    func performLogin() {
        
        print("User Name: \(userName ?? "")")
        print("Password: \(password ?? "")")
        print("Remember Me?: \(rememberMe)")
    }
}

/// Private methods
extension GKManualLoginViewController {
    
}
