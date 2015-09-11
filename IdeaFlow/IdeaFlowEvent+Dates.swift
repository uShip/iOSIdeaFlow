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
        return getSelectedDate().midnight()
    }
    
    class func selectedDayBeforeMidnight() -> NSDate?
    {
        return getSelectedDate().oneSecondBeforeMidnight()
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
    
    class func getEventsForSelectedDay() -> [IdeaFlowEvent]?
    {
        if let selectedDate = private_IdeaFlowSelectedDate
        {
            return getEventsForDay(selectedDate)
        }
        return nil
    }
    
    class func getEventsForDay(day: NSDate) -> [IdeaFlowEvent]?
    {
        let predicate = NSPredicate(format:"%@ <= startTimeStamp AND startTimeStamp < %@", day.midnight()!, day.oneSecondBeforeMidnight()!)
        if let events = IdeaFlowEvent.MR_findAllWithPredicate(predicate) as? [IdeaFlowEvent]
        {
            #if DEBUG
                print("events for \(NSDate()):")
                for event in events
                {
                    print("\t \(event.startTimeStamp) - \(IdeaFlowEvent.EventType(int:event.eventType.intValue).rawValue)")
                }
            #endif
            return events
        }
        return nil
    }
    
    class func getDatesThatHaveEvents() -> [NSDate]?
    {
        let fetchController = IdeaFlowEvent.MR_fetchAllGroupedBy("startTimeStamp", withPredicate: nil, sortedBy: "startTimeStamp", ascending: true)
        do
        {
            var dates = [NSDate]()
            
            try fetchController.performFetch()
            for section in fetchController.sections!
            {
                if let event = section.objects?.first as? IdeaFlowEvent
                {
                    dates.append(event.startTimeStamp)
                }
            }
            return dates
        }
        catch
        {
            //TODO: report error to UI
            print("[--ERROR--]: \(error)")
        }
        
        return nil
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