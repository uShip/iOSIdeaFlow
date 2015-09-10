//
//  IdeaFlowEvent+Previous.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/4/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation

extension IdeaFlowEvent
{
    func getPreviousEvent() -> IdeaFlowEvent?
    {
        return IdeaFlowEvent.getPreviousEvent(startTimeStamp)
    }
    
    class func getPreviousEvent(startTimeStamp: NSDate) -> IdeaFlowEvent?
    {
        let predicate = NSPredicate(format: "startTimeStamp < %@", argumentArray: [startTimeStamp])
        if let pastEvents = IdeaFlowEvent.MR_findAllSortedBy("startTimeStamp", ascending: false, withPredicate: predicate) as? [IdeaFlowEvent]
        {
            if pastEvents.count > 0
            {
                return pastEvents[0]
            }
        }
        return nil
    }
    
    func getNextEvent() -> IdeaFlowEvent?
    {
        let predicate = NSPredicate(format: "startTimeStamp > %@", argumentArray: [startTimeStamp])
        if let nextEvents = IdeaFlowEvent.MR_findAllSortedBy("startTimeStamp", ascending: true, withPredicate: predicate) as? [IdeaFlowEvent]
        {
            if nextEvents.count > 0
            {
                return nextEvents[0]
            }
        }
        return nil
    }
}