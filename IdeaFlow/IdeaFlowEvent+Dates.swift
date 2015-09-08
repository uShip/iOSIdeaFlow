//
//  IdeaFlowEvent+Dates.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/4/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation

private var private_IdeaFlowSelectedDate: NSDate?

extension IdeaFlowEvent
{
    
    class func selectedDayMidnight() -> NSDate?
    {
        let today = getSelectedDate().dayComponents()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = NSDateComponents()
        dateComponents.second = 0
        dateComponents.minute = 0
        dateComponents.hour = 0
        dateComponents.day = today.day
        dateComponents.month = today.month
        dateComponents.year = today.year
        return calendar?.dateFromComponents(dateComponents)
    }
    
    class func selectedDayBeforeMidnight() -> NSDate?
    {
        let today = getSelectedDate().dayComponents()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = NSDateComponents()
        dateComponents.second = 59
        dateComponents.minute = 59
        dateComponents.hour = 23
        dateComponents.day = today.day
        dateComponents.month = today.month
        dateComponents.year = today.year
        return calendar?.dateFromComponents(dateComponents)
    }
    
    class func selectedDayWithOffset(offset: Int) -> NSDate?
    {
        let dateComponents = NSDateComponents()
        dateComponents.day = offset
        
        let calendar = NSCalendar.currentCalendar()
        return calendar.dateByAddingComponents(dateComponents, toDate: getSelectedDate(), options: NSCalendarOptions(rawValue: 0))
    }
    
    class func setSelectedDayWithOffset(offset: Int)
    {
        if let newDay = selectedDayWithOffset(offset)
        {
            setSelectedDate(newDay)
        }
    }
    
    class func getSelectedDate() -> NSDate
    {
        if private_IdeaFlowSelectedDate == nil
        {
            private_IdeaFlowSelectedDate = NSDate()
        }
        return private_IdeaFlowSelectedDate!
    }
    
    class func setSelectedDate(newDate: NSDate)
    {
        private_IdeaFlowSelectedDate = newDate
        NSNotificationCenter.defaultCenter().postNotificationName(Notification.SelectedDateChanged.rawValue, object: self)
    }
    
    class func getEventsForSelectedDate() -> [IdeaFlowEvent]?
    {
        let predicate = NSPredicate(format:"%@ <= startTimeStamp AND %@ > endTimeStamp", selectedDayMidnight()!, selectedDayBeforeMidnight()!)
        return IdeaFlowEvent.MR_findAllWithPredicate(predicate) as? [IdeaFlowEvent]
    }
    
    class func _getTodayDateWithTime(hour: Int, minute: Int, second: Int = 0) -> NSDate?
    {
        let today = NSDate()
        let todayComponents = today.dayComponents()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = NSDateComponents()
        dateComponents.second = 0
        dateComponents.minute = minute
        dateComponents.hour = hour
        dateComponents.day = todayComponents.day
        dateComponents.month = todayComponents.month
        dateComponents.year = todayComponents.year
        return calendar?.dateFromComponents(dateComponents)
    }
    
    class func _getTomorrowDateWithTime(hour: Int, minute: Int, second: Int = 0) -> NSDate?
    {
        let today = NSDate()
        let tomorrow = today.dateOffsetBy(days: 1)
        let tomorrowComponents = tomorrow!.dayComponents()
        
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = NSDateComponents()
        dateComponents.second = 0
        dateComponents.minute = minute
        dateComponents.hour = hour
        dateComponents.day = tomorrowComponents.day
        dateComponents.month = tomorrowComponents.month
        dateComponents.year = tomorrowComponents.year
        return calendar?.dateFromComponents(dateComponents)
    }
}