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
    
    class func createDummyEvents() {
        
        createNewEvent(.Troubleshooting, startDate: _getDate(4, min: 15)!, endDate: _getDate(4, min: 50)!)
        createNewEvent(.Learning, startDate: _getDate(4, min: 50)!, endDate: _getDate(5, min: 30)!)
        createNewEvent(.Productivity, startDate: _getDate(5, min: 30)!, endDate: _getDate(8, min: 0)!)
        createNewEvent(.Rework, startDate: _getDate(8, min: 0)!, endDate: _getDate(8, min: 30)!)
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.EventAdded.rawValue, object: self)
    }
    
    class func _getDate(hour: Int, min: Int) -> NSDate?
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComponents = NSDateComponents()
        dateComponents.second = 0
        dateComponents.minute = min
        dateComponents.hour = hour
        dateComponents.day = 15
        dateComponents.month = 8
        dateComponents.year = 2015
        return calendar?.dateFromComponents(dateComponents)
    }
    
    class func deleteAllEvents()
    {
        IdeaFlowEvent.MR_truncateAll()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.AllEventsDeleted.rawValue, object: self)
    }
}