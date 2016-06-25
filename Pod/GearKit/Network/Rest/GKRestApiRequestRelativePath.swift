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

/// A request where we provide only the API path.  This is useful for static APIs
/// define in the app itself where we don't want/need to provide the base url string.
public protocol GKRestApiRequestRelativePath : GKRestApiRequest {
    
    /// Path of the function to call.
    var relativePath: String { get set }
    
    /// Path of the base API
    var basePath: String { get }
}

public extension GKRestApiRequestRelativePath {
    
    /// Build absolute url based on all url components in the type.
    var absoluteUrl: NSURL? {
        
        guard let url: NSURL = NSURL(string: basePath) else {
            
            print("Could not form url from string \(basePath)")
            return nil;
        }
        
        guard let components: NSURLComponents = NSURLComponents(URL: url, resolvingAgainstBaseURL: true) else {
            
            print("Could not find URL components from string \(basePath)")
            return nil
        }
        
        // NSURLComponents does not get fully initialized, even passing a NSURL in its constructor.
        // We must do it manually.  There might be a better way (XCode 7.3)
        components.scheme = url.scheme
        components.host = url.host
        components.path = relativePath
        components.queryItems = queryItems

        return components.URL
    }
}
