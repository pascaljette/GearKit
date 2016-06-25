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

/// A request where we provide the full Url.  This is useful for URLs for the PokeApi
/// that are retrieved from JSON responses themselves and therefore include the base URL as well.
public protocol GKRestApiRequestAbsolutePath : GKRestApiRequest {
    
    /// Path of the function to call.
    var absoluteUrlString: String { get set }
    
    /// Initialise with a full Url.
    init(absoluteUrlString: String)
}

public extension GKRestApiRequestAbsolutePath {
    
    /// Build absolute url based on all url components in the type.
    var absoluteUrl: NSURL? {
        
        guard let queryItemsInstance = queryItems else  {
            
            return NSURL(string: absoluteUrlString)
        }
        
        guard let components = NSURLComponents(string: absoluteUrlString) else {
            
            print("Could not find URL components from string \(absoluteUrlString)")
            return nil
        }
        
        if let _ = components.queryItems {
            
            components.queryItems!.appendContentsOf(queryItemsInstance)
            
        } else {
            
            components.queryItems = queryItemsInstance
        }
        
        return components.URL
    }
}
