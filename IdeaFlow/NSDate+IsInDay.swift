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
    func midnight() -> NSDate?
    {
        let dayComponents = self.dayComponents()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let midnightComponents = NSDateComponents()
        midnightComponents.second = 0
        midnightComponents.minute = 0
        midnightComponents.hour = 0
        midnightComponents.day = dayComponents.day
        midnightComponents.month = dayComponents.month
        midnightComponents.year = dayComponents.year
        return calendar?.dateFromComponents(midnightComponents)
    }
    
    func oneSecondBeforeMidnight() -> NSDate?
    {
        let todayComponents = self.dayComponents()
        
        let comps = NSDateComponents()
        comps.year = todayComponents.year
        comps.month = todayComponents.month
        comps.day = todayComponents.day
        comps.hour = 23
        comps.minute = 59
        comps.second = 59
        return NSCalendar.currentCalendar().dateFromComponents(comps)
    }
    
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