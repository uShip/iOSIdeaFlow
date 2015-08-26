//
//  NSDate+IsInDay.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/15/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation

extension NSDate
{
    func dateOffsetBy(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> NSDate?
    {
        let deltaComps = NSDateComponents()
        deltaComps.year = years
        deltaComps.month = months
        deltaComps.day = days
        deltaComps.hour = hours
        deltaComps.minute = minutes
        deltaComps.second = seconds
        let offsetDate = NSCalendar.currentCalendar().dateByAddingComponents(deltaComps, toDate: self, options: NSCalendarOptions(rawValue: 0))
        return offsetDate
    }
    
    func dayComponents() -> (day: Int, month: Int, year: Int, hour: Int, minute: Int, second: Int)
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calendar?.components([.Day, .Month, .Year, .Hour, .Minute, .Second], fromDate: self)
        
        let day = Int(dateComponents?.day ?? 0)
        let month = Int(dateComponents?.month ?? 0)
        let year = Int(dateComponents?.year ?? 0)
        let hour = Int(dateComponents?.hour ?? 0)
        let minute = Int(dateComponents?.minute ?? 0)
        let second = Int(dateComponents?.second ?? 0)
        
        return (day, month, year, hour, minute, second)
    }
    
    func isInDay(otherDate: NSDate) -> Bool
    {
        let myDay = dayComponents()
        let otherDay = otherDate.dayComponents()
        
        return (myDay.day == otherDay.day) &&
            (myDay.month == otherDay.month) &&
            (myDay.year == otherDay.year)
    }
}