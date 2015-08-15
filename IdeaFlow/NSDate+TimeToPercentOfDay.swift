//
//  NSDate+TimeToPercentOfDay.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import CoreGraphics

private let hoursPerDay = CGFloat(1)
private let minutesPerDay = CGFloat(60*hoursPerDay)
private let secondsPerDay = CGFloat(60*minutesPerDay)
extension NSDate
{
    func timeToPercentOfDay() -> CGFloat
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calendar?.components(.CalendarUnitHour | .CalendarUnitMinute | .CalendarUnitSecond, fromDate: self)
        
        let second = CGFloat(dateComponents?.second ?? 0)
        let minute = CGFloat(dateComponents?.minute ?? 0)
        let hour = CGFloat(dateComponents?.hour ?? 0)
        
        let hourPercent = ((hour % hoursPerDay) / hoursPerDay)
        let minutePercent = (minute / minutesPerDay)
        let secondPercent = (second / secondsPerDay)
        
        println("-- \(hourPercent) \(minutePercent) \(secondPercent)")
        
        let percent = hourPercent + minutePercent + secondPercent
        return percent
    }
}