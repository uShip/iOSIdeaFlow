//
//  IdeaFlowNote.swift
//  
//
//  Created by Matt Hayes on 8/15/15.
//
//

import Foundation
import CoreData

@objc(IdeaFlowNote)
class IdeaFlowNote: NSManagedObject
{
    @NSManaged var timeStamp: NSDate
    @NSManaged var noteContent: String
    @NSManaged var event: IdeaFlowEvent

}
