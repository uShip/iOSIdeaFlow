//
//  IdeaFlowEvent+Stuff.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import UIKit
import CoreData

private var selectedDate: NSDate?

extension IdeaFlowEvent
{
    enum EventType: String
    {
        case Productivity = "Productivity"
        case Troubleshooting = "Troubleshooting"
        case Learning = "Learning"
        case Rework = "Rework"
        case Unknown = "Unknown"
    }
    
    enum Notifications : String
    {
        case EventAdded = "Event Added"
        case AllEventsDeleted = "All Events Deleted"
        case SelectedDateChanged = "Selected Date Changed"
    }
    
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
        if selectedDate == nil
        {
            selectedDate = NSDate()
        }
        return selectedDate!
    }
    
    class func setSelectedDate(newDate: NSDate)
    {
        selectedDate = newDate
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.SelectedDateChanged.rawValue, object: self)
    }
    
    class func getEventsForSelectedDate() -> [IdeaFlowEvent]?
    {
        let predicate = NSPredicate(format:"%@ <= startTimeStamp AND %@ > endTimeStamp", selectedDayMidnight()!, selectedDayBeforeMidnight()!)
        return IdeaFlowEvent.MR_findAllWithPredicate(predicate) as? [IdeaFlowEvent]
    }
    
    func eventTypeName() -> String
    {
        switch eventType.integerValue
        {
        case 0:
            return EventType.Productivity.rawValue
        case 1:
            return EventType.Troubleshooting.rawValue
        case 2:
            return EventType.Learning.rawValue
        case 3:
            return EventType.Rework.rawValue
        default:
            return EventType.Unknown.rawValue
        }
    }
    
    func eventTypeColor() -> UIColor
    {
        switch eventType.integerValue
        {
        case 0:
            return UIColor.whiteColor()
        case 1:
            return UIColor.redColor()
        case 2:
            return UIColor.purpleColor()
        case 3:
            return UIColor.orangeColor()
        default:
            return UIColor.magentaColor()
        }
    }
    
    class func getPrevEvent() -> IdeaFlowEvent?
    {
        if IdeaFlowEvent.MR_numberOfEntities().intValue <= 0 {
            return nil
        }
        return IdeaFlowEvent.MR_findFirstOrderedByAttribute("startTimeStamp", ascending: false)
    }
    
    class func addNewEvent(eventType: EventType) {
        
        if let event = getPrevEvent() {
            event.endTimeStamp = NSDate()
        }
        
        createNewEvent(eventType, startDate: NSDate(), endDate: nil)
    }
    
    class func createNewEvent(eventType: EventType, startDate: NSDate, endDate: NSDate?) {
        
        let newEvent = IdeaFlowEvent.MR_createEntity()
        newEvent.startTimeStamp = startDate
        newEvent.endTimeStamp = endDate
        newEvent.identifier = NSUUID().UUIDString
        
        switch (eventType) {
        case .Productivity:
            newEvent.eventType = NSNumber(int: 0)
        case .Troubleshooting:
            newEvent.eventType = NSNumber(int: 1)
        case .Learning:
            newEvent.eventType = NSNumber(int: 2)
        case .Rework:
            newEvent.eventType = NSNumber(int: 3)
        case .Unknown:
            newEvent.eventType = NSNumber(int: 4)
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.EventAdded.rawValue, object: self)
    }
    
    class func createDummyEvents()
    {
        
        createNewEvent(.Troubleshooting, startDate: _getTodayDateWithTime(1, minute: 15)!, endDate: _getTodayDateWithTime(1, minute: 50)!)
        createNewEvent(.Learning, startDate: _getTodayDateWithTime(1, minute: 50)!, endDate: _getTodayDateWithTime(5, minute: 30)!)
        createNewEvent(.Rework, startDate: _getTodayDateWithTime(5, minute: 30)!, endDate: _getTodayDateWithTime(5, minute: 45)!)
        createNewEvent(.Learning, startDate: _getTodayDateWithTime(5, minute: 45)!, endDate: _getTodayDateWithTime(20, minute: 30)!)
        
        createNewEvent(.Troubleshooting, startDate: _getTomorrowDateWithTime(4, minute: 15)!, endDate: _getTomorrowDateWithTime(4, minute: 50)!)
        createNewEvent(.Learning, startDate: _getTomorrowDateWithTime(4, minute: 50)!, endDate: _getTomorrowDateWithTime(5, minute: 30)!)
        createNewEvent(.Productivity, startDate: _getTomorrowDateWithTime(5, minute: 30)!, endDate: _getTomorrowDateWithTime(8, minute: 0)!)
        createNewEvent(.Rework, startDate: _getTomorrowDateWithTime(8, minute: 0)!, endDate: _getTomorrowDateWithTime(8, minute: 30)!)
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.EventAdded.rawValue, object: self)
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
    
    class func deleteAllEvents()
    {
        IdeaFlowEvent.MR_truncateAll()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.AllEventsDeleted.rawValue, object: self)
    }
}