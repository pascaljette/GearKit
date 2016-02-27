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

/// Tests for Swift Array extension methods
class ArrayExtensionSpec: QuickSpec {
    
    
    override func spec() {
        
        describe("Array bounds check") {
            
            var myArray: [Int?]!
            
            ///
            /// MARK: Array contains valid Integers
            ///
            context("Array contains valid Integers") {
                
                beforeEach {
                    
                    myArray = [1, 2, 3]
                }
                
                it("should return true when in bounds") {
                    
                    expect(myArray.isInBounds(1)).to(beTrue())
                }
                
                it("should return false when out of bounds") {
                    
                    expect(myArray.isInBounds(4)).to(beFalse())
                }
                
                it("should return false when using an invalid index") {
                    
                    expect(myArray.isInBounds(-1)).to(beFalse())
                }
            }
            
            ///
            /// MARK: Array contains valid Integers and nil values
            ///
            context("Array contains valid Integers and nil values") {
                
                beforeEach {
                    
                    myArray = [1, nil, 3]
                }
                
                it("should return true when in bounds") {
                    
                    expect(myArray.isInBounds(1)).to(beTrue())
                }
                
                it("should return false when out of bounds") {
                    
                    expect(myArray.isInBounds(4)).to(beFalse())
                }
                
                it("should return false when using an invalid index") {
                    
                    expect(myArray.isInBounds(-1)).to(beFalse())
                }
            }

            ///
            /// MARK: Array contains only nil values
            ///
            context("Array contains only nil values") {
                
                beforeEach {
                    
                    myArray = [nil, nil, nil]
                }
                
                it("should return true when in bounds") {
                    
                    expect(myArray.isInBounds(1)).to(beTrue())
                }
                
                it("should return false when out of bounds") {
                    
                    expect(myArray.isInBounds(4)).to(beFalse())
                }
                
                it("should return false when using an invalid index") {
                    
                    expect(myArray.isInBounds(-1)).to(beFalse())
                }
            }
        }
    }
}
