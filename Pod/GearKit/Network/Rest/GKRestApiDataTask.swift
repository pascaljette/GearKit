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
import SwiftyJSON

/// Status of the connection.
public enum GKRestApiConnectionStatus {
    
    /// Connection has completed successfully.
    case Success
    
    /// Connection has failed.
    case ConnectionError
    
    /// There was an error while building the URL.
    case UrlError
}

/// Performs a connection to the API provided the request and response type.
/// The execute method can be called with an instance of the request type if additional configuration
/// is required.
public class GKRestApiDataTask<RequestType: GKRestApiRequest, ResponseType: GKRestApiResponse> {
    
    //
    // MARK: Nested types
    //
    
    /// Function to call on completion of the connection.
    /// This occurs after the model contained in the response has been populated.
    public typealias OnCompletion = (GKRestApiConnectionStatus, NSError?, ResponseType?) -> Void
    
    //
    // MARK: Stored properties
    //
    
    /// Reference on the inner task used to perform the connection (url session)
    private var task: NSURLSessionTask?
    
    //
    // MARK: Initialisation
    //
    
    /// Parameterless initialiser.
    public init() {
        
    }
}

extension GKRestApiDataTask {
    
    //
    // MARK: Public methods
    //
    
    /// Execute the connection with an external reference on the request.
    /// Useful when the request requires additional configuration.
    ///
    /// - parameter request: The request to execute.
    /// - parameter onCompletion: Completion closure to execute after the response model
    /// has been populated.
    public func executeWith(with request: RequestType, onCompletion: OnCompletion?) {
        
        performCall(with: request, onCompletion: onCompletion)
    }
}

extension GKRestApiDataTask {
    
    //
    // MARK: Private utility methods
    //
    
    /// Perform the connection.
    ///
    /// - parameter request: The configured request used to perform the connection.
    /// - parameter onCompletion: Completion closure to execute after the response model
    /// has been populated.
    private func performCall(with request: RequestType, onCompletion: OnCompletion?) {
        
        // TODO-pk add log or error handling here
        guard let requestFullUrl = request.absoluteUrl else {
            
            let error: NSError = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: nil)
            onCompletion?(.UrlError, error, nil)
            return
        }
        
        self.task = NSURLSession.sharedSession().dataTaskWithURL(requestFullUrl) {(data, response, error) in
            
            guard error == nil else {
                
                onCompletion?(.ConnectionError, error, nil)
                return
            }
            
            if let dataInstance = data {
                
                let json: JSON = JSON(data: dataInstance);
                
                let response: ResponseType = ResponseType(json: json);
                
                onCompletion?(.Success, nil, response)
            }
        }
        
        task!.resume()
    }
}
