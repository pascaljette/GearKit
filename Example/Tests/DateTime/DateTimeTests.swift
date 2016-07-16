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
class DateTimeSpec: QuickSpec {
    
    override func spec() {

        dateTimeBasic()
    }
    
    func dateTimeBasic() {
        
        let today = DateTime()
        
        describe("Set Date Components") {
            
            ///
            /// MARK: Init from explicit components
            ///
            context("Set Day") {
                
                it("Should set day to the first of the month") {
                    
                    var dateTime = DateTime()
                    
                    dateTime.day = 1
                    
                    expect(dateTime.day).to(equal(1))
                    expect(dateTime.month).to(equal(today.month))
                    expect(dateTime.year).to(equal(today.year))
                    
                }
                
                it("Should set set day to the 28th of the month") {
                    
                    var dateTime = DateTime()
                    
                    dateTime.day = 28
                    
                    expect(dateTime.day).to(equal(28))
                    expect(dateTime.month).to(equal(today.month))
                    expect(dateTime.year).to(equal(today.year))
                }
                
                
                it("Should wrap to the next month if the number of days exceeds the current month") {
                    
                    var dateTime = DateTime()
                    
                    dateTime.year = 2015
                    dateTime.month = 2
                    dateTime.day = 29
                    
                    expect(dateTime.day).to(equal(1))
                    expect(dateTime.month).to(equal(3))
                    expect(dateTime.year).to(equal(2015))
                }
            }
        }
        
        describe("Static functions") {
            
            context("next month") {
                
                it("should set to the first day of the current month") {
                    
                    let dateTime = try! DateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month)
                    
                    expect(dateTime.day).to(equal(1))
                    expect(dateTime.month).to(equal(today.month))
                    expect(dateTime.year).to(equal(today.year))
                }
                
                it("should set to the first day of the next month") {
                    
                    let dateTime = try! DateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month + 1)
                    
                    expect(dateTime.day).to(equal(1))
                    expect(dateTime.month).to(equal(today.month + 1))
                    expect(dateTime.year).to(equal(today.year))
                }
                
                it("should set to the first day of the previous month") {
                    
                    let dateTime = try! DateTime.dateForFirstDayOfYearMonth(year: today.year, month: today.month - 1)
                    
                    expect(dateTime.day).to(equal(1))
                    expect(dateTime.month).to(equal(today.month - 1))
                    expect(dateTime.year).to(equal(today.year))
                }
                
                it("should set to the last day of February (leap-year)") {
                    
                    let dateTime = try! DateTime.dateForLastDayOfYearMonth(year: 2016, month: 2)
                    
                    expect(dateTime.day).to(equal(29))
                    expect(dateTime.month).to(equal(2))
                    expect(dateTime.year).to(equal(2016))
                }
                
                it("should set to the last day of February (non-leap-year)") {
                    
                    let dateTime = try! DateTime.dateForLastDayOfYearMonth(year: 2015, month: 2)
                    
                    expect(dateTime.day).to(equal(28))
                    expect(dateTime.month).to(equal(2))
                    expect(dateTime.year).to(equal(2015))
                }

                it("should set to the last day of April") {
                    
                    let dateTime = try! DateTime.dateForLastDayOfYearMonth(year: today.year, month: 4)
                    
                    expect(dateTime.day).to(equal(30))
                    expect(dateTime.month).to(equal(4))
                    expect(dateTime.year).to(equal(today.year))
                }

                it("should set to the last day of the December") {
                    
                    let dateTime = try! DateTime.dateForLastDayOfYearMonth(year: today.year, month: 12)
                    
                    expect(dateTime.day).to(equal(31))
                    expect(dateTime.month).to(equal(12))
                    expect(dateTime.year).to(equal(today.year))
                }
            }
            
            context("Whole month arrays in non-leap-years") {
                
                for month in 1...12 {
                    
                    it("should return the full array for month \(month)") {
                        
                        let dateTimeArray = try! DateTime.allDaysFor(year: 2015, month: month)
                        
                        for(index, dateTime) in dateTimeArray.enumerate() {
                            
                            expect(dateTime.day).to(equal(index + 1))
                            expect(dateTime.month).to(equal(month))
                            expect(dateTime.year).to(equal(2015))
                        }
                    }

                }
            }
            
            context("Whole month arrays in leap-years") {
                
                for month in 1...12 {
                    
                    it("should return the full array for month \(month)") {
                        
                        let dateTimeArray = try! DateTime.allDaysFor(year: 2016, month: month)
                        
                        for(index, dateTime) in dateTimeArray.enumerate() {
                            
                            expect(dateTime.day).to(equal(index + 1))
                            expect(dateTime.month).to(equal(month))
                            expect(dateTime.year).to(equal(2016))
                        }
                    }
                    
                }
            }
        }
        
        describe("Exception handling") {
            
            context("Error thrown") {
                
                // TODO-pk not yes tested.
                it("should throw errors when setting to invalid year") {
                 
                
                }
            }
        }

    }
}
