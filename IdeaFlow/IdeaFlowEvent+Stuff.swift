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
            return UIColor.clearColor()
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
    
    class func createNewEvent(eventType: EventType) {
        
        if let event = getPrevEvent() {
            event.endTimeStamp = NSDate()
        }
        
        let newEvent = IdeaFlowEvent.MR_createEntity()
        newEvent.startTimeStamp = NSDate()
        newEvent.endTimeStamp = nil
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
    
    class func deleteAllEvents()
    {
        IdeaFlowEvent.MR_truncateAll()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotificationName(Notifications.AllEventsDeleted.rawValue, object: self)
    }
}