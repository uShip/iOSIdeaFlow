//
//  IdeaFlowEvent+Stuff.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation

enum IdeaFlowEventType: String
{
    case Productivity = "Productivity"
    case Troubleshooting = "Troubleshooting"
    case Learning = "Learning"
    case Rework = "Rework"
    case Unknown = "Unknown"
}

extension IdeaFlowEvent
{
    func eventTypeName() -> String
    {
        switch eventType.integerValue
        {
        case 0:
            return IdeaFlowEventType.Productivity.rawValue
        case 1:
            return IdeaFlowEventType.Troubleshooting.rawValue
        case 2:
            return IdeaFlowEventType.Learning.rawValue
        case 3:
            return IdeaFlowEventType.Rework.rawValue
        default:
            return IdeaFlowEventType.Unknown.rawValue
        }
    }
    
    class func getPrevEvent() -> IdeaFlowEvent?
    {
        if IdeaFlowEvent.MR_numberOfEntities().intValue <= 0 {
            return nil
        }
        return IdeaFlowEvent.MR_findFirstOrderedByAttribute("startTimeStamp", ascending: false)
    }
    
    class func createNewEvent(eventType: IdeaFlowEventType) {
        
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
        
        NSNotificationCenter.defaultCenter().postNotificationName("New Event", object: self)
    }
}