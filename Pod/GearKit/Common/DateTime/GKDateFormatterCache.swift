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

// Note: Since iOS7, the DateFormatter object is thread safe.
// However, changing the date format between threads is not safe, so we'll keep an instance for each
// format/timezone combination.
class DateFormatterCache {
    
    static let sharedInstance = DateFormatterCache()

    
    private static let CACHE_ENTRY_LIMIT = 16
    private var dateFormatterDictionary: [String : NSDateFormatter] = [:]
    
    class func addFormatter(formatter: NSDateFormatter) {
        
        if sharedInstance.dateFormatterDictionary.count >= DateFormatterCache.CACHE_ENTRY_LIMIT {
            
            sharedInstance.removeRandomFormatterFromCache()
        }
        
        let idString = sharedInstance.idStringFrom(format: formatter.dateFormat
            , timezone: formatter.timeZone
            , locale: formatter.locale
            , calendar: formatter.calendar)
        
        sharedInstance.dateFormatterDictionary[idString] = formatter
    }
    
    class func dateFormatterFor(format format: String
        , timezone: NSTimeZone = NSTimeZone.localTimeZone()
        , locale: NSLocale = DateTime.defaultLocale
        , calendar: NSCalendar = DateTime.gregorianCalendar) -> NSDateFormatter {
        
        let idString = sharedInstance.idStringFrom(format: format, timezone: timezone, locale: locale, calendar: calendar)
        
        if let dateFormatter = sharedInstance.dateFormatterDictionary[idString] {
            
            return dateFormatter
            
        } else {
            
            if sharedInstance.dateFormatterDictionary.count >= DateFormatterCache.CACHE_ENTRY_LIMIT {

                sharedInstance.removeRandomFormatterFromCache()
            }

            return sharedInstance.generateNewDateFormatter(format, timezone: timezone, locale: locale, calendar: calendar)
        }
    }
    
    private func removeRandomFormatterFromCache() {
        
        // Swift dictionaries are not ordered.  Delete a random element;
        // we will choose the middle one but it is purely a random decision.
        let middleIndexPosition = dateFormatterDictionary.indices.count / 2
        let indexToRemove = dateFormatterDictionary.startIndex.advancedBy(middleIndexPosition)
        dateFormatterDictionary.removeAtIndex(indexToRemove)
    }
    
    private func generateNewDateFormatter(format: String
        , timezone: NSTimeZone
        , locale: NSLocale
        , calendar: NSCalendar) -> NSDateFormatter {
    
        var newDateFormatter = NSDateFormatter()
        newDateFormatter.timeZone = timezone
        newDateFormatter.dateFormat = format
        
        newDateFormatter.locale = locale
        newDateFormatter.calendar = calendar
        
        let formatterIdentifer = idStringFrom(format: format, timezone: timezone, locale: locale, calendar: calendar)
        
        dateFormatterDictionary[formatterIdentifer] = newDateFormatter
        
        return newDateFormatter
    }
    
    // add the locale and calendar identifier here.
    private func idStringFrom(format format: String
        , timezone: NSTimeZone
        , locale: NSLocale
        , calendar: NSCalendar) -> String {
        
        return format + timezone.name + locale.localeIdentifier + calendar.calendarIdentifier
    }
    
    private init() {
        
    }
}