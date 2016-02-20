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
class CGFloatExtensionSpec: QuickSpec {
    
    
    override func spec() {
        
        equalWithEpsilonTests()
        degreesRadiansConversionTests()
    }
    
    ///
    /// MARK: isEqualWithEpsilon
    ///
    
    /// Test the CGFloat isEqualWithEpsilon extension method
    func equalWithEpsilonTests() {
        
        describe("Float is equal to epsilon") {
            
            var firstValue: CGFloat!
            var secondValue: CGFloat!
            var epsilon: CGFloat!
            
            ///
            /// MARK: Epsilon is 0
            ///
            context("Epsilon is 0") {
                
                beforeEach {
                    
                    epsilon = 0
                }
                
                it("should return true when floats are positive and equal") {
                    
                    firstValue = 10.0
                    secondValue = 10.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == true
                }
                
                it("should return true when floats are negative and equal") {
                    
                    firstValue = -10.0
                    secondValue = -10.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == true
                }
                
                it("should return false when floats are positive and not equal") {
                    
                    firstValue = 10.0
                    secondValue = 10.1
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
                
                it("should return false when floats are negative and not equal") {
                    
                    firstValue = -10.0
                    secondValue = -10.1
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
                
                it("should return false when floats are positive/negative and not equal") {
                    
                    firstValue = 10.0
                    secondValue = -10.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
                
                it("should return false when floats are negative and not equal") {
                    
                    firstValue = -10.0
                    secondValue = 10.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
            }
            
            ///
            /// MARK: Epsilon is not 0
            ///
            context("Epsilon is not 0") {
                
                beforeEach {
                    
                    epsilon = 10
                }
                
                it("should return true when floats are positive and equal with epsilon") {
                    
                    firstValue = 10.0
                    secondValue = 19.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == true
                }
                
                it("should return true when floats are negative and equal with epsilon") {
                    
                    firstValue = -19.0
                    secondValue = -10.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == true
                }
                
                it("should return true when floats are positive/negative and equal with epsilon") {
                    
                    firstValue = 6.0
                    secondValue = -3.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == true
                }
                
                it("should return true when floats are negative/positive and equal with epsilon") {
                    
                    firstValue = -5.0
                    secondValue = 2.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == true
                }
                
                it("should return false when floats are positive and not equal with epsilon") {
                    
                    firstValue = 10.0
                    secondValue = 21.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
                
                it("should return false when floats are negative and not equal with epsilon") {
                    
                    firstValue = -21.0
                    secondValue = -10.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
                
                it("should return false when floats are positive/negative and not equal with epsilon") {
                    
                    firstValue = 6.0
                    secondValue = -5.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
                
                it("should return false when floats are negative/positive and not equal with epsilon") {
                    
                    firstValue = -5.0
                    secondValue = 9.0
                    
                    expect(firstValue.isEqualWithEpsilon(secondValue, epsilon: epsilon)) == false
                }
            }
        }
    }
    
    
    ///
    /// MARK: degreesToRadians / radiansToDegrees
    ///
    
    /// Test the CGFloat isEqualWithEpsilon extension method
    
    func degreesRadiansConversionTests() {
        
        describe("Degrees to Radians and Radians to degrees") {
            
            context("Convert from 0") {
                
                it("should return 0 when converting degrees -> radians") {
                    
                    expect(CGFloat.degreesToRadians(degrees: 0)) == 0
                }
                
                it("should return 0 when converting radians -> degrees") {
                    
                    expect(CGFloat.radiansToDegrees(radians: 0)) == 0
                }
            }
            
            context("Convert from smaller than a full circle") {
                
                it("should return M_PI / 2 when converting 90 degrees -> radians") {
                    
                    expect(CGFloat.degreesToRadians(degrees: 90)) == CGFloat(M_PI_2)
                }
                
                it("should return 0 when converting radians -> degrees") {
                    
                    expect(CGFloat.radiansToDegrees(radians: CGFloat(M_PI_2))) == 90
                }
            }
            
            context("Convert from larger than a full circle") {
                
                it("should return 0 when converting degrees -> radians") {
                    
                    expect(CGFloat.degreesToRadians(degrees: 540)) == CGFloat(3 * M_PI)
                }
                
                it("should return 0 when converting radians -> degrees") {
                    
                    expect(CGFloat.radiansToDegrees(radians: CGFloat(3 * M_PI))) == 540
                }
            }

        }

    }
}
