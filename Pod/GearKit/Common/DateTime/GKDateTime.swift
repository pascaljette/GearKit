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

/// Wrapper/shortcut around the NSCalendar/NSDate combination to make date handling easy.
public struct DateTime {
  
    //
    // MARK: Stored properties
    //

    /// Reference on the calendar to compute date and components.
    private var calendar: NSCalendar
    
    /// Reference on the current date.
    private var date: NSDate
    
    //
    // MARK: Initialization
    //
    
    /// Initialize with a date.  Defaults to today (current date).
    public init(date: NSDate = NSDate()) {
        
        self.date = date
        self.calendar = NSCalendar.currentCalendar()
    }
    
    /// Initialize with components.  Assume that the calendar contain a calendar, otherwise will throw an exception.
    public init(components: NSDateComponents) throws {
    
        guard let componentsDate = components.date else {
            
            throw DateTimeError.InvalidDateComponents(year: components.year, month: components.month, day: components.day)
        }
        
        self.calendar = components.calendar ?? NSCalendar.currentCalendar()
        self.date = componentsDate
    }
}

extension DateTime {
    
    //
    // MARK: Computed properties
    //

    /// Year
    public var year: Int {
        
        get {
            
            return calendar.component(.Year, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Year, value: newValue)
            
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting YEAR:\(newValue)")
            }
        }
    }

    /// Month
    public var month: Int {
        
        get {
            
            return calendar.component(.Month, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Month, value: newValue)
                
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting MONTH:\(newValue)")
            }
        }
    }

    /// Day
    public var day: Int {
        
        get {
            
            return calendar.component(.Day, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Day, value: newValue)
                
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting DAY:\(newValue)")
            }
        }
    }
    
    /// Hour
    public var hour: Int {
        
        get {
            
            return calendar.component(.Hour, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Hour, value: newValue)
                
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting HOUR:\(newValue)")
            }
        }
    }
    
    /// Minute
    public var minute: Int {
        
        get {
            
            return calendar.component(.Minute, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Minute, value: newValue)
                
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting MINUTE:\(newValue)")
            }
        }
    }

    /// Seconds
    public var seconds: Int {
        
        get {
            
            return calendar.component(.Second, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Second, value: newValue)
                
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting SECOND:\(newValue)")
            }
        }
    }
    
    /// Day of week.  For the gregorian calendar, Sunday = 1 and Saturday = 7.
    public var dayOfWeek: Int {
        
        get {
            
            return calendar.component(.Weekday, fromDate: date)
        }
        
        set {
            
            do {
                date = try dateBySettingCalendarUnit(.Weekday, value: newValue)
                
            } catch let error as DateTimeError {
                
                debugPrint(error)
                
            } catch {
                
                debugPrint("Unknown exception when setting WEEKDAY:\(newValue)")
            }
        }
    }
    
    /// Extract the components from the current date and calendar.
    public var components: NSDateComponents {
        get {
            
            let components = calendar.components([.Year, .Month, .Day, .Hour, .Minute, .Second, .Weekday], fromDate: date)
            
            components.calendar = calendar
            
            return components
        }
    }
}

extension DateTime {

    //
    // MARK: Computed properties
    //

    /// Get the date time for the first day of a given year/month.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get the first day.
    /// - parameter calendar: Calendar used to compute the first day.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func dateForFirstDayOfYearMonth(year year: Int, month: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> DateTime {

        let components = NSDateComponents()
        components.calendar = calendar

        components.year = year
        components.month = month
        components.day = 1
        
