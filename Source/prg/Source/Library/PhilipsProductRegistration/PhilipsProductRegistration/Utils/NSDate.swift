//
//  NSDate.swift
//  PhilipsProductRegistration
//
// Copyright © Koninklijke Philips N.V., 2016
// All rights are reserved. Reproduction or dissemination
// in whole or in part is prohibited without the prior written
// consent of the copyright holder.
//

import Foundation

func ==(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedSame
}

func <(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

func >(lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedDescending
}

extension Foundation.Date {
    
    fileprivate struct Date {
        static let locale: Locale = {
            let locale =  Locale(identifier: "en_US_POSIX")
            return locale
        }()
        
        static let DateFormatter: Foundation.DateFormatter = {
            let formatter = Foundation.DateFormatter()
            formatter.locale = Date.locale
            return formatter
        }()
        
        static let DateFormatterForDisplay: Foundation.DateFormatter = {
            let formatter = Foundation.DateFormatter()
            formatter.locale = NSLocale.current
            formatter.dateStyle = .short
            return formatter
        }()

        static let Calender: Calendar = {
            var calender = Calendar(identifier: Calendar.Identifier.gregorian)
            calender.locale = Date.locale
            return calender
        }()
    }

    fileprivate static func LongDateFormatter() -> DateFormatter {
        let formatter = Date.DateFormatter
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss zz"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }
    
    fileprivate static func ShortDateFormatter() -> DateFormatter {
        let formatter = Date.DateFormatter
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter
    }
    
    func dateWith(_ components: DateComponents) -> Foundation.Date? {
        return (Date.Calender as NSCalendar).date(era: 1,
                                         year: components.year!,
                                         month: components.month!,
                                         day: components.day!,
                                         hour: components.hour!,
                                         minute: components.minute!,
                                         second: components.second!,
                                         nanosecond: components.nanosecond == nil ? 0 : components.nanosecond!)!
    }
    
    func stringDateWith(_ format:String) -> String? {
        let formatter = Date.DateFormatter
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func stringRepresentation() -> String? {
        let formatter = Date.DateFormatterForDisplay
        return formatter.string(from: self)
    }

    func localisedStringDate(_ format: String) -> String {
        let formatString = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale:  PPRInterfaceInput.sharedInstance.appDependency.appInfra.internationalization.getUILocale() as Locale)
        let formatter = Date.DateFormatterForDisplay
        formatter.dateFormat = formatString
        return formatter.string(from: self)
    }

    static func registrationLongDateFrom(_ dateString: String) -> Foundation.Date? {
        return Foundation.Date.LongDateFormatter().date(from: dateString)
    }
    
    static func registrationShortDateFrom(_ dateString: String) -> Foundation.Date? {
        return Foundation.Date.ShortDateFormatter().date(from: dateString)
    }
}
