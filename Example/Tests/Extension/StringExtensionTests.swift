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

import Quick
import Nimble
import GearKit

/// Tests for Swift String extension methods
class StringExtensionSpec: QuickSpec {
    
    override func spec() {
        
        describe("Nil or empty tests") {
            
            ///
            /// MARK: Nil or empty Swift string
            ///
            context("Nil or empty Swift string") {
                
                it("should return true when a string is nil") {
                    
                    let myString: String? = nil
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when a string is nil (implicitly unwrapped)") {
                    
                    let myString: String! = nil
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when a string is empty") {
                    
                    let myString: String = ""
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when an optional string is empty") {
                    
                    let myString: String? = ""
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }

                it("should return true when an optional string is empty (implicitly unwrapped)") {
                    
                    let myString: String! = ""
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
            }
            
            ///
            /// MARK: Nil or empty NSString
            ///
            context("Nil or empty Swift string") {
                
                it("should return true when a string is nil") {
                    
                    let myString: NSString? = nil
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when a string is nil (implicitly unwrapped)") {
                    
                    let myString: NSString! = nil
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when a string is empty") {
                    
                    let myString: NSString = ""
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when an optional string is empty") {
                    
                    let myString: NSString? = ""
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
                
                it("should return true when an optional string is empty (implicitly unwrapped)") {
                    
                    let myString: NSString! = ""
                    expect(String.isNilOrEmpty(myString)).to(beTrue())
                }
            }
            
            
            ///
            /// MARK: Swift string with proper value
            ///
            context("Swift string with proper value") {
                
                it("should return false when a string is not nil") {
                    
                    let myString: String? = "Hello World"
                    expect(String.isNilOrEmpty(myString)).to(beFalse())
                }
                
                it("should return false when a string is not nil (implicitly unwrapped)") {
                    
                    let myString: String! = "Hello World"
                    expect(String.isNilOrEmpty(myString)).to(beFalse())
                }
                
                it("should return false when a string is not empty") {
                    
                    let myString: String = "Hello World"
                    expect(String.isNilOrEmpty(myString)).to(beFalse())
                }
            }
            
            ///
            /// MARK: NSString string with proper value
            ///
            context("Swift string with proper value") {
                
                it("should return false when a string is not nil") {
                    
                    let myString: NSString? = "Hello World"
                    expect(String.isNilOrEmpty(myString)).to(beFalse())
                }
                
                it("should return false when a string is not nil (implicitly unwrapped)") {
                    
                    let myString: NSString! = "Hello World"
                    expect(String.isNilOrEmpty(myString)).to(beFalse())
                }
                
                it("should return false when a string is not empty") {
                    
                    let myString: NSString = "Hello World"
                    expect(String.isNilOrEmpty(myString)).to(beFalse())
                }
            }
        }
    }
}
