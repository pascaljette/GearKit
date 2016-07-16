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


public struct DateTime {
  
    private var calendar: NSCalendar
    private var date: NSDate
    
    public init(date: NSDate = NSDate()) {
        
        self.date = date
        self.calendar = NSCalendar.currentCalendar()
    }
    
    public init(components: NSDateComponents) throws {
    
        guard let componentsDate = components.date else {
            throw NSError(domain: "TODO", code: 0, userInfo: nil)
        }
        
        self.calendar = components.calendar ?? NSCalendar.currentCalendar()
        self.date = componentsDate
    }
    
    public var year: Int {
        
        get {
            
            return calendar.component(.Year, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Year, value: newValue)
        }
    }

    public var month: Int {
        
        get {
            
            return calendar.component(.Month, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Month, value: newValue)
        }
    }

    public var day: Int {
        
        get {
            
            return calendar.component(.Day, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Day, value: newValue)
        }
    }
    
    public var hour: Int {
        
        get {
            
            return calendar.component(.Hour, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Hour, value: newValue)
        }
    }
    
    public var minute: Int {
        
        get {
            
            return calendar.component(.Minute, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Minute, value: newValue)
        }
    }

    public var seconds: Int {
        
        get {
            
            return calendar.component(.Second, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Second, value: newValue)
        }
    }
    
    public var dayOfWeek: Int {
        
        get {
            
            return calendar.component(.Weekday, fromDate: date)
        }
        
        set {
            
            date = dateBySettingCalendarUnit(.Weekday, value: newValue)
        }
    }
    
    public static func dateForFirstDayOfYearMonth(year year: Int, month: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> DateTime {

        var components = NSDateComponents()
        components.calendar = calendar

        components.year = year
        components.month = month
        components.day = 1
        
        return try DateTime(components: components)
    }
    
    public static func dateForLastDayOfYearMonth(year year: Int, month: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> DateTime {
        
        var components = NSDateComponents()
        components.calendar = calendar

        components.year = year
        components.month = month + 1
        components.day = 0

        return try DateTime(components: components)
    }

    public static func allDaysFor(year year: Int, month: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> [DateTime] {
        
        var returnArray: [DateTime] = []
        
        let firstDay = try DateTime.dateForFirstDayOfYearMonth(year: year, month: month)
        let lastDay = try DateTime.dateForLastDayOfYearMonth(year: year, month: month)
        
        for day in firstDay.day...lastDay.day {
            
            var components = NSDateComponents()
            components.calendar = calendar
            
            components.year = year
            components.month = month
            components.day = day

            returnArray.append(try DateTime(components: components))
        }
        
        return returnArray
    }
    
    /// The calendar dateBySettingUnit can only return a date after the current date.
    /// Implement our own.
    private func dateBySettingCalendarUnit(unit: NSCalendarUnit, value: Int) -> NSDate {
        
        var components = NSDateComponents()
        components.setValue(value - calendar.component(unit, fromDate: date), forComponent: unit)
        return calendar.dateByAddingComponents(components, toDate: date, options: [])!
    }
}

