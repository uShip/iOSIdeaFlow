//
//  NSDate+TimeToPercentOfDay.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGFloat
{
    func noDecimalsFormat() -> String
    {
        return NSString(format: "%0.0f", self) as String
    }
    func twoDecimalsFormat() -> String
    {
        return NSString(format: "%0.2f", self) as String
    }
}

private let zoom = CGFloat(1)
private let hoursPerDay = CGFloat(24)*zoom
private let minutesPerDay = CGFloat(60*24)*zoom
private let secondsPerDay = CGFloat(60*60*24)*zoom
extension NSDate
{
    func timeToPercentOfDay() -> CGFloat
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = calendar?.components([.Hour, .Minute, .Second], fromDate: self)
        
        let second = CGFloat(dateComponents?.second ?? 0)
        let minute = CGFloat(dateComponents?.minute ?? 0)
        let hour = CGFloat(dateComponents?.hour ?? 0)

        let hourPercent = (hour / hoursPerDay)
        let minutePercent = (minute / minutesPerDay)
        let secondPercent = (second / secondsPerDay)

        let percent = hourPercent + minutePercent + secondPercent
        return percent
    }
}