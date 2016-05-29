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

// https://github.com/Quick/Quick

import Foundation
import GearKit
import SwiftyJSON
import Quick
import Nimble

class JsonPlaceHolderRequest: GKRestApiRequestRelativePath {
    
    /// Query items (path parameter).
    var queryItems: [NSURLQueryItem]? {
        return nil
    }
    
    /// Path of the function to call.
    var relativePath: String = "/posts/1"
    
    /// Path of the base API
    var basePath: String {
        return "http://jsonplaceholder.typicode.com"
    }
}

struct TestModel {

    var userId: String = ""
    var id: String = ""
    var title: String = ""
    var body: String = ""
}

class JsonPlaceHolderResponse: GKRestApiResponse {
    
    typealias ModelType = TestModel
    
    /// Initialize from json.
    ///
    /// - parameter json: JSON or subJSON data with which to initialize.
    required init(json: JSON) {
        
        var newModel: ModelType = ModelType()
        newModel.userId = String(json["userId"].int ?? 0)
        newModel.id = String(json["id"].int ?? 0)
        newModel.title = json["title"].string ?? ""
        newModel.body = json["body"].string ?? ""
        
        self.model = newModel
    }
    
    /// Model instance.
    var model: ModelType
}

/// Tests for Swift Array extension methods
class GKRestApiSpec: QuickSpec {
    
    typealias PostOneDataTask = GKRestApiDataTask<JsonPlaceHolderRequest, JsonPlaceHolderResponse>
    
    override func spec() {
        
        describe("JsonPlaceHolder with static path") {
            
            let request: JsonPlaceHolderRequest = JsonPlaceHolderRequest()
            
            ///
            /// MARK: Array contains valid Integers
            ///
            context("Success use case") {
                
                let dataTask = PostOneDataTask()
                
                it("Should populate the model properly") {
                    
                    waitUntil(timeout: 10) { done in
                        
                        dataTask.executeWith(with: request, onCompletion: {status, error, response in
                            
                            GKThread.dispatchOnUiThread {
                                
                                expect(response?.model.userId).to(equal("1"))
                                expect(response?.model.id).to(equal("1"))
                                expect(response?.model.title).toNot(beEmpty())
                                expect(response?.model.body).toNot(beEmpty())
                                
                                done()
                            }
                        })
                    }
                }
            }
        }
    }
}

