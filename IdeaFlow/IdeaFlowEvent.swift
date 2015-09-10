//
//  IdeaFlowEvent.swift
//  
//
//  Created by Matt Hayes on 8/15/15.
//
//

import Foundation
import CoreData

@objc(IdeaFlowEvent)
class IdeaFlowEvent: NSManagedObject
{
    @NSManaged var eventType: NSNumber
    @NSManaged var startTimeStamp: NSDate
    @NSManaged var identifier: String
    @NSManaged var notes: NSSet
}
