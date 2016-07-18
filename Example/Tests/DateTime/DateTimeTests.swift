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
        
        describe("Initialization") {
            
            context("from Compoennts") {
                
                it("should throw errors when trying to initialize with components that do not have a calendar") {
                    
                    expect {
                        try DateTime(components: NSDateComponents())
                        }.to(throwError())
                }
            }
            
            context("Manual format") {
                
                it("Should build a proper datetime with a UTC format string") {
                    
                    let dateTime = try! DateTime(string: "2016-07-18T09:23:34+00:00", format: DateTime.CommonFormats.iso8601Timestamp.rawValue)
                    
                    expect(dateTime.day).to(equal(18))
                    expect(dateTime.month).to(equal(7))
                    expect(dateTime.year).to(equal(2016))
                    
                    expect(dateTime.hour).to(equal(18))
                    expect(dateTime.minute).to(equal(23))
                    expect(dateTime.seconds).to(equal(34))

                }

                it("should throw errors when trying to parse with an un-matching format and string") {
                    
                    expect {
                        try DateTime(string: "01-02-2015", format: "yyyy-MM-dd")
                        }.to(throwError())
                }
            }

        }
        
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
            
            context("Whole month calendar array in leap-years") {
                
                it("should return the full array for February 2015 (starts on Sunday and ends on Saturday)") {
                    
                    let dateTimeArray = try! DateTime.allGregorianCalendarDaysFor(year: 2015, month: 2)
                    
                    expect(dateTimeArray.count).to(equal(28))
                    
                    for(index, dateTime) in dateTimeArray.enumerate() {
                        
                        expect(dateTime.day).to(equal(index + 1))
                        expect(dateTime.month).to(equal(2))
                        expect(dateTime.year).to(equal(2015))
                    }
                }

                it("should return the full array for December 2015 (end of year)") {
                    
                    let dateTimeArray = try! DateTime.allGregorianCalendarDaysFor(year: 2015, month: 12)
                    
                    expect(dateTimeArray.count).to(equal(35))
                    
                    for(index, dateTime) in dateTimeArray.enumerate() {
                        
                        if index < 2 {
                            
                            expect(dateTime.day).to(equal(index + 29))
                            expect(dateTime.month).to(equal(11))
                            expect(dateTime.year).to(equal(2015))
                            
                        } else if index <= 32 {
                            
                            expect(dateTime.day).to(equal(index - 1))
                            expect(dateTime.month).to(equal(12))
                            expect(dateTime.year).to(equal(2015))
                            
                        } else {
                            
                            expect(dateTime.day).to(equal(index - 32))
                            expect(dateTime.month).to(equal(1))
                            expect(dateTime.year).to(equal(2016))
                        }
                    }
                }

                it("should return the full array for February 2016 (leap year)") {
                    
                    let dateTimeArray = try! DateTime.allGregorianCalendarDaysFor(year: 2016, month: 2)
                    
                    expect(dateTimeArray.count).to(equal(35))
                    
                    for(index, dateTime) in dateTimeArray.enumerate() {
                        
                        if index == 0 {
                            
                            expect(dateTime.day).to(equal(31))
                            expect(dateTime.month).to(equal(1))
                            expect(dateTime.year).to(equal(2016))
                        
                        } else if index <= 29 {
                            
                            expect(dateTime.day).to(equal(index))
                            expect(dateTime.month).to(equal(2))
                            expect(dateTime.year).to(equal(2016))

                        } else {
                            
                            expect(dateTime.day).to(equal(index - 29))
                            expect(dateTime.month).to(equal(3))
                            expect(dateTime.year).to(equal(2016))
                        }
                    }
                }
            }
        }
        
        describe("Increment / Decrement") {
            
            context("Computed properties / date components") {
                
                it("Should increment years appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02", format: "yyyy-MM-dd")

                    dateTime.year += 1
                    
                    expect(dateTime.year).to(equal(2017))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                
                it("Should decrement years appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02", format: "yyyy-MM-dd")
                    
                    dateTime.year -= 1
                    
                    expect(dateTime.year).to(equal(2015))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                it("Should increment months appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02", format: "yyyy-MM-dd")
                    
                    dateTime.month += 3
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(4))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                it("Should decrement months appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02", format: "yyyy-MM-dd")
                    
                    dateTime.month -= 3
                    
                    expect(dateTime.year).to(equal(2015))
                    expect(dateTime.month).to(equal(10))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }

                it("Should increment days appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02", format: "yyyy-MM-dd")
                    
                    dateTime.day += 30
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(2))
                    expect(dateTime.day).to(equal(1))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                it("Should decrement days appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02", format: "yyyy-MM-dd")
                    
                    dateTime.day -= 2
                    
                    expect(dateTime.year).to(equal(2015))
                    expect(dateTime.month).to(equal(12))
                    expect(dateTime.day).to(equal(31))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                it("Should increment hours appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02T01:00:00", format: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    dateTime.hour += 1
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(2))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                it("Should decrement hours appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02T01:00:00", format: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    dateTime.hour -= 2
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(1))
                    
                    expect(dateTime.hour).to(equal(23))
                    expect(dateTime.minute).to(equal(0))
                    expect(dateTime.seconds).to(equal(0))
                }

                it("Should increment minutes appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02T01:12:00", format: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    dateTime.minute += 1
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(1))
                    expect(dateTime.minute).to(equal(13))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                it("Should decrement minutes appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02T01:12:00", format: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    dateTime.minute -= 14
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(0))
                    expect(dateTime.minute).to(equal(58))
                    expect(dateTime.seconds).to(equal(0))
                }
                
                
                it("Should increment seconds appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02T01:12:00", format: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    dateTime.seconds += 1
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(2))
                    
                    expect(dateTime.hour).to(equal(1))
                    expect(dateTime.minute).to(equal(12))
                    expect(dateTime.seconds).to(equal(1))
                }
                
                it("Should decrement seconds appropriately") {
                    
                    var dateTime = try! DateTime(string: "2016-01-02T01:12:00", format: "yyyy-MM-dd'T'HH:mm:ss")
                    
                    dateTime.seconds -= 7200
                    
                    expect(dateTime.year).to(equal(2016))
                    expect(dateTime.month).to(equal(1))
                    expect(dateTime.day).to(equal(1))
                    
                    expect(dateTime.hour).to(equal(23))
                    expect(dateTime.minute).to(equal(12))
                    expect(dateTime.seconds).to(equal(0))
                }
            }
        }
    }
}
