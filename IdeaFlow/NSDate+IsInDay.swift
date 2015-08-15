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
    func dayComponents() -> (day: Int, month: Int, year: Int)
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calendar?.components(.CalendarUnitDay | .CalendarUnitMonth | .CalendarUnitYear, fromDate: self)
        
        let day = Int(dateComponents?.day ?? 0)
        let month = Int(dateComponents?.month ?? 0)
        let year = Int(dateComponents?.year ?? 0)
        
        
        return (day, month, year)
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