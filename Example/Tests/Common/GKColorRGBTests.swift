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
class GKColorRGBSpec: QuickSpec {
    
    override func spec() {
        
        initFromExplicitTests()
        initFromRgbaIntTests()
        initFromRgbaStringTests()
    }
    
    func initFromExplicitTests() {
        
        describe("Init from explicit components tests") {
            
            ///
            /// MARK: Init from explicit components
            ///
            context("Simple initialization") {
                
                it("Should reflect initialization properly with default alpha") {
                    
                    let myColor: GKColorRGB = GKColorRGB(red: 10, green: 20, blue: 30)
                    expect(myColor.red) == 10
                    expect(myColor.green) == 20
                    expect(myColor.blue) == 30
                    expect(myColor.alpha) == 255
                }
                
                it("Should reflect initialization properly with assigned alpha") {
                    
                    let myColor: GKColorRGB = GKColorRGB(red: 10, green: 20, blue: 30, alpha: 40)
                    expect(myColor.red) == 10
                    expect(myColor.green) == 20
                    expect(myColor.blue) == 30
                    expect(myColor.alpha) == 40
                }

                it("Should be able to go back and forth with UIColor") {
                    
                    let myColor: GKColorRGB = GKColorRGB(red: 10, green: 20, blue: 30, alpha: 40)
                    let myUIColor = myColor.uiColor
                    
                    expect(myUIColor.gkColorRGB.red) == 10
                    expect(myUIColor.gkColorRGB.green) == 20
                    expect(myUIColor.gkColorRGB.blue) == 30
                    expect(myUIColor.gkColorRGB.alpha) == 40
                }
            }
        }
    }
    
    func initFromRgbaIntTests() {
        
        describe("Init from rgba integer tests") {
            
            ///
            /// MARK: Simple initialization
            ///
            context("Simple initialization") {
                
                it("Should reflect initialization properly with default alpha") {
                    
                    let myColor: GKColorRGB = GKColorRGB(rgb: 0x112233)
                    expect(myColor.red) == 17
                    expect(myColor.green) == 34
                    expect(myColor.blue) == 51
                    expect(myColor.alpha) == 255
                }
                
                it("Should reflect initialization properly with assigned alpha") {
                    
                    let myColor: GKColorRGB = GKColorRGB(rgba: 0x11223344)
                    expect(myColor.red) == 17
                    expect(myColor.green) == 34
                    expect(myColor.blue) == 51
                    expect(myColor.alpha) == 68
                }
                
                it("Should be able to go back and forth with UIColor") {
                    
                    let myColor: GKColorRGB = GKColorRGB(rgba: 0x11223344)
                    let myUIColor = myColor.uiColor
                    
                    expect(myUIColor.gkColorRGB.red) == 17
                    expect(myUIColor.gkColorRGB.green) == 34
                    expect(myUIColor.gkColorRGB.blue) == 51
                    expect(myUIColor.gkColorRGB.alpha) == 68
                }
            }
        }
    }
    
    func initFromRgbaStringTests() {
        
        describe("Init from rgba string tests") {
            
            ///
            /// MARK: Simple initialization with # prefix
            ///
            context("Simple initialization from valid strings with # prefix") {
                
                it("Should reflect initialization properly with default alpha") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "#112233")
                    
                    guard let myColorInstance = myColor else {
                        
                        fail("failed to initialize color with rgbString: #112233")
                        return
                    }
                    
                    expect(myColorInstance.red) == 17
                    expect(myColorInstance.green) == 34
                    expect(myColorInstance.blue) == 51
                    expect(myColorInstance.alpha) == 255
                }
                
                it("Should reflect initialization properly with assigned alpha") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "#11223344")
                    
                    guard let myColorInstance = myColor else {
                        
                        fail("failed to initialize color with rgbaString: #11223344")
                        return
                    }
                    
                    expect(myColorInstance.red) == 17
                    expect(myColorInstance.green) == 34
                    expect(myColorInstance.blue) == 51
                    expect(myColorInstance.alpha) == 68
                }
                
                it("Should be able to go back and forth with UIColor") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "#11223344")
                    
                    guard let myColorInstance = myColor else {
                        
                        fail("failed to initialize color with rgbaString: #11223344")
                        return
                    }
                    
                    let myUIColor = myColorInstance.uiColor
                    
                    expect(myUIColor.gkColorRGB.red) == 17
                    expect(myUIColor.gkColorRGB.green) == 34
                    expect(myUIColor.gkColorRGB.blue) == 51
                    expect(myUIColor.gkColorRGB.alpha) == 68
                }
            }
            
            ///
            /// MARK: Simple initialization with 0x prefix
            ///
            context("Simple initialization from valid strings with # prefix") {
                
                it("Should reflect initialization properly with default alpha") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "0x112233")
                    
                    guard let myColorInstance = myColor else {
                        
                        fail("failed to initialize color with rgbString: 0x112233")
                        return
                    }
                    
                    expect(myColorInstance.red) == 17
                    expect(myColorInstance.green) == 34
                    expect(myColorInstance.blue) == 51
                    expect(myColorInstance.alpha) == 255
                }
                
                it("Should reflect initialization properly with assigned alpha") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "0x11223344")
                    
                    guard let myColorInstance = myColor else {
                        
                        fail("failed to initialize color with rgbaString: 0x11223344")
                        return
                    }
                    
                    expect(myColorInstance.red) == 17
                    expect(myColorInstance.green) == 34
                    expect(myColorInstance.blue) == 51
                    expect(myColorInstance.alpha) == 68
                }
                
                it("Should be able to go back and forth with UIColor") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "0x11223344")
                    
                    guard let myColorInstance = myColor else {
                        
                        fail("failed to initialize color with rgbaString: 0x11223344")
                        return
                    }
                    
                    let myUIColor = myColorInstance.uiColor
                    
                    expect(myUIColor.gkColorRGB.red) == 17
                    expect(myUIColor.gkColorRGB.green) == 34
                    expect(myUIColor.gkColorRGB.blue) == 51
                    expect(myUIColor.gkColorRGB.alpha) == 68
                }
            }
            
            ///
            /// MARK: Initialization from invalid strings
            ///
            context("Initialization from invalid strings") {
                
                it("Should fail with an invalid prefix (rgb version)") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "0y112233")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with an invalid prefix (rgba version") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "0y11223344")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with an empty string (rgb version)") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with an empty string (rgba version") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "")
                    expect(myColor == nil) == true
                }

                it("Should fail with a string that is too short (rgb version)") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "#11223")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with a string that is too short (rgba version") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "#1122334")
                    expect(myColor == nil) == true
                }

                it("Should fail with a string that is too long (rgb version)") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "#1122333")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with a string that is too long (rgba version") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "#112233444")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with a non hex string (rgb version)") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbString: "#HOH0HO")
                    expect(myColor == nil) == true
                }
                
                it("Should fail with a non hex string (rgba version") {
                    
                    let myColor: GKColorRGB? = GKColorRGB(rgbaString: "#HOH0HIH1")
                    expect(myColor == nil) == true
                }
            }
        }
    }
}
