//
//  IdeaFlowEvent+CreateDelete.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/4/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation
import CoreData

extension IdeaFlowEvent
{
    class func addNewEvent(eventType: EventType)
    {
        let startDate = NSDate()
        
        if let previousEvent = getPreviousEvent(startDate)
        {
            if EventType(int:previousEvent.eventType.intValue) == eventType
            {
                return
            }
        }
        
        createNewEvent(eventType, startDate: startDate)
    }
    
    class func createNewEvent(eventType: EventType, startDate: NSDate) -> IdeaFlowEvent
    {
        
        let newEvent = IdeaFlowEvent.MR_createEntity()
        newEvent.startTimeStamp = startDate
        newEvent.identifier = NSUUID().UUIDString
        newEvent.eventType = NSNumber(int: eventType.intValue())
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotification(Notification.EventAdded.notification(self))
        
        return newEvent
    }
    
    class func createDemoEvents()
    {
        createNewEvent(.Troubleshooting, startDate: _getTodayDateWithTime(1, minute: 15)!)
        createNewEvent(.Learning, startDate: _getTodayDateWithTime(1, minute: 50)!)
        createNewEvent(.Rework, startDate: _getTodayDateWithTime(5, minute: 30)!)
        createNewEvent(.Learning, startDate: _getTodayDateWithTime(5, minute: 45)!)
        
        createNewEvent(.Troubleshooting, startDate: _getTomorrowDateWithTime(4, minute: 15)!)
        createNewEvent(.Learning, startDate: _getTomorrowDateWithTime(4, minute: 50)!)
        createNewEvent(.Productivity, startDate: _getTomorrowDateWithTime(5, minute: 30)!)
        createNewEvent(.Rework, startDate: _getTomorrowDateWithTime(8, minute: 0)!)
        createNewEvent(.Pause, startDate: _getTomorrowDateWithTime(16, minute: 0)!)
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotification(Notification.EventAdded.notification(self))
    }
    
    class func deleteAllEvents()
    {
        IdeaFlowEvent.MR_truncateAll()
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        NSNotificationCenter.defaultCenter().postNotification(Notification.AllEventsDeleted.notification(self))
    }
}