        return try DateTime(components: components)
    }
   
    /// Get the date time for the last day of a given year/month.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get the last day.
    /// - parameter calendar: Calendar used to compute the last day.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func dateForLastDayOfYearMonth(year year: Int, month: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> DateTime {
        
        let components = NSDateComponents()
        components.calendar = calendar

        components.year = year
        components.month = month + 1
        components.day = 0

        return try DateTime(components: components)
    }

    /// Get an array containing all days for a given year/month.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get all days.
    /// - parameter calendar: Calendar used to compute days array.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func allDaysFor(year year: Int, month: Int, calendar: NSCalendar = NSCalendar.currentCalendar()) throws -> [DateTime] {
        
        var returnArray: [DateTime] = []
        
        do {
            
            let firstDay = try DateTime.dateForFirstDayOfYearMonth(year: year, month: month)
            let lastDay = try DateTime.dateForLastDayOfYearMonth(year: year, month: month)
            
            for day in firstDay.day...lastDay.day {
                
                let components = NSDateComponents()
                components.calendar = calendar
                
                components.year = year
                components.month = month
                components.day = day
                
                returnArray.append(try DateTime(components: components))
            }
        
        } catch DateTimeError.InvalidDateComponents(let year, let month, _) {
            
            throw DateTimeError.InvalidComponentsForDateArray(year: year, month: month)
        }
        
        return returnArray
    }
    
    /// Get an array containing all days for a given year/month in the gregorian calendar.  
    /// This function is used to display a calendar on screen. Therefore, if the first day of the month is not
    /// a Sunday, it will get days from the previous month until it reaches Sunday.  Likewise, if the last day
    /// of the month is not a Saturday, it will get all days from the next month until it reaches Saturday.
    ///
    /// - parameter year: Year for the month.
    /// - parameter month: Month for which to get all days.
    /// - parameter calendar: Calendar used to compute days array.
    ///
    /// - throws A DateTimeError if the year/month is not valid for the given calendar.
    public static func allGregorianCalendarDaysFor(year year: Int, month: Int) throws -> [DateTime] {
        
        do {
        
            var returnArray: [DateTime] = []
            
            let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!

            let firstDayOfMonth = try DateTime.dateForFirstDayOfYearMonth(year: year, month: month, calendar: calendar)
            let lastDayOfMonth = try DateTime.dateForLastDayOfYearMonth(year: year, month: month, calendar: calendar)
            
            // If the first day of the month is not a sunday, we must add days from the previous month
            // until we reach sunday.
            for i in (1..<firstDayOfMonth.dayOfWeek).reverse() {
                
                var dayToAppend = firstDayOfMonth
                dayToAppend.day -= i
                
                returnArray.append(dayToAppend)
            }
            
            // Add all the regular days in the month.
            for day in firstDayOfMonth.day...lastDayOfMonth.day {
                
                let components = NSDateComponents()
                components.calendar = calendar
                
                components.year = year
                components.month = month
                components.day = day
                
                returnArray.append(try DateTime(components: components))
            }
            
            // If the last day of the month is not a saturday, we must add days until we reach saturday
            for (index, _) in (lastDayOfMonth.dayOfWeek ..< 7).enumerate() {
                
                var dayToAppend = lastDayOfMonth
                dayToAppend.day += (index + 1)
                
                returnArray.append(dayToAppend)
            }
            
            return returnArray

        } catch DateTimeError.InvalidDateComponents(let year, let month, _) {
            
            throw DateTimeError.InvalidComponentsForDateArray(year: year, month: month)
        }
    }
}

extension DateTime {
    
    /// The NSCalendar dateBySettingUnit can only return a date after the current date.
    /// We need to be able to set units for a previous day too.
    ///
    /// - parameter unit: The unit for which to set a new value.
    /// - parameter value: The value of the new unit to set.
    ///
    /// - throws: Exception if the resulting date is invalid.
    ///
    /// - returns: NSDate constructed with the provided components.
    private func dateBySettingCalendarUnit(unit: NSCalendarUnit, value: Int) throws -> NSDate {
        
        let componentsToAdd = NSDateComponents()
        componentsToAdd.setValue(value - calendar.component(unit, fromDate: date), forComponent: unit)
        
        guard let returnDate = calendar.dateByAddingComponents(componentsToAdd, toDate: date, options: []) else {
         
            let componentsForCurrentDate = calendar.components([.Year, .Month, .Day], fromDate: date)
            
            throw DateTimeError.InvalidDateComponents(year: componentsForCurrentDate.year + componentsToAdd.year
                , month: componentsForCurrentDate.month + componentsToAdd.month
                , day: componentsForCurrentDate.day + componentsToAdd.day)
        }
        
        return returnDate
    }
}